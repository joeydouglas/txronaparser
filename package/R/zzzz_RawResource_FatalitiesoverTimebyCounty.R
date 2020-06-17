# Copyright 2020 CJ Harries
# Licensed under http://www.apache.org/licenses/LICENSE-2.0

RawResourceFatalitiesoverTimebyCounty <- R6::R6Class(
  classname = "RawResourceFatalitiesoverTimebyCounty",
  portable = TRUE,
  parent_env = RONA_WORLD,
  inherit = AbstractRawResource,
  public = list(
    transform = function() { invisible(self) },
    load = function() { invisible(self) }
  ),
  private = list(
    .spawn = function()(
      print(private$name)
    )
  )
)
