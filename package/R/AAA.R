# Copyright 2020 CJ Harries
# Licensed under http://www.apache.org/licenses/LICENSE-2.0


#' @importFrom futile.logger flog.trace flog.debug flog.info flog.warn flog.error flog.fatal
futile.logger::flog.threshold(futile.logger::TRACE)
futile.logger::flog.logger(
  "data",
  futile.logger::TRACE,
  futile.logger::appender.console(),
  futile.logger::layout.tracearg
)

#' The finished environment
#' @export
RONA_WORLD <- new.env(hash = FALSE)

#' Updates all data
#' @export
update_data <- function() {
  orchestrator <- ResourceOrchestrator$new()
  orchestrator$e2e_automated()
}
