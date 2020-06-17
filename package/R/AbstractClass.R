# Copyright 2020 CJ Harries
# Licensed under http://www.apache.org/licenses/LICENSE-2.0

#' AbstractClass
AbstractClass <- R6::R6Class(
  classname = "AbstractClass",
  portable = TRUE,
  parent_env = RONA_WORLD,
  public = list(
    #' @description
    #' initialize
    initialize = function() {
      flog.fatal("Initialized an abstract")
      stop(paste(class(self)[1], ERROR_IS_ABSTRACT_CLASS))

      invisible(self)
    }
  )
)

