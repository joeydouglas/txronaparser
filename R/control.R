#' @export
bootstrap <- function(config_file_path = NULL) {
  load_config(config_file_path = config_file_path)
  write_config(trp_config)
  for (data_prefix in DATA_LIST_TYPES) {
    if (trp_config$data_lists[[data_prefix]]$save) {
      fs::dir_create(fs::path(
        trp_config$working_directory,
        data_prefix
      ))
    }
  }
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
