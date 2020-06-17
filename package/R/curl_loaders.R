# Copyright 2020 CJ Harries
# Licensed under http://www.apache.org/licenses/LICENSE-2.0

factory_curl_loader <- function(file_loader) {
  force(file_loader)
  # insecure_handle <- curl::new_handle(SSL_VERIFYPEER = 0)
  function(url, ...) {
    flog.trace("Downloading %s", url)
    temp_storage <- fs::file_temp()
    # curl::curl_download(url, temp_storage, handle = insecure_handle)
    curl::curl_download(url, temp_storage)
    downloaded_content <- do.call(file_loader, list(temp_storage, ...))
    unlink(temp_storage)

    downloaded_content
  }
}

excel_curl_loader <- factory_curl_loader(readxl::read_excel)

html_curl_loader <- factory_curl_loader(xml2::read_html)
