# Copyright 2020 CJ Harries
# Licensed under http://www.apache.org/licenses/LICENSE-2.0

ResourceOrchestrator <- R6::R6Class(
  classname = "ResourceOrchestrator",
  portable = TRUE,
  parent_env = RONA_WORLD,
  public = list(
    e2e_automated = function(){
      flog.info("Beginning a fully automated run")
      root <- RootResource$new(TRUE)
      RONA_WORLD[[tolower("RootResource")]] <- root
      root$etl()$spawn()
    }
  )
)
