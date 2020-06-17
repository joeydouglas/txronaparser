# Copyright 2020 CJ Harries
# Licensed under http://www.apache.org/licenses/LICENSE-2.0

#' ParsedResourceCumulativeTestsoverTimebyCounty
ParsedResourceCumulativeTestsoverTimebyCounty <- R6::R6Class(
  classname = "ParsedResourceCumulativeTestsoverTimebyCounty",
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
      init_data = PARSED_RESOURCE_DATA[["CumulativeTestsoverTimebyCounty"]]
    ) {
      super$initialize(raw_data = raw_data, can_spawn = can_spawn, init_data = init_data)
    },
    #' @description
    #' transform
    transform = function() {
      private$.value <- private$.raw_value %>%
        dplyr::slice(which(.[,1] == private$.table_lead):which(.[,1] == private$.table_tail)) %>%
        `colnames<-`(tolower(stringr::str_replace_all(.[1,], "\\s+", "_"))) %>%
        .[-1,] %>%
        dplyr::mutate_at(dplyr::vars(dplyr::starts_with(private$.column_lead)), as.numeric) %>%
        dplyr::rename(county_name = county) %>%
        dplyr::mutate(county_name = stringr::str_replace(county_name, "\\s+", "_"))
      private$.generic_transform()
    }
  ),
  private = list(
    .spawn = function(){ invisible(self) }
  )
)
