# Copyright 2020 CJ Harries
# Licensed under http://www.apache.org/licenses/LICENSE-2.0

library("usethis")

ROOT_RESOURCE_DATA <- list(
  "url" = "https://dshs.texas.gov/coronavirus/additionaldata/",
  "h2_lead" = "Texas Data",
  "href_lead" = "/coronavirus"
)

RAW_RESOURCE_DATA <- list(
  "CasesoverTimebyCounty" = "https://dshs.texas.gov/coronavirus/TexasCOVID19DailyCountyCaseCountData.xlsx",
  "FatalitiesoverTimebyCounty" = "https://dshs.texas.gov/coronavirus/TexasCOVID19DailyCountyFatalityCountData.xlsx",
  "EstimatedActiveCasesoverTimebyCounty" = "https://dshs.texas.gov/coronavirus/TexasCOVID-19ActiveCaseDatabyCounty.xlsx",
  "CumulativeTestsoverTimebyCounty" = "https://dshs.texas.gov/coronavirus/TexasCOVID-19CumulativeTestsOverTimebyCounty.xlsx",
  "COVID19HospitalizationsoverTimebyTraumaServiceAreaTSA" = "https://dshs.texas.gov/coronavirus/TexasCOVID-19HospitalizationsOverTimebyTSA.xlsx",
  "AccessibleDashboardData" = "https://dshs.texas.gov/coronavirus/TexasCOVID19CaseCountData.xlsx"
)

PARSED_RESOURCE_DATA <- list(
  "CasesoverTimebyCounty" = list(
    "column_lead" = "cases",
    "table_lead" = "County Name",
    "table_tail" = "Total",
    "sql_table" = "total_case_data"
  ),
  "FatalitiesoverTimebyCounty" = list(
    "column_lead" = "fatalities",
    "table_lead" = "County Name",
    "table_tail" = "Total",
    "sql_table" = "total_fatality_data"
  ),
  "CumulativeTestsoverTimebyCounty" = list(
    "column_lead" = "tests",
    "table_lead" = "County",
    "table_tail" = "TOTAL",
    "sql_table" = "total_test_data"
  )
)

usethis::use_data(
  ROOT_RESOURCE_DATA,
  RAW_RESOURCE_DATA,
  PARSED_RESOURCE_DATA,
  internal = TRUE,
  overwrite = TRUE
)

rm(list = c("ROOT_RESOURCE_DATA", "RAW_RESOURCE_DATA", "PARSED_RESOURCE_DATA"))
