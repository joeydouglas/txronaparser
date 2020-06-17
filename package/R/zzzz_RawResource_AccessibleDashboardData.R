#' Skipping this; it's the processed stuff visible on the main page
RawResourceAccessibleDashboardData <- R6::R6Class(
  classname = "RawResourceAccessibleDashboardData",
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
