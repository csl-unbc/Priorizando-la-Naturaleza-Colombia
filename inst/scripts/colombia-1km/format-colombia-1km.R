# Initialization
## load packages
devtools::load_all()
library(raster)
library(dplyr)

# Get input data file paths ----

## Planning units
# pixel values:
# 1: data
# 0: NA
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

# 3.0 Import rasters -----------------------------------------------------------

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

# 4.0 Pre-processing -----------------------------------------------------------

## pixel values for features, weights, includes, excludes:
# Binary data:
#   1: data
#   0: nodata
#   255: NA

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

# convert raster list to a combined SpatRaster
raster_data <- do.call(c, raster_data)

## Prepare theme inputs ----
theme_data <- raster_data[[which(metadata$Type == "theme")]]
names(theme_data) <- gsub(".", "_", names(theme_data), fixed = TRUE)
theme_names <- metadata$Name[metadata$Type == "theme"]
theme_groups <- metadata$Theme[metadata$Type == "theme"]
theme_colors <- metadata$Color[metadata$Type == "theme"]
theme_units <- metadata$Unit[metadata$Type == "theme"]
theme_visible <- metadata$Visible[metadata$Type == "theme"]
theme_provenance <- metadata$Provenance[metadata$Type == "theme"]
theme_hidden <- metadata$Hidden[metadata$Type == "theme"]
theme_legend <- metadata$Legend[metadata$Type == "theme"]
theme_labels <- metadata$Labels[metadata$Type == "theme"]
theme_values <- metadata$Values[metadata$Type == "theme"]
theme_goals <- metadata$Goal[metadata$Type == "theme"]
theme_downloadble <- metadata$Downloadable[metadata$Type == "theme"]

## Prepare weight inputs ----
weight_data <- raster_data[[which(metadata$Type == "weight")]]
weight_data <- terra::clamp(weight_data, lower = 0)
weight_names <- metadata$Name[metadata$Type == "weight"]
weight_colors <- metadata$Color[metadata$Type == "weight"]
weight_units <- metadata$Unit[metadata$Type == "weight"]
weight_visible <- metadata$Visible[metadata$Type == "weight"]
weight_hidden <- metadata$Hidden[metadata$Type == "weight"]
weight_provenance <- metadata$Provenance[metadata$Type == "weight"]
weight_legend <- metadata$Legend[metadata$Type == "weight"]
weight_labels <- metadata$Labels[metadata$Type == "weight"]
weight_values <- metadata$Values[metadata$Type == "weight"]
weight_downloadble <- metadata$Downloadable[metadata$Type == "weight"]

## Prepare include inputs ----
include_data <- raster_data[[which(metadata$Type == "include")]]
include_data <- round(include_data > 0.5)
include_names <- metadata$Name[metadata$Type == "include"]
include_colors <- metadata$Color[metadata$Type == "include"]
include_units <- metadata$Unit[metadata$Type == "include"]
include_visible <- metadata$Visible[metadata$Type == "include"]
include_provenance <- metadata$Provenance[metadata$Type == "include"]
include_legend <- metadata$Legend[metadata$Type == "include"]
include_labels <- metadata$Labels[metadata$Type == "include"]
include_hidden <- metadata$Hidden[metadata$Type == "include"]
include_downloadble <- metadata$Downloadable[metadata$Type == "include"]

## Prepare exclude inputs ----
exclude_data <- raster_data[[which(metadata$Type == "exclude")]]
exclude_data <- round(exclude_data > 0.5)
exclude_names <- metadata$Name[metadata$Type == "exclude"]
exclude_colors <- metadata$Color[metadata$Type == "exclude"]
exclude_units <- metadata$Unit[metadata$Type == "exclude"]
exclude_visible <- metadata$Visible[metadata$Type == "exclude"]
exclude_provenance <- metadata$Provenance[metadata$Type == "exclude"]
exclude_legend <- metadata$Legend[metadata$Type == "exclude"]
exclude_labels <- metadata$Labels[metadata$Type == "exclude"]
exclude_hidden <- metadata$Hidden[metadata$Type == "exclude"]
exclude_downloadble <- metadata$Downloadable[metadata$Type == "exclude"]

