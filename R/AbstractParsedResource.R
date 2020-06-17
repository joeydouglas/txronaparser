AbstractParsedResource <- R6::R6Class(
  classname = "AbstractParsedResource",
  portable = TRUE,
  parent_env = RONA_WORLD,
  inherit = AbstractResource,
  public = list(
    initialize = function(raw_data = NULL, can_spawn = FALSE) {
      flog.trace("Called initialize on AbstractParsedResource with %s", can_spawn)
      if (!is.null(raw_data)) {
        private$.raw_value = raw_data
        private$.should_extract = FALSE
      }
      private$.can_spawn = can_spawn

      invisible(self)
    },
    extract = function(force = private$.should_extract) {
      if (force) {
        private$.internal_extract()
      }
    }
  ),
  private = list(
    .internal_extract = function() { stop(ERROR_IS_ABSTRACT_METHOD) },
    .should_extract = TRUE,
    .raw_value = NA
  )
)
