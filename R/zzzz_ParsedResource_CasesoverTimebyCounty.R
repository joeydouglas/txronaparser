ParsedResourceCasesoverTimebyCounty <- R6::R6Class(
  classname = "ParsedResourceCasesoverTimebyCounty",
  portable = TRUE,
  parent_env = RONA_WORLD,
  inherit = AbstractParsedResource,
  public = list(
    initialize = function(
      init_data = PARSED_RESOURCE_DATA[["CasesoverTimebyCounty"]],
      raw_data = NULL,
      can_spawn = FALSE
      ) {
      super$initialize(raw_data = raw_data, can_spawn = can_spawn)
      private$.table_lead = init_data$table_lead
      private$.table_tail = init_data$table_tail
    },
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
        private$.total_case_data,
        "total_case_data",
        temporary = FALSE,
        overwrite = TRUE
      )
      DBI::dbDisconnect(connection)
    },
    transform = function() {
      # Extract only the data from the provided sheet
      usable_spreadsheet <- private$.raw_value %>%
        dplyr::slice(which(.[,1] == private$.table_lead):which(.[,1] == private$.table_tail)) %>%
        # Convert the first row to column names
        `colnames<-`(tolower(stringr::str_replace(.[1,], "\\s+", "_"))) %>%
        .[-1,] %>%
        dplyr::mutate_at(dplyr::vars(c("population", dplyr::starts_with("cases"))), as.numeric) %>%
        dplyr::mutate(county_name = stringr::str_replace(county_name, "\\s+", "_"))

      # Separate population data
      private$.population_data <- usable_spreadsheet[,1:2]

      private$.total_case_data <- usable_spreadsheet %>%
        # Strip populations column
        .[,-2] %>%
        # Reshape the data into rows of (county name, date, total case count)
        tidyr::pivot_longer(
          cols = dplyr::starts_with("cases"),
          names_to = "date",
          values_to = "total_cases"
        ) %>%
        # Convert the string date to something programmatically usable
        dplyr::mutate(date = as.Date(stringr::str_replace(date, "^.*(\\d+)-(\\d+).*$", "2020-\\1-\\2"))) %>%
        # Reshape the data into rows of (date, total cases in county a, total cases in county b, ...)
        tidyr::pivot_wider(
          names_from = county_name,
          values_from = total_cases,
          values_fill = 0
        ) %>%
        dplyr::arrange(date) %>%
        tidyr::complete(
          date = seq.Date(min(date), max(date), by = "day"),
        )

      private$.value = list(
        "population_data" = private$.population_data,
        "total_case_data" = private$.total_case_data
      )
    }
  ),
  private = list(
    .spawn = function(){ invisible(self) },
    .table_lead = NA,
    .table_tail = NA,
    .population_data = NA,
    .total_case_data = NA
  )
)
