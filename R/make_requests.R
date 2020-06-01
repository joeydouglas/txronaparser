#' Look into making this a singleton
insecure_handler_factory <- function() {
  insecure_handle <- curl::new_handle()
  curl::handle_setopt(insecure_handle, SSL_VERIFYPEER = 0)

  insecure_handle
}

#' @note May need to include ways to pass args to readxl
load_remote_spreadsheet <- function(spreadsheet_url, handle = insecure_handler_factory()) {
  temp_spreadsheet <- tempfile(fileext = paste(".", fs::path_ext(spreadsheet_url), sep = ""))
  curl::curl_download(spreadsheet_url, temp_spreadsheet, handle = handle)
  raw_spreadsheet <- readxl::read_excel(temp_spreadsheet, na = "")
  unlink(temp_spreadsheet)

  raw_spreadsheet
}

#' Scrapes the DSHS page for spreadsheets and returns the HTML
scrape_source_page <- function(url_to_scrape = trp_config$dshs_data_source$url, handle = insecure_handler_factory()) {
  temp_html <- tempfile()
  curl::curl_download(url_to_scrape, temp_html, handle = handle)
  data_html <- xml2::read_html(temp_html)
  unlink(temp_html)

  data_html
}
