library(openxlsx)
library(dplyr)

# original data directory
# https://tnc.app.box.com/s/1my6ug09frxo95ixj9838cnbnqaiccxb/folder/268868257485
ORIG_DATA_DIR <- file.path("/run/media/xavier/SSD-Data/UNBC-UNDP/Priorizando la Naturaleza - Colombia/Data")
SPECIES_DATA_DIR <- file.path(ORIG_DATA_DIR, "features/21")

features <- read.xlsx(file.path(ORIG_DATA_DIR, "Cambio_Global/input/features_v4_4_24_(MAPV).xlsx"))

# Especies (8754)
species <- features[features$elemento_priorizacion == "Especies (8754)", ]

# list of species classes by class column
species_classes <- species %>%
  select(class) %>%
  distinct() %>%
  pull()

# iterate each species class
for (species_class in species_classes) {
  # create a folder for each species class
  species_class_dir <- file.path(SPECIES_DATA_DIR, species_class)
  dir.create(species_class_dir, showWarnings = FALSE)

  # species grouped by class
  species_grouped_by_class <- species %>% filter(class == species_class)

  for (i in 1:nrow(species_grouped_by_class)) {
    species_name <- species_grouped_by_class$class[i]
    species_path <- species_grouped_by_class$archivo[i]
    # get the filename from the path
    species_filename <- basename(species_path)

    # create a symbolic link to the species file
    species_symlink <- file.path(species_class_dir, species_filename)
    if (!file.exists(species_symlink)) {
      file.symlink(file.path(SPECIES_DATA_DIR, species_filename), species_symlink)
    }
  }

}