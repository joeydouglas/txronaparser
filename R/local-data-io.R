#' @export
save_single_data_local <- function(data_name, data_contents, data_list_type = "misc") {
  data_directory <- fs::path(trp_config$working_directory, data_list_type)
  fs::dir_create(data_directory)
  saveRDS(
    data_contents,
    fs::path(
      data_directory,
      paste0(data_name, ".rds")
    )
  )
}

#' @export
save_data_list_local <- function(data_list, data_list_type = "misc") {
  for (data_name in names(data_list)) {
    save_single_data_local(data_name, data_list[[data_name]], data_list_type)
  }
}

#' @export
save_all_data_local <- function(new_data = all_data) {
  for (data_list_type in names(new_data)) {
    save_data_list_local(new_data[[data_list_type]], data_list_type)
  }
}

#' @export
load_single_data_local <- function(data_name, data_list_type = "misc", data_file_path = NULL) {
  if (is.null(data_file_path)) {
    data_path <- fs::path(
      trp_config$working_directory,
      data_list_type,
      paste0(data_name, ".rds")
    )
  } else {
    data_path <- data_file_path
  }

  readRDS(data_path)
}

#' @export
load_data_list_local <- function(data_list_type = "misc") {
  data_files <- fs::dir_ls(
    fs::path(
      trp_config$working_directory,
      data_list_type
    ),
    fail = FALSE
  )
  loaded_data <- list()
  for (data_file_path in data_files) {
    data_name <- fs::path_ext_remove(fs::path_file(data_file_path))
    loaded_data[[data_name]] <- load_single_data_local(data_file_path = data_file_path)
  }

  loaded_data
}

#' @export
load_all_data_local <- function() {
  loaded_data <- list()
  for (data_list_type in DATA_LIST_TYPES) {
    loaded_data[[data_list_type]] <- load_data_list_local(data_list_type)
  }

  assign(
    "all_data",
    loaded_data,
    .GlobalEnv
  )
}