# 5.0 Build wheretowork objects ------------------------------------------------

## Create data set ----
dataset <- new_dataset_from_auto(
  c(theme_data, weight_data, include_data, exclude_data)
)

## Create themes ----
### loop over unique theme groups (ex. Endemic Species, Species at Risk, etc.)
themes <- lapply(seq_along(unique(theme_groups)), function(i) {

  #### store temp variables associated with group (i)
  curr_theme_groups <- unique(theme_groups)[i]
  curr_theme_data <- theme_data[[which(theme_groups == curr_theme_groups)]]
  curr_theme_data_names <- names(curr_theme_data)
  curr_theme_names <- theme_names[theme_groups == curr_theme_groups]
  curr_theme_colors <- theme_colors[theme_groups == curr_theme_groups]
  curr_theme_labels <- theme_labels[theme_groups == curr_theme_groups]
  curr_theme_units <- theme_units[theme_groups == curr_theme_groups]
  curr_theme_visible <- theme_visible[theme_groups == curr_theme_groups]
  curr_theme_hidden <- theme_hidden[theme_groups == curr_theme_groups]
  curr_theme_provenance <- theme_provenance[theme_groups == curr_theme_groups]
  curr_theme_legend <- theme_legend[theme_groups == curr_theme_groups]
  curr_theme_values <- theme_values[theme_groups == curr_theme_groups]
  curr_theme_goals <- theme_goals[theme_groups == curr_theme_groups]
  curr_theme_downloadable <- theme_downloadble[theme_groups == curr_theme_groups]

  #### create list of features (j) associated with group
  curr_features <- lapply(seq_along(curr_theme_names), function(j) {

    #### create variable (if manual legend)
    if (identical(curr_theme_legend[j], "manual")) {
      v <- new_variable(
        dataset = dataset,
        index = curr_theme_data_names[j],
        units = curr_theme_units[j],
        total = terra::global(curr_theme_data[[j]], fun ="sum", na.rm = TRUE)$sum,
        legend = new_manual_legend(
          values = c(as.numeric(trimws(unlist(strsplit(curr_theme_values[j], ","))))),
          colors = c(trimws(unlist(strsplit(curr_theme_colors[j], ",")))),
          labels = c(trimws(unlist(strsplit(curr_theme_labels[j], ","))))
        ),
        provenance = new_provenance_from_source(curr_theme_provenance[j])
      )

      #### create variable (if continuous legend)
    } else if (identical(curr_theme_legend[j], "continuous")) {
      v <-  new_variable_from_auto(
        dataset = dataset,
        index = curr_theme_data_names[j],
        units = curr_theme_units[j],
        type = "continuous",
        colors = curr_theme_colors[j],
        provenance = curr_theme_provenance[j],
        labels = "missing",
        hidden = curr_theme_hidden[j]
      )

      #### create variable (if null legend)
    } else if (identical(curr_theme_legend[j], "null")) {
      v <- new_variable(
        dataset = dataset,
        index = curr_theme_data_names[j],
        units = " ",
        total = terra::global(curr_theme_data[[j]], fun = "sum", na.rm = TRUE)$sum,
        legend = new_null_legend(),
        provenance = new_provenance_from_source("missing")
      )
    }

    #### create new feature
    new_feature(
      name = curr_theme_names[j],
      goal = curr_theme_goals[j],
      current = 0,
      limit_goal = 0,
      visible = curr_theme_visible[j],
      hidden = curr_theme_hidden[j],
      variable = v,
      downloadable = curr_theme_downloadable[j]
    )
  })

  #### create theme from list of features
  curr_theme <- new_theme(curr_theme_groups,curr_features)

  #### return theme
  curr_theme
})

