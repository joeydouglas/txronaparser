#' Saves a single data object
#'
#' @param data_name The object name
#' @param data_contents The actual value
#' @param data_list_type The data list type to store it with
#' @seealso \code{\link{DATA_LIST_TYPES}}
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

#' Saves a specific data list
#'
#' @param data_list The list to walk over and store
#' @param data_list_type The data list type to store it with
#' @seealso \code{\link{DATA_LIST_TYPES}}
#' @export
save_data_list_local <- function(data_list, data_list_type = "misc") {
  for (data_name in names(data_list)) {
    save_single_data_local(data_name, data_list[[data_name]], data_list_type)
  }
}

#' Saves all data present in the singleton \code{all_data}
#'
#' @param new_data The data to store; default is \code{all_data}
#' @export
save_all_data_local <- function(new_data = all_data) {
  for (data_list_type in names(new_data)) {
    save_data_list_local(new_data[[data_list_type]], data_list_type)
  }
}

#' Loads a single data object from either its name and list type or a full path
#'
#' @param data_name The object name
#' @param data_list_type The data list type to load
#' @param data_full_path Default \code{NULL}; if set will be used as the RDS path
#' @return The contents of the loaded RDS file
#' @seealso \code{\link{DATA_LIST_TYPES}}
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

#' Loads an entire data list type
#'
#' @param data_list_type The data list type to load
#' @return The entire loaded list
#' @seealso \code{\link{DATA_LIST_TYPES}}
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

#' Loads all data on disk into the singleton \code{.GlobalEnv$all_data}
#'
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
