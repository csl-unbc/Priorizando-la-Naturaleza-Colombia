### run locally

### install dependencies
# > renv::restore()
# libs installed locally in:
#   building: renv/staging/1/
#   cache: .cache/R/renv/

### rebuild a library using renv (if a lib in the system updated, such as gdal)
## first search which libraries are linking
# > for file in (find ~/.cache/R/renv/cache/v5/linux-arch-rolling -name "*.so")
#      ldd $file | grep "not found"; and echo $file
#   end
## then rebuild the library
# > renv::rebuild("sf", recursive = TRUE)
# > library(sf)

### prepare data
# > make data

### run app
export R_SHINY_HOST=127.0.0.1
export R_SHINY_PORT=3939

Rscript app.R
