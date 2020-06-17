# Copyright 2020 CJ Harries
# Licensed under http://www.apache.org/licenses/LICENSE-2.0

AbstractResource <- R6::R6Class(
  classname = "AbstractResource",
  portable = TRUE,
  parent_env = RONA_WORLD,
  inherit = AbstractClass,
  public = list(
    extract = function() { stop(ERROR_IS_ABSTRACT_METHOD) },
    transform = function() { stop(ERROR_IS_ABSTRACT_METHOD) },
    load = function() { stop(ERROR_IS_ABSTRACT_METHOD) },
    etl = function() {
      self$extract()
      self$transform()
      self$load()

      invisible(self)
    },
    spawn = function(...) {
      if (private$.can_spawn) {
        private$.spawn(...)
      }

      invisible(self)
    }
  ),
  active = list(
    name = function(new_name) {
      if (missing(new_name)) {
        private$.name
      } else {
        stopifnot(is.character(new_name), length(new_name) == 1)
        private$.name <- new_name
      }
    },
    value = function(new_value) {
      if (missing(new_value)) {
        private$.value
      } else {
        private$.value <- new_value
      }
    }
  ),
  private = list(
    .name = NA,
    .value = NA,
    .can_spawn = FALSE,
    .spawn = function() { stop(ERROR_IS_ABSTRACT_METHOD) }
  )
)
