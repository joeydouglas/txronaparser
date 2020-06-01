#' @importFrom magrittr %>%
#' @export
etl_parser_county_cases <- function(raw_spreadsheet_data) {
  # Define county table lead and tail
  table_lead <- "County Name"
  table_tail <- "Total"

  # Extract only the data from the provided sheet
  usable_spreadsheet <- raw_spreadsheet_data %>%
    dplyr::slice(which(.[,1] == table_lead):which(.[,1] == table_tail)) %>%
    # Convert the first row to column names
    `colnames<-`(tolower(stringr::str_replace(.[1,], "\\s+", "_"))) %>%
    .[-1,] %>%
    dplyr::mutate_at(dplyr::vars(c("population", dplyr::starts_with("cases"))), as.numeric) %>%
    dplyr::mutate(county_name = stringr::str_replace(county_name, "\\s+", "_"))

  # Separate population data
  population_data <- usable_spreadsheet[,1:2]

  total_case_data <- usable_spreadsheet %>%
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

  list(
    "population_data" = population_data,
    "total_case_data" = total_case_data
  )
}
