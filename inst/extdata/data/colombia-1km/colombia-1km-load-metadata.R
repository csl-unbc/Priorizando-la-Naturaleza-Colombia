# Initialization
## load packages
devtools::load_all()


#### THEME #####

metadata_path <- file.path("inst", "extdata", "data", "colombia-1km", "colombia-1km-metadata-theme.csv")
metadata <- tibble::as_tibble(
  utils::read.table(metadata_path, stringsAsFactors = FALSE, sep = ",", header = TRUE, comment.char = "")
)

#### INCLUDE #####

metadata_path <- file.path("inst", "extdata", "data", "colombia-1km", "colombia-1km-metadata-include.csv")
metadata_to_add <- tibble::as_tibble(
  utils::read.table(metadata_path, stringsAsFactors = FALSE, sep = ",", header = TRUE, comment.char = "")
)
metadata %>% add_row(metadata_to_add) -> metadata

#### EXCLUDE #####

metadata_path <- file.path("inst", "extdata", "data", "colombia-1km", "colombia-1km-metadata-exclude.csv")
metadata_to_add <- tibble::as_tibble(
  utils::read.table(metadata_path, stringsAsFactors = FALSE, sep = ",", header = TRUE, comment.char = "")
)
metadata %>% add_row(metadata_to_add) -> metadata

#### WEIGHT #####

metadata_path <- file.path("inst", "extdata", "data", "colombia-1km", "colombia-1km-metadata-weight.csv")
metadata_to_add <- tibble::as_tibble(
  utils::read.table(metadata_path, stringsAsFactors = FALSE, sep = ",", header = TRUE, comment.char = "")
)
metadata %>% add_row(metadata_to_add) -> metadata
