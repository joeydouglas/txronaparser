#' @export
bootstrap <- function(config_file_path = NULL) {
  load_config(config_file_path = config_file_path)
  write_config(trp_config)
  for (data_prefix in DATA_LIST_TYPES) {
    fs::dir_create(fs::path(
      trp_config$working_directory,
      data_prefix
    ))
  }
}

#' @export
reload_data_remote <- function() {
  load_all_spreadsheet_data()
}

#' @export
reload_data_local <- function() {
  load_all_data_local()
}

#' @export
nuke_content <- function(are_you_sure = FALSE) {
  if (are_you_sure) {
    if (!exists("trp_config")) {
      trp_config <- default_config()
    }
    fs::file_delete(trp_config$working_directory)
  } else {
    warning(WARNING_NUKE_CONTENT)
  }
}
