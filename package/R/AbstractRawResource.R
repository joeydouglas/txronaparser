# Copyright 2020 CJ Harries
# Licensed under http://www.apache.org/licenses/LICENSE-2.0

#' AbstractRawResource
AbstractRawResource <- R6::R6Class(
  classname = "AbstractRawResource",
  portable = TRUE,
  parent_env = RONA_WORLD,
  inherit = AbstractResource,
  public = list(
    #' @description
    #' initialize
    #' @param name name
    #' @param url url
    #' @param can_spawn can_spawn
    initialize = function(name, url, can_spawn = FALSE) {
      flog.trace("Called initialize on AbstractRawResource")
      flog.trace(name, name = "data")
      flog.trace(url, name = "data")
      flog.trace(can_spawn, name = "data")
      private$.can_spawn = can_spawn
      private$.name <- name
      private$.url <- url

      invisible(self)
    },
    #' @description
    #' extract
    extract = function() {
      flog.debug("Extracting data")
      flog.trace(private$url, name = "data")
      flog.trace(private$data, name = "data")
      self$value <- excel_curl_loader(private$.url)

      invisible(self)
    }
  ),
  private = list(
    .url = NA
  )
)
