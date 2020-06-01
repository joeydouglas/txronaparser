# Look into making this a singleton
insecure_handler_factory <- function() {
  insecure_handle <- curl::new_handle()
  curl::handle_setopt(insecure_handle, SSL_VERIFYPEER = 0)

  insecure_handle
}

# May need to include ways to pass args to readxl
load_remote_spreadsheet <- function(spreadsheet_url, handle = insecure_handler_factory()) {
  temp_spreadsheet <- tempfile(fileext = paste(".", fs::path_ext(spreadsheet_url), sep = ""))
  curl::curl_download(spreadsheet_url, temp_spreadsheet, handle = handle)
  raw_spreadsheet <- readxl::read_excel(temp_spreadsheet, na = "")
  unlink(temp_spreadsheet)

  raw_spreadsheet
}
