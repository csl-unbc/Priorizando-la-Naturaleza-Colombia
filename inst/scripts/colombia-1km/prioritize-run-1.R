### Run PrioritizR for the Colombia 1km data
#
# R --slave -e "source('inst/scripts/colombia-1km/prioritize-run-1.R')"
#


# Initialization
## load packages
devtools::load_all()
library(raster)
library(dplyr)

# Get input data file paths ----

## define variables
study_area_file <- "PU.tif"

# Preliminary processing
## prepare raster data
data_dir <- file.path("inst", "extdata", "data", "colombia-1km", "layers")

# Read metdata file
source(file.path("inst", "extdata", "data", "colombia-1km", "colombia-1km-load-metadata.R"))

## check if file exists
for (file in file.path(data_dir, metadata$File)) {
  if (!file.exists(file)) {
    stop("File does not exist: ", file)
  }
}

## Assort by order column - optional
metadata <- dplyr::arrange(metadata, Order)

## Validate metadata
assertthat::assert_that(
  all(metadata$Type %in% c("theme", "include", "weight", "exclude")),
  all(file.exists(file.path(data_dir, metadata$File)))
)

## Import study area (planning units) raster
study_area_data <- terra::rast(file.path(data_dir, study_area_file))

# Import rasters -----------------------------------------------------------

## Import themes, includes and weights rasters. If raster  variable do not
## compare to study area, re-project raster variable so it aligns
raster_data <- lapply(file.path(data_dir, metadata$File), function(x) {
  raster_x <- terra::rast(x)
  names(raster_x) <- tools::file_path_sans_ext(basename(x)) # file name
  if (terra::compareGeom(study_area_data, raster_x, stopOnError=FALSE)) {
    raster_x
  } else {
    print(paste0(names(raster_x), ": can not stack"))
    print(paste0("... aligning to ", names(study_area_data)))
    terra::project(x = raster_x, y = study_area_data, method = "ngb")
  }
})
# convert raster list to a combined SpatRaster
raster_data <- do.call(c, raster_data)

# Pre-processing -----------------------------------------------------------

## Create a mask layer based on the study area data
mask_data <- terra::clamp(study_area_data, 0, 1)

# change to Byte datatype for the raster data applying each raster
# TODO - if the data is OK this is not needed
raster_data <- lapply(raster_data, function(x) {
  x <- terra::clamp(x, 0, 255, datatype = "INT1U")
  x[is.na(x)] <- 0
  x[is.na(mask_data)] <- 255
  x[x == 255] <- NA
  x
})

## Prepare theme inputs ----
theme_data <- raster_data[[which(metadata$Type == "theme")]]
theme_goals <- metadata$Goal[metadata$Type == "theme"]

## Prepare weight inputs ----
weight_data <- raster_data[[which(metadata$Type == "weight")]]
weight_data <- terra::clamp(weight_data, lower = 0)
weight_values <- metadata$Values[metadata$Type == "weight"]

## Prepare include inputs ----
include_data <- raster_data[[which(metadata$Type == "include")]]
include_data <- round(include_data > 0.5)

## Prepare exclude inputs ----
exclude_data <- raster_data[[which(metadata$Type == "exclude")]]
exclude_data <- round(exclude_data > 0.5)

# Run PrioritizR ---------------------------------------------------------------

# Define the problem
problem <- prioritizr::problem(
  x = study_area_data,
  features = theme_data,
)
# add min set objective
problem <- prioritizr::add_min_set_objective(problem)
# add_manual_targets
theme_targets <- data.frame(
  feature = names(theme_data),
  type = "relative", sense = ">=",
  target = theme_goals
)
problem <- prioritizr::add_manual_targets(problem, targets = theme_targets)
# add_locked_in_constraints
problem <- prioritizr::add_locked_in_constraints(problem, include_data)
# add_locked_out_constraints
problem <- prioritizr::add_locked_out_constraints(problem, exclude_data)
# add_binary_decisions
problem <- prioritizr::add_binary_decisions(problem)
# add_cbc_solver
problem <- prioritizr::add_cbc_solver(problem)

# Solve the problem
solution <- prioritizr::solve.ConservationProblem(problem, run_checks = FALSE)

print(solution)

# Save the solution
solution_file <- file.path("inst", "extdata", "data", "colombia-1km", "colombia-1km-solution.tif")
terra::writeRaster(solution, solution_file, overwrite = TRUE, NAflag = -9999)

# load the solution
solution <- terra::rast(solution_file)