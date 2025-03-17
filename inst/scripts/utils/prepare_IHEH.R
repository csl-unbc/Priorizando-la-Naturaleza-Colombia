library(raster)

LAYERS_DIR <- "/home/xavier/Projects/UNBC/Priorizando la Naturaleza - Colombia/Priorizando-la-Naturaleza-Colombia/inst/extdata/data/Nacional/Layers"

IHEH <- raster(file.path(LAYERS_DIR, "IHEH_2022.tif"))  # [0-100]

# Plot histogram
hist(IHEH,
     main = "Histogram for the IHEH layer",
     xlab = "Value",
     col = "lightblue",
     breaks = 20)  # Adjust breaks for bin size

# avoid pixels with zero cost, set to minimum value
IHEH[IHEH == 0] <- 1
# apply the log transformation
IHEH_log <- sqrt(IHEH)

# Plot histogram of log-transformed raster
hist(IHEH_log,
     main = "Histogram of the IHEH Log-Transformed",
     xlab = "Value",
     col = "lightblue",
     breaks = 20)  # Adjust breaks for bin size

# save the log-transformed raster
writeRaster(IHEH_log, file.path(LAYERS_DIR, "IHEH_2022_log.tif"), overwrite = TRUE)