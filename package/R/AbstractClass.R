AbstractClass <- R6::R6Class(
  classname = "AbstractClass",
  portable = TRUE,
  parent_env = RONA_WORLD,
  public = list(
    initialize = function() {
      flog.fatal("Initialized an abstract")
      stop(paste(class(self)[1], ERROR_IS_ABSTRACT_CLASS))

      invisible(self)
    }
  )
)

