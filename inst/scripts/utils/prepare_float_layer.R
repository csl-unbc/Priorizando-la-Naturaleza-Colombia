# Pre-processing -----------------------------------------------------------
# This script is used to prepare float layers

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
raster_data[is.na(mask_data)] <- NA
# where the data is nan and mask is 1 burn 0
raster_data[is.na(raster_data) & mask_data == 1] <- 0

writeRaster(raster_data, out_path, datatype = "FLT4S", overwrite = TRUE)

print(paste("Finish:", out_path, "has been saved."))