TX_RONA_PARSER_OPTIONS <- settings::options_manager(
  working_directory = file.path(fs::path_home(), ".config", "txronaparser"),
  save_raw_data = TRUE,
  save_parsed_data = TRUE
)


#' @export
tx_rona_parser_options <- function(...) {
  settings::stop_if_reserved(...)
  TX_RONA_PARSER_OPTIONS(...)
}

#' @export
reset_tx_rona_parser_options <- function() {
  settings::reset(TX_RONA_PARSER_OPTIONS)
}
