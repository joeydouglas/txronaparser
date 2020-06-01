
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
