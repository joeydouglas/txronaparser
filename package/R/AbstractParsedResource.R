# Copyright 2020 CJ Harries
# Licensed under http://www.apache.org/licenses/LICENSE-2.0

#' AbstractParsedResource
AbstractParsedResource <- R6::R6Class(
  classname = "AbstractParsedResource",
  portable = TRUE,
  parent_env = RONA_WORLD,
  inherit = AbstractResource,
  public = list(
    #' @description
    #' initialize
    #' @param raw_data raw_data
    #' @param can_spawn can_spawn
    #' @param init_data init_data
    initialize = function(raw_data = NULL, can_spawn = FALSE, init_data = NULL) {
      flog.trace("Called initialize on AbstractParsedResource with %s", can_spawn)
      if (!is.null(raw_data)) {
        private$.raw_value = raw_data
        private$.should_extract = FALSE
      }
      private$.can_spawn = can_spawn
      private$.column_lead = init_data$column_lead
      private$.table_lead = init_data$table_lead
      private$.table_tail = init_data$table_tail
      private$.sql_table = init_data$sql_table

      invisible(self)
    },
    #' @description
    #' extract
    #' @param force force
    extract = function(force = private$.should_extract) {
      if (force) {
        private$.internal_extract()
      }
    },
    #' @description
    #' transform
    transform = function() {
      private$.generic_pre_transform()
      private$.strip_population()
      private$.generic_transform()
    },
    #' @description
    #' load
    load = function() {
      private$.generic_load()
    },
    #' @description
    #' get_population_data
    get_population_data = function() {
      private$.population_data
    }
  ),
  private = list(
    .internal_extract = function() { stop(ERROR_IS_ABSTRACT_METHOD) },
    #' @importFrom magrittr %>%
    .generic_pre_transform = function() {
      # Extract only the data from the provided sheet
      private$.value <- private$.raw_value %>%
        dplyr::slice(which(.[,1] == private$.table_lead):which(.[,1] == private$.table_tail)) %>%
        # Convert the first row to column names
        `colnames<-`(tolower(stringr::str_replace_all(.[1,], "\\s+", "_"))) %>%
        .[-1,] %>%
        dplyr::mutate_at(dplyr::vars(c("population", dplyr::starts_with(private$.column_lead))), as.numeric) %>%
        dplyr::mutate(county_name = stringr::str_replace_all(county_name, "\\s+", "_"))
    },
    #' @importFrom magrittr %>%
    .strip_population = function() {
      private$.population_data <- private$.value[,1:2]

      private$.value <- private$.value %>%
        # Strip populations column
        .[,-2]
    },
    #' @importFrom magrittr %>%
    .generic_transform = function() {
      private$.value <- private$.value %>%
        # Reshape the data into rows of (county name, date, total X count)
        tidyr::pivot_longer(
          cols = dplyr::starts_with(private$.column_lead),
          names_to = "date",
          values_to = "temp_col"
        ) %>%
        # Convert the string date to something programmatically usable
        dplyr::mutate(date = as.Date(
          stringr::str_replace(date, "^.*?(\\d+|[a-z]+)[-/_\\s](\\d+)\\*?\\s*$", "2020-\\1-\\2"),
          tryFormats = c("%Y-%m-%d", "%Y-%B-%d")
        )) %>%
        # Reshape the data into rows of (date, total X in county a, total X in county b, ...)
        tidyr::pivot_wider(
          names_from = county_name,
          values_from = temp_col,
          values_fill = 0
        ) %>%
        dplyr::arrange(date) %>%
        tidyr::complete(
          date = seq.Date(min(date), max(date), by = "day"),
        )
    },
    .generic_load = function() {
      connection <- DBI::dbConnect(
        drv = RMariaDB::MariaDB(),
        group = "txronaparser"
      )
      if (!is.na(private$.population_data)) {
        dplyr::copy_to(
          connection,
          private$.population_data,
          "population_data",
          temporary = FALSE,
          overwrite = TRUE
        )
      }
      dplyr::copy_to(
        connection,
        private$.value,
        private$.sql_table,
        temporary = FALSE,
        overwrite = TRUE
      )
      DBI::dbDisconnect(connection)
    },
    .should_extract = TRUE,
    .raw_value = NA,
    .column_lead = NA,
    .table_lead = NA,
    .table_tail = NA,
    .sql_table = NA,
    .population_data = NA
  )
)
