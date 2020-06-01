#' Finds all the Texas spreadsheets on the page
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

#' Either loads an existing ETL parser or returns an anonymous function that does nothing
get_etl_parser <- function(etl_parser_name) {
  full_name <- paste0("etl_parser_", etl_parser_name)
  if (exists(full_name, where = "package:txronaparser", mode = "function")) {
    return(get(full_name, mode = "function"))
  }
  function(x) { list() }
}

#' Load and parse a single remote spreadsheet
#'
#' @param spreadsheet_name The name (from the config list) of the spreadsheet to load
#' @return \itemize{
#'   \item \code{raw} The unparsed spreadsheet
#'   \item \code{parsed} If this spreadsheet has an ETL parser defined, then its return value. Otherwise empty.
#' }
#' @export
load_single_spreadsheet_data <- function(spreadsheet_name) {
  spreadsheet_config <- trp_config$spreadsheets[[spreadsheet_name]]
  new_raw_data <- load_remote_spreadsheet(spreadsheet_config$url)
  new_parsed_data <- get_etl_parser(spreadsheet_config$etl_parser)(new_raw_data)
  if (trp_config$data_lists[["raw"]]$save) {
    save_single_data_local(spreadsheet_name, new_raw_data, "raw")
  }
  if (trp_config$data_lists[["parsed"]]$save) {
    save_data_list_local(new_parsed_data, "parsed")
  }

  list(
    "raw" = new_raw_data,
    "parsed" = new_parsed_data
  )
}

#' Loads and parses all the remote spreadsheets into the singleton \code{.GlobalEnv$all_data}
#'
#' @param spreadsheet_config_list A list of spreadsheet configs as seen in the config file
#' @export
load_all_spreadsheet_data <- function(spreadsheet_config_list = trp_config$spreadsheets) {
  raw_data <- list()
  parsed_data <- list()
  for (spreadsheet_name in names(spreadsheet_config_list)) {
    results <- load_single_spreadsheet_data(spreadsheet_name)
    raw_data[[spreadsheet_name]] <- results[["raw"]]
    parsed_data <- append(parsed_data, results[["parsed"]])
  }

  assign(
    "all_data",
    list(
      "raw" = raw_data,
      "parsed" = parsed_data
    ),
    .GlobalEnv
  )
}
