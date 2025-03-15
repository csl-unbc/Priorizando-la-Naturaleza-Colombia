# Load required libraries
library(sf)          # For handling shapefiles
library(raster)      # For raster operations
library(terra)       # For modern raster operations

# Read the shapefile
# gdb <- st_read("ECOSISTEMAS_MEC_122024.gdb/a00000010.gdbtable", layer = "e_eccmc_100K_2024")
gdb <- st_read("SHAPE/e_eccmc_100K_2024.shp")

# Check the CRS is 4326
if(!identical(st_crs(gdb), 4326)) {
  gdb <- st_transform(gdb, crs = 4326)
}

# Get unique categories from gran_bioma column
biomas <- unique(gdb$gran_bioma)

# Create a template raster with 1km resolution
# Adjust extent to match your shapefile
ext <- extent(gdb)
template <- raster(ext,
                  resolution = 0.008333333333333329748,  # 1km resolution in meters
                  crs = projection(gdb))

# Create rasters for each biome category
raster_list <- list()

for(biome in biomas) {
    print(paste("Processing:", biome))
    # Subset features for current biome
    biome_subset <- gdb[gdb$gran_bioma == biome, ]
    # Rasterize - using a numeric value (1) for presence
    rast <- rasterize(biome_subset,
                    template,
                    field = 1,
                    background = 0,  # 0 for areas without the biome
    )

    # Define output file name
    output_file <- paste0("raster_", gsub(" ", "_", biome), ".tif")
    # Save the raster
    writeRaster(rast, output_file, format = "GTiff", overwrite = TRUE)

}

# Print summary
cat("\nProcessing complete!\n")
cat("Number of biomes processed:", length(biomas), "\n")
cat("Output files saved with prefix 'raster_' and biome name\n")
