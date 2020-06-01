#' @export
bootstrap <- function(config_file_path = NULL) {
  load_config(config_file_path = config_file_path)
  write_config(config)
  for (data_prefix in names(config$data_lists)) {
    if (config$data_lists[[data_prefix]]$save) {
      fs::dir_create(fs::path_join(
        config$working_directory,
        data_prefix
      ))
    }
  }
}

#' @export
nuke_content <- function(are_you_sure = FALSE) {
  if (are_you_sure) {
    fs::file_delete(config$working_directory)
  } else {
    warning(WARNING_NUKE_CONTENT)
  }
}
