# Copyright 2020 CJ Harries
# Licensed under http://www.apache.org/licenses/LICENSE-2.0

#' ParsedResourceCasesoverTimebyCounty
ParsedResourceCasesoverTimebyCounty <- R6::R6Class(
  classname = "ParsedResourceCasesoverTimebyCounty",
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
      init_data = PARSED_RESOURCE_DATA[["CasesoverTimebyCounty"]]
    ) {
      super$initialize(raw_data = raw_data, can_spawn = can_spawn, init_data = init_data)
    },
    #' @description
    #' load
    load = function() {
      connection <- DBI::dbConnect(
        drv = RMariaDB::MariaDB(),
        group = "txronaparser"
      )
      dplyr::copy_to(
        connection,
        private$.population_data,
        "population_data",
        temporary = FALSE,
        overwrite = TRUE
      )
      dplyr::copy_to(
        connection,
        private$.value,
        "total_case_data",
        temporary = FALSE,
        overwrite = TRUE
      )
      DBI::dbDisconnect(connection)
    },
    #' @description
    #' transform
    #' @importFrom magrittr %>%
    transform = function() {
      # # Extract only the data from the provided sheet
      # usable_spreadsheet <- private$.raw_value %>%
      #   dplyr::slice(which(.[,1] == private$.table_lead):which(.[,1] == private$.table_tail)) %>%
      #   # Convert the first row to column names
      #   `colnames<-`(tolower(stringr::str_replace(.[1,], "\\s+", "_"))) %>%
      #   .[-1,] %>%
      #   dplyr::mutate_at(dplyr::vars(c("population", dplyr::starts_with(private$.column_lead))), as.numeric) %>%
      #   dplyr::mutate(county_name = stringr::str_replace(county_name, "\\s+", "_"))
      private$.generic_pre_transform()
      private$.strip_population()
      private$.generic_transform()
    }
  ),
  private = list(
    .spawn = function(){ invisible(self) }
  )
)
