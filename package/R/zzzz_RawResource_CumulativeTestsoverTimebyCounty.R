# Copyright 2020 CJ Harries
# Licensed under http://www.apache.org/licenses/LICENSE-2.0

#' RawResourceCumulativeTestsoverTimebyCounty
RawResourceCumulativeTestsoverTimebyCounty <- R6::R6Class(
  classname = "RawResourceCumulativeTestsoverTimebyCounty",
  portable = TRUE,
  parent_env = RONA_WORLD,
  inherit = AbstractRawResource,
  public = list(
    #' @description
    #' transform
    transform = function() { invisible(self) },
    #' @description
    #' load
    load = function() { invisible(self) }
  ),
  private = list(
    .spawn = function()(
      print(private$name)
    )
  )
)
