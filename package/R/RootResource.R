# Copyright 2020 CJ Harries
# Licensed under http://www.apache.org/licenses/LICENSE-2.0

#' RootResource
RootResource <- R6::R6Class(
  classname = "RootResource",
  portable = TRUE,
  parent_env = RONA_WORLD,
  inherit = AbstractResource,
  public = list(
    #' @description
    #' initialize
    #' @param can_spawn can_spawn
    #' @param init_data init_data
    initialize = function(can_spawn = FALSE, init_data = ROOT_RESOURCE_DATA) {
      flog.trace("Called initialize on RootResource with %s", can_spawn)
      flog.trace(init_data)
      private$.can_spawn <- can_spawn
      private$.url <- init_data$url
      private$.h2_lead <- init_data$h2_lead
      private$.href_lead <- init_data$href_lead

      invisible(self)
    },
    #' @description
    #' extract
    extract = function() {
      flog.trace("Extracting root data")
      private$.value <- html_curl_loader(private$.url)
      flog.trace("loaded something")

      invisible(self)
    },
    #' @description
    #' transform
    #' @importFrom magrittr %>%
    transform = function() {
      flog.trace("Transforming root data")
      # Need to dupe for the interpolation
      h2_lead <- private$.h2_lead
      href_lead <- private$.href_lead

      private$.value <- private$.value %>%
        xml2::xml_find_all(stringr::str_interp(XPATH_SPREADSHEET_URLS)) %>%
        sapply(
          .,
          function(node) {
            parsed <- list()
            parsed[[gsub("[^[:alnum:]]", "", xml2::xml_text(node, trim = TRUE))]] <- paste0(
              gsub(paste0(href_lead, ".*$"), "", private$.url),
              xml2::xml_attr(node, "href")
            )

            parsed
          }
        )
      flog.debug("Loaded data")
      flog.trace(self$value, name = "data")

      self$value
    },
    #' @description
    #' load
    load = function() {

    }
  ),
  private = list(
    .url = NA,
    .h2_lead = NA,
    .href_lead = NA,
    .spawn = function() {
      flog.info("Root is spawning RawResources")
      for (spreadsheet_name in names(self$value)) {
        resource_name <- paste0("RawResource", spreadsheet_name)
        raw_resource_class <- get(resource_name, RONA_WORLD)
        raw_resource <- raw_resource_class$new(
          spreadsheet_name,
          self$value[[spreadsheet_name]],
          TRUE
        )
        RONA_WORLD[[tolower(resource_name)]] <- raw_resource
        raw_resource$etl()$spawn()
      }
    }
  )
)
