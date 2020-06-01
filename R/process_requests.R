
# Finds all the Texas spreadsheets on the page
#' @importFrom magrittr %>%
parse_spreadsheet_urls <- function(data_html = scrape_source_page()) {
  urls_to_scrape <- data_html %>%
    xml2::xml_find_all(paste0(
      paste0("//h2[./u[text() = '", trp_config$dshs_data_source$h2_lead, "']]"),
      "/following-sibling::h6",
      "/a[",
      paste0("starts-with(@href, '", trp_config$dshs_data_source$href_lead, "')"),
      " and ",
      "(",
      "substring(@href, string-length(./@href) - 3) = 'xlsx'",
      " or ",
      "substring(@href, string-length(./@href) - 2) = 'xls'",
      ")",
      "]"
    )
    ) %>%
    xml2::xml_attr("href") %>%
    sapply(
      .,
      function(input) {
        paste0(
          gsub("/corona.*$", "", trp_config$dshs_data_source$url),
          input
        )
      },
      USE.NAMES = FALSE
    )

  urls_to_scrape
}

get_etl_parser <- function(etl_parser_name) {
  full_name <- paste0("etl_parser_", etl_parser_name)
  if (exists(full_name, envir = as.environment("package:txronaparser"))) {
    return(as.environment("package:txronaparser"))
  }
  function(x) { list() }
}

load_single_spreadsheet_data <- function(spreadsheet_name) {
  spreadsheet_config <- trp_config$spreadsheets[[spreadsheet_name]]
  new_raw_data <- load_remote_spreadsheet(spreadsheet_config$url)
  new_parsed_data <- get_etl_parser(spreadsheet_config$etl_parser)(new_raw_data)

  list(
    "raw" = new_raw_data,
    "parsed" = new_parsed_data
  )
}
