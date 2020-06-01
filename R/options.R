TRP_CONFIG <- settings::options_manager(
  working_directory = file.path(fs::path_home(), ".config", "txronaparser"),
  data_lists = list(
    "raw" = list(
      "save" = TRUE
    ),
    "parsed" = list(
      "save" = TRUE
    )
  )
)

#' @export
tx_rona_parser_options <- function(...) {
  settings::stop_if_reserved(...)
  TRP_CONFIG(...)
}

#' @export
reset_tx_rona_parser_options <- function() {
  settings::reset(TRP_CONFIG)
}
