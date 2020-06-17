# Copyright 2020 CJ Harries
# Licensed under http://www.apache.org/licenses/LICENSE-2.0

#' RawResourceCasesoverTimebyCounty
RawResourceCasesoverTimebyCounty <- R6::R6Class(
  classname = "RawResourceCasesoverTimebyCounty",
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
    .spawn = function() {
      resource_name <- paste0("ParsedResource", private$.name)
      parsed_resource_class <- get(resource_name, RONA_WORLD)
      parsed_resource <- parsed_resource_class$new(
        raw_data = self$value,
        can_spawn = TRUE
      )
      RONA_WORLD[[tolower(resource_name)]] <- parsed_resource
      parsed_resource$etl()$spawn()
    }
  )
)
