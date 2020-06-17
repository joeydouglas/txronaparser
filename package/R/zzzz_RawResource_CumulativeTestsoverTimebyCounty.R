RawResourceCumulativeTestsoverTimebyCounty <- R6::R6Class(
  classname = "RawResourceCumulativeTestsoverTimebyCounty",
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
