#' @include internal.R
NULL

#' Spatial data statistics
#'
#' Calculate statistics for a spatial dataset.
#'
#' @param x [sf::st_sf()] or a combined [terra::rast] or [data.frame] dataset object.
#'
#' @param type `character` indicating whether the dataset contains
#'   continuous (i.e. `"continuous"`) or categorical (i.e. `"categorical"`)
#'   data.
#'
#' @param index `integer` or `character` value indicating the
#'   field or layer for which to calculate statistics.
#'   Defaults to 1, such that the first field/layer is used to calculate
#'   statistics.
#'
#' @return A `list` containing statistics for the data.
#'
#' @export
spatial_data_statistics <- function(x, type, index = 1) {
  UseMethod("spatial_data_statistics", x)
}

#' @rdname spatial_data_statistics
#' @export
spatial_data_statistics.sf <- function(x, type, index = 1) {
  # assert valid arguments
  assertthat::assert_that(
    inherits(x, "sf"),
    assertthat::is.string(type),
    assertthat::noNA(type),
    type %in% c("continuous", "categorical", "manual"),
    assertthat::is.string(index) || assertthat::is.count(index),
    assertthat::noNA(index)
  )
  if (is.character(index)) {
    assertthat::assert_that(
      assertthat::has_name(x, index)
    )
  }

  # convert index to integer if field name supplied
  if (is.character(index)) {
    index <- which(names(x) == index)
  }

  # calculate statistics
  if (identical(type, "continuous")) {
    ## continuous data
    out <- list(
      total = sum(x[[index]], na.rm = TRUE),
      min_value = min(x[[index]], na.rm = TRUE),
      max_value = max(x[[index]], na.rm = TRUE)
    )
  } else {
    ## categorical data
    out <- list(
      total = sum(x[[index]], na.rm = TRUE),
      values = sort(unique(x[[index]], na.rm = TRUE))
    )
  }

  # return result
  out
}

#' @rdname spatial_data_statistics
#' @export
spatial_data_statistics.SpatRaster <- function(x, type, index = 1) {
  # assert valid arguments
  assertthat::assert_that(
    inherits(x, "SpatRaster"),
    assertthat::is.string(type),
    assertthat::noNA(type),
    #type %in% c("continuous", "categorical", "manual"),
    assertthat::is.string(index) || assertthat::is.count(index),
    assertthat::noNA(index)
  )
  if (is.character(index)) {
    assertthat::assert_that(
      index %in% names(x)
    )
  }

  # convert index to integer if field name supplied
  if (is.character(index)) {
    index <- which(names(x) == index)
  }

  # calculate statistics
  if (identical(type, "continuous")) {
    ## continuous data
    out <- list(
      total = terra::global(x[[index]], fun="sum")$sum,
      min_value = terra::global(x[[index]], fun="min")$min,
      max_value = terra::global(x[[index]], fun="max")$max
    )
  } else {
    ## categorical data
    out <- list(
      total = terra::global(x[[index]], fun="sum")$sum,
      values = sort(terra::unique(x[[index]])[[1]])
    )
  }

  # return result
  out
}

#' @rdname spatial_data_statistics
#' @export
spatial_data_statistics.data.frame <- function(x, type, index = 1) {
  # assert valid arguments
  assertthat::assert_that(
    inherits(x, c('tbl_df', 'tbl', 'data.frame')),
    assertthat::is.string(type),
    assertthat::noNA(type),
    #type %in% c("continuous", "categorical", "manual"),
    assertthat::is.string(index) || assertthat::is.count(index),
    assertthat::noNA(index)
  )
  if (is.character(index)) {
    assertthat::assert_that(
      index %in% names(x)
    )
  }
  
  # convert index to integer if field name supplied
  if (is.character(index)) {
    index <- which(names(x) == index)
  }
  
  # calculate statistics
  if (identical(type, "continuous")) {
    ## continuous data
    out <- list(
      total = sum(x[[index]]),
      min_value = min(x[[index]]),
      max_value = max(x[[index]])
    )
  } else {
    ## categorical data
    out <- list(
      total = sum(x[[index]]),
      values = sort(unique(x[[index]]))
    )
  }
  
  # return result
  out
}
