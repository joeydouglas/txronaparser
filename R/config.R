default_config <- function() {
  yaml::read_yaml(
    DEFAULT_CONFIG_FILE_PATH,
    eval.expr = TRUE
  )
}

validate_config <- function(config_to_validate) {
  validator <- jsonvalidate::json_validator(CONFIG_SCHEMA_PATH)
  validator(
    jsonlite::toJSON(config_to_validate, auto_unbox = TRUE),
    verbose = TRUE,
    error = TRUE
  )
}

write_config <- function(config = NULL) {
  if (is.null(config)) {
    if (exists("trp_config", envir = .GlobalEnv)) {
      new_config <- .GlobalEnv$trp_config
    } else {
      new_config <- default_config()
    }
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

load_config <- function(config_file_path) {
  defaults <- default_config()
  if (fs::is_file(config_file_path)) {
    path_to_load <- config_file_path
  } else if (fs::is_dir(config_file_path)) {
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
  loaded_config <- yaml::read_yaml(
    path_to_load,
    eval.expr = TRUE
  )
  validate_config(loaded_config)
  assign(
    "trp_config",
    loaded_config,
    envir = .GlobalEnv
  )
}