## Create weights ----
### loop over each raster in weight_data
weights <- lapply(seq_len(terra::nlyr(weight_data)), function(i) {

  #### prepare variable (if manual legend)
  if (identical(weight_legend[i], "manual")) {
    v <- new_variable_from_auto(
      dataset = dataset,
      index = names(weight_data)[i],
      units = weight_units[i],
      type = "manual",
      colors = trimws(unlist(strsplit(weight_colors[i], ","))),
      provenance = weight_provenance[i],
      labels = trimws(unlist(strsplit(weight_labels[i], ",")))
    )

    #### prepare variable (if null legend)
  } else if (identical(weight_legend[i], "null")) {
    v <- new_variable(
      dataset = dataset,
      index = names(weight_data)[i],
      units = " ",
      total = terra::global(weight_data[[i]], fun = "sum", na.rm=TRUE)$sum,
      legend = new_null_legend(),
      provenance = new_provenance_from_source("missing")
    )

    ### prepare variable (if continuous legend)
  } else {
    v <- new_variable_from_auto(
      dataset = dataset,
      index = names(weight_data)[i],
      units = weight_units[i],
      type = "auto",
      colors = weight_colors[i],
      provenance = weight_provenance[i],
      labels = "missing",
      hidden = weight_hidden[i]
    )
  }

  #### create weight
  new_weight(name = weight_names[i], variable = v, visible = weight_visible[i],
             hidden = weight_hidden[i], downloadable = weight_downloadble[i])
})

## Create includes ----
### loop over each raster in include_data
includes <- lapply(seq_len(terra::nlyr(include_data)), function(i) {

  ### build legend
  if (identical(include_legend[i], "null")) {
    legend <- new_null_legend()
  } else {
    legend <- new_manual_legend(
      values = c(0, 1),
      colors = trimws(unlist(strsplit(include_colors[i], ","))),
      labels = unlist(strsplit(include_labels[i], ","))
    )
  }

  ### build include
  new_include(
    name = include_names[i],
    visible = include_visible[i],
    hidden = include_hidden[i],
    downloadable = include_downloadble[i],
    variable = new_variable(
      dataset = dataset,
      index = names(include_data)[i],
      units = " ",
      total = terra::global(include_data[[i]], fun = "sum", na.rm = TRUE)$sum,
      legend = legend,
      provenance = new_provenance_from_source(include_provenance[i])
    )
  )
})

## Create excludes ----
### loop over each raster in exclude_data
excludes <- lapply(seq_len(terra::nlyr(exclude_data)), function(i) {

  ### build legend
  if (identical(exclude_legend[i], "null")) {
    legend <- new_null_legend()
  } else {
    legend <- new_manual_legend(
      values = c(0, 1),
      colors = trimws(unlist(strsplit(exclude_colors[i], ","))),
      labels = unlist(strsplit(exclude_labels[i], ","))
    )
  }

  ### build exclude
  new_exclude(
    name = exclude_names[i],
    visible = exclude_visible[i],
    hidden = exclude_hidden[i],
    downloadable = exclude_downloadble[i],
    variable = new_variable(
      dataset = dataset,
      index = names(exclude_data)[i],
      units = " ",
      total = terra::global(exclude_data[[i]], fun = "sum", na.rm = TRUE)$sum,
      legend = legend,
      provenance = new_provenance_from_source(exclude_provenance[i])
    )
  )
})

# 6.0  Export Where To Work objects --------------------------------------------

# delete previous project
unlink("inst/extdata/projects/colombia-1km", recursive = TRUE, force = TRUE)
# Create output folder if needed
dir.create("inst/extdata/projects/colombia-1km", recursive = TRUE, showWarnings = FALSE)

## Save project to disk ----
write_project(
  x = append(append(themes, append(includes, weights)), excludes),
  dataset = dataset,
  name = "Colombia - 1km",
  path = "inst/extdata/projects/colombia-1km/colombia-1km.yaml",
  spatial_path = "inst/extdata/projects/colombia-1km/colombia-1km_spatial.tif",
  attribute_path = "inst/extdata/projects/colombia-1km/colombia-1km_attribute.csv.gz",
  boundary_path = "inst/extdata/projects/colombia-1km/colombia-1km_boundary.csv.gz",
  mode = "advanced",
  author_name = "Xavier C. Llano",
  author_email = "llano@unbc.ca"
)

# copy the solution colombia-1km-solution.tif to the project folder
file.copy(
  from = file.path("inst", "extdata", "data", "colombia-1km", "colombia-1km-solution.tif"),
  to = file.path("inst", "extdata", "projects", "colombia-1km", "colombia-1km-solution.tif")
)
