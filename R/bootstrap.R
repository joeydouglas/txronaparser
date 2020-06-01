#' @export
bootstrap <- function() {
  dir.create(
    TX_RONA_PARSER_OPTIONS$working_directory,
    showWarnings = FALSE,
    recursive = TRUE
  )
  for (data_prefix in names(TX_RONA_PARSER_OPTIONS$save_data)) {
    if (TX_RONA_PARSER_OPTIONS$data_lists[[data_prefix]]$save) {
      dir.create(
        file.path(
        TX_RONA_PARSER_OPTIONS$working_directory,
        data_prefix
        ),
        showWarnings = FALSE,
        recursive = TRUE
      )
    }
  }
}
