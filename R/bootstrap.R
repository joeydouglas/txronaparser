#' @export
bootstrap <- function() {
  dir.create(
    TRP_CONFIG$working_directory,
    showWarnings = FALSE,
    recursive = TRUE
  )
  for (data_prefix in names(TRP_CONFIG$save_data)) {
    if (TRP_CONFIG$data_lists[[data_prefix]]$save) {
      dir.create(
        file.path(
        TRP_CONFIG$working_directory,
        data_prefix
        ),
        showWarnings = FALSE,
        recursive = TRUE
      )
    }
  }
}
