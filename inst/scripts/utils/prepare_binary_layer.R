# Pre-processing -----------------------------------------------------------
# This script is used to prepare binary layers
# Binary data:
#   1: data
#   0: nodata
#   255: NA

# Load the terra package
library(terra)

# Get the raster file path and output path from the command-line arguments
args <- commandArgs(trailingOnly = TRUE)

# Check if the arguments are provided
if (length(args) < 2) {
  stop("Please provide the path to the raster file and the output path as arguments.")
}

# Path to the input raster file
raster_path <- args[1]
raster_data <- terra::rast(raster_path)
print(paste("Processing:", raster_path))

# Path to the output raster file
out_path <- args[2]

PU <- terra::rast(file.path("PU_Nacional_1km.tif"))
mask_data <- terra::clamp(PU, 0, 1)

# apply the extent of the mask to the raster data using first extend and crop
raster_data <- terra::extend(raster_data, mask_data)
raster_data <- terra::crop(raster_data, ext(mask_data))

# apply the mask to the raster data
raster_data <- terra::clamp(raster_data, 0, 255, datatype = "INT1U")
raster_data[is.na(raster_data)] <- 0
raster_data[is.na(mask_data)] <- 255
raster_data[raster_data == 255] <- NA
raster_data[raster_data > 1] <- 0

# check if raster data is empty (without ones)
if (sum(raster_data[] == 1, na.rm = TRUE) == 0) {
  stop("The raster data is empty.")
}

writeRaster(raster_data, out_path, datatype = "INT1U", overwrite = TRUE)

print(paste("Finish:", out_path, "has been saved."))