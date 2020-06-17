# Copyright 2020 CJ Harries
# Licensed under http://www.apache.org/licenses/LICENSE-2.0

futile.logger::flog.threshold(futile.logger::TRACE)
futile.logger::flog.logger(
  "data",
  futile.logger::TRACE,
  futile.logger::appender.console(),
  futile.logger::layout.tracearg
)

# data(sysdata)

#' Contains data necessary to properly scrape the root page
"ROOT_RESOURCE_DATA"

#' Contains data necessary to properly scrape child spreadsheets
"RAW_RESOURCE_DATA"

#' Contains data necessary to properly parse child spreadsheets
"PARSED_RESOURCE_DATA"

RONA_WORLD <- new.env(hash = FALSE)

# RONA_WORLD[["ROOT_RESOURCE_DATA"]] <- ROOT_RESOURCE_DATA
# RONA_WORLD[["RAW_RESOURCE_DATA"]] <- RAW_RESOURCE_DATA
# RONA_WORLD[["PARSED_RESOURCE_DATA"]] <- PARSED_RESOURCE_DATA
