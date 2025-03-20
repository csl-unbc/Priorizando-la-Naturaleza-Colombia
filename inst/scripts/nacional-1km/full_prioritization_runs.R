library(sf)
library(here)
library(stringr)
library(prioritizr)
library(slam)
library(glue)
library(raster)
library(terra)
library(openxlsx)
library(parallel)

# setwd("/home/xavier/Projects/UNBC/Priorizando la Naturaleza - Colombia/Priorizando-la-Naturaleza-Colombia/inst/extdata/data/Nacional")
setwd("/data/Priorizando-la-Naturaleza-Colombia/Full-Prioritizatio-Runs/Nacional")

# original data directory
# https://tnc.app.box.com/s/1my6ug09frxo95ixj9838cnbnqaiccxb/folder/268868257485
# ORIG_DATA_DIR <- "/run/media/xavier/SSD-Data/UNBC-UNDP/Priorizando la Naturaleza - Colombia/Data"
ORIG_DATA_DIR <- "/data/Priorizando-la-Naturaleza-Colombia/Full-Prioritizatio-Runs/data"

normalize <- function(r) {
  if (is.vector(r) || is.matrix(r)) {
      r_values <- r
  } else if (inherits(r, "Raster")) {
      r_values <- getValues(r)
  } else if (inherits(r, "SpatRaster")) {
    r_values <- terra::values(r)
  } else {
      stop("Unsupported data type")
  }
  min_val <- min(r_values, na.rm = TRUE)
  max_val <- max(r_values, na.rm = TRUE)
  if (min_val == max_val) {
      return(r)
  }
  norm <- (r - min_val) / (max_val - min_val)
  norm <- raster::clamp(norm, lower = 1e-4, useValues = TRUE)
  return(norm)
}

################################################################################
# Planning Units
PU <- raster("layers/PU_Nacional_1km.tif")

################################################################################
# Define the scenarios to run
scenarios <- read.xlsx("../scenarios_to_run_webtool.xlsx")
scenarios <- scenarios[scenarios$SIRAP == "Nacional" & (scenarios$costo == "PU" | scenarios$costo == "IHEH_2022"),]

# iterate over the scenarios
for (i in 1:nrow(scenarios)) {
  print(paste0("Running scenario: ", scenarios$escenario[i]))

  ################################################################################
  # Features

  feature_stack <- stack()

  # read the feature layer
  feature_list <- strsplit(scenarios$elemento_priorizacion[i], ",")[[1]] %>% str_trim()

  if ("Biomas" %in% feature_list) {
      biomas <- list.files("layers/Biomas", pattern = ".tif$", full.names = TRUE) %>%
      feature_stack <- stack(feature_stack, stack(mclapply(biomas, raster, mc.cores = parallel::detectCores())))
  }

  # load species richness for testing
  if (FALSE) {
    if ("Especies (8700)" %in% feature_list) {
        species <- list.files("layers/Especies", pattern = "^riqueza_especies_.*\\.tif$", full.names = TRUE)
        feature_stack <- stack(feature_stack, stack(mclapply(species, raster, mc.cores = parallel::detectCores())))
        # apply normalization
        feature_stack <- stack(mclapply(1:nlayers(feature_stack), function(i) normalize(feature_stack[[i]]), mc.cores = parallel::detectCores()))
    }
  } else {
    if ("Especies (8700)" %in% feature_list) {
        species <- list.files(file.path(ORIG_DATA_DIR, "features/21_fixed"), pattern = ".tif$", full.names = TRUE)
        feature_stack <- stack(feature_stack, stack(mclapply(species, raster, mc.cores = parallel::detectCores())))
    }
  }

  if ("Páramo" %in% feature_list) {
      paramos <- raster("layers/paramos.tif")
      feature_stack <- stack(feature_stack, paramos)
  }

  if ("Manglar" %in% feature_list) {
      manglares <- raster("layers/manglares.tif")
      feature_stack <- stack(feature_stack, manglares)
  }

  if ("Humedales" %in% feature_list) {
      humedales <- raster("layers/humedales.tif")
      feature_stack <- stack(feature_stack, humedales)
  }

  if ("Bosque seco" %in% feature_list) {
      bosque_seco <- raster("layers/bosque_seco.tif")
      feature_stack <- stack(feature_stack, bosque_seco)
  }

  if ("Carbono orgánico en suelos" %in% feature_list) {
      carbono_organico_suelos <- normalize(raster("layers/carbono_organico_suelos.tif"))
      feature_stack <- stack(feature_stack, carbono_organico_suelos)
  }

  if ("Biomasa aérea más biomasa subterránea" %in% feature_list) {
      biomasa_aerea_mas_subterranea <- normalize(raster("layers/biomasa_aerea_mas_subterranea.tif"))
      feature_stack <- stack(feature_stack, biomasa_aerea_mas_subterranea)
  }

  if ("Recarga de agua subterranea" %in% feature_list) {
      recarga_agua_subterranea <- normalize(raster("layers/recarga_agua_subterranea.tif"))
      feature_stack <- stack(feature_stack, recarga_agua_subterranea)
  }

  ################################################################################
  # Cost
  if ("IHEH_2022" == scenarios$costo[i]) {
    cost_layer <- raster("layers/IHEH_2022_log.tif")
  } else {
    cost_layer <- PU
  }

  ################################################################################
  # Targets
    targets <- as.numeric(strsplit(scenarios$sensibilidad[i], ",")[[1]])[[1]]/100

  ################################################################################
  # Includes
  include_stack <- stack()
  includes_list <- strsplit(scenarios$inclusion[i], ",")[[1]] %>% str_trim()

  if ("RUNAP" %in% includes_list) {
    runap <- raster("layers/RUNAP.tif")
    include_stack <- stack(include_stack, runap)
  }

  if ("OMECs" %in% includes_list) {
      omecs <- raster("layers/OMECs.tif")
      include_stack <- stack(include_stack, omecs)
  }

  combined_locked_in <- calc(include_stack, fun = function(x) as.integer(any(x == 1)))

  ################################################################################
  # Define and solve problem

  # create a problem
  cp_problem <- problem(terra::rast(cost_layer), terra::rast(feature_stack)) %>%
    add_min_set_objective() %>%
    add_relative_targets(targets) %>%
    add_locked_in_constraints(terra::rast(combined_locked_in)) %>%
    add_binary_decisions() %>%
    add_cbc_solver(threads = parallel::detectCores())

  # presolve_check(cp_problem)

  # solve the problem
  cp_solution <- solve(cp_problem, force = TRUE)

  # print the solution
  print(cp_solution)

  # save the solution
  file_name <- glue("solutions/{scenarios$escenario[i]}-solution.tif")
  terra::writeRaster(cp_solution, file_name, filetype = "GTiff", overwrite = TRUE)

}
