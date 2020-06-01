#' @export
bootstrap <- function() {
  dir.create(
    TRP_CONFIG("working_directory"),
    showWarnings = FALSE,
    recursive = TRUE
  )
  for (data_prefix in names(TRP_CONFIG("data_lists"))) {
    if (TRP_CONFIG("data_lists")[[data_prefix]]$save) {
      dir.create(
        file.path(
        TRP_CONFIG("working_directory"),
        data_prefix
        ),
        showWarnings = FALSE,
        recursive = TRUE
      )
    }
  }
}

#' @export
nuke_content <- function(are_you_sure = FALSE) {
  if (are_you_sure) {
    unlink(TRP_CONFIG("working_directory"), recursive = TRUE)
  }
}
