# `txronaparser`

## Overview

This package pulls all Texas-related data from [the TX DSHS 'rona data page](https://dshs.texas.gov/coronavirus/additionaldata/). It involving scraping and sidestepping misconfigured server issues, so it's brittle and may break unexpectedly.

## Installation

You'll need [`devtools`](https://cran.r-project.org/package=devtools).

```
devtools::install_github("thecjharries/txronaparser")
```

## Usage

The package is currently very, very simple. To get started, run something like this:

```r
library("txronaparser")

bootstrap()
reload_data_remote()
str(all_data, max.level = 1)
# List of 3
#  $ raw   :List of 6
#  $ parsed:List of 2
#  $ misc  : list()
```

### Configuration

Currently, the config follows the XDG directory spec and throws all your working data in `$HOME/.config/txronaparser`. I'm more interested in getting an MVP out at the moment than providing neat customization, so more later.

### Data Types

There are currently three types of returned data.

* `raw`: this is the spreadsheet direct from TX DSHS without any parsing
* `parsed`: this is data that's been parsed (more on that later)
* `misc`: this is a catch-all used to ensure there's somewhere you can dump things

### Parsers

Each spreadsheet is defined in the configuration file as follows:

```
spreadsheets:
  spreadsheet_basename.xlsx:
    url: https://some-website.com/spreadsheet_basename.xlsx
    etl_parser: ''
```

Once the data's been wrangled, a parser will ship and the entry will look like this:

```
spreadsheets:
  spreadsheet_basename.xlsx:
    url: https://some-website.com/spreadsheet_basename.xlsx
    etl_parser: specific_process
```

All parsers look like this:

```r
# etl_parser_specific_process.R
etl_parser_specific_process <- function(raw_spreadsheet_data) {
  # pretend we create
  #   foo_data
  #   bar_data
  
  list(
    "foo_data" = foo_data,
    "bar_data" = bar_data
  )
}
```

They take in a raw spreadsheet and spit out one or more collections of parsed data. If none is defined, nothing happens.


### Local Data I/O

At the moment, once remote data has been loaded, you can save and reload it via [RDS files](https://stat.ethz.ch/R-manual/R-devel/library/base/html/readRDS.html). These will be stored as defined in the config. This saves you from constantly reloading the remote data and reparsing everything (although it doesn't take long at all at the moment).
