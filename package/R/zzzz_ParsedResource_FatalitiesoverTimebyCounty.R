# Copyright 2020 CJ Harries
# Licensed under http://www.apache.org/licenses/LICENSE-2.0

#' ParsedResourceFatalitiesoverTimebyCounty
ParsedResourceFatalitiesoverTimebyCounty <- R6::R6Class(
  classname = "ParsedResourceFatalitiesoverTimebyCounty",
  portable = TRUE,
  parent_env = RONA_WORLD,
  inherit = AbstractParsedResource,
  public = list(
    #' @description
    #' initialize
    #' @param raw_data raw_data
    #' @param can_spawn can_spawn
    #' @param init_data init_data
    initialize = function(
      raw_data = NULL,
      can_spawn = FALSE,
      init_data = PARSED_RESOURCE_DATA[["FatalitiesoverTimebyCounty"]]
    ) {
      super$initialize(raw_data = raw_data, can_spawn = can_spawn, init_data = init_data)
    }
  ),
  private = list(
    .spawn = function(){ invisible(self) }
  )
)
