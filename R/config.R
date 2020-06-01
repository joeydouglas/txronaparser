#' Load the default config shipped with the package
#'
#' @return the default config
#' @export
default_config <- function() {
  yaml::read_yaml(
    DEFAULT_CONFIG_FILE_PATH,
    eval.expr = TRUE
  )
}

#' Validates a given config against the config schema. It will silently succeed
#' or loudly fail.
#'
#' @param config_to_validate Some config object to validate
#' @export
validate_config <- function(config_to_validate) {
  validator <- jsonvalidate::json_validator(CONFIG_SCHEMA_PATH)
  validator(
    jsonlite::toJSON(config_to_validate, auto_unbox = TRUE),
    verbose = TRUE,
    error = TRUE
  )
}

#' Writes the provided config object to the proper location
#'
#' @param config A config object
#' @export
write_config <- function(config = NULL) {
  if (is.null(config)) {
    if (exists("trp_config", envir = .GlobalEnv)) {
      new_config <- .GlobalEnv$trp_config
    } else {
      new_config <- default_config()
    }
  } else {
    new_config <- config
  }
  validate_config(new_config)
  if (fs::is_absolute_path(new_config$config_file)) {
    config_file_name = new_config$config_file
  } else {
    config_file_name = file.path(new_config$working_directory, new_config$config_file)
  }
  fs::dir_create(fs::path_dir(config_file_name))
  yaml::write_yaml(
    new_config,
    config_file_name
  )
}

#' Loads a config file. If nothing is passed, it loads the default. If a
#' directory is passed, it looks for `config.yml` in that directory. If anything
#' else is passed, it will attempt to load that as a file. If any of that fails,
#' this will return the defaults.
#'
#' The result is loaded as `.GlobalEnv$trp_config`.
#'
#' @param config_file_path A path
#' @export
load_config <- function(config_file_path = NULL) {
  defaults <- default_config()
  if (!is.null(config_file_path) && fs::is_file(config_file_path)) {
    path_to_load <- config_file_path
  } else if (!is.null(config_file_path) && fs::is_dir(config_file_path)) {
    path_to_load <- file.path(
      config.path,
      defaults$config_file
    )
  } else {
    path_to_load <- file.path(
      defaults$working_directory,
      defaults$config_file
    )
  }
  if (fs::is_file(path_to_load)) {
    loaded_config <- yaml::read_yaml(
      path_to_load,
      eval.expr = TRUE
    )
  } else {
    loaded_config <- defaults
  }
  validate_config(loaded_config)
  assign(
    "trp_config",
    loaded_config,
    envir = .GlobalEnv
  )
}

# Ensures all discovered spreadsheets are in the config file
generate_new_spreadsheets_config <- function(spreadsheet_urls = parse_spreadsheet_urls()) {
  new_spreadsheets <- trp_config$spreadsheets
  for (spreadsheet_url in spreadsheet_urls) {
    file_name = tolower(basename(spreadsheet_url))
    if (!(file_name %in% names(new_spreadsheets))) {
      new_spreadsheets[[file_name]] <- list(
        "url" = spreadsheet_url,
        "etl_parser" = ""
      )
    } else {
      new_spreadsheets[[file_name]]$url = spreadsheet_url
    }
  }

  new_spreadsheets
}
