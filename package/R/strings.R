# Copyright 2020 CJ Harries
# Licensed under http://www.apache.org/licenses/LICENSE-2.0

ERROR_IS_ABSTRACT_CLASS <- "is abstract and cannot be instantiated"
ERROR_IS_ABSTRACT_METHOD <- "is abstract and has no implementation"

XPATH_SPREADSHEET_URLS <- "//h2[./u[text() = '${h2_lead}']]/following-sibling::h6/a[starts-with(@href, '${href_lead}') and (substring(@href, string-length(./@href) - 3) = 'xlsx' or substring(@href, string-length(./@href) - 2) = 'xls')]"
