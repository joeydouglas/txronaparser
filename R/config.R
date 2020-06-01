default_config <- function() {
  yaml::read_yaml(
    DEFAULT_CONFIG_FILE_PATH,
    eval.expr = TRUE
  )
}

write_config <- function(config = NULL) {
  if (is.null(config)) {
    if (exists("trp_config", envir = .GlobalEnv)) {
      config <- .GlobalEnv$trp_config
    } else {
      config <- default_config()
    }
  }
  if (fs::is_absolute_path(config$config_file)) {
    config_file_name = config$config_file
  } else {
    config_file_name = file.path(config$working_directory, config$config_file)
  }
  fs::dir_create(fs::path_dir(config_file_name))
  yaml::write_yaml(
    config,
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
  assign(
    "trp_config",
    yaml::read_yaml(
      path_to_load,
      eval.expr = TRUE
    ),
    envir = .GlobalEnv
  )

}
