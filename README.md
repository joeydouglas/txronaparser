# `txronaparser`

Total refactor; this doesn't work right now

## Overview

This package pulls all Texas-related data from [the TX DSHS 'rona data page](https://dshs.texas.gov/coronavirus/additionaldata/). It involving scraping and sidestepping misconfigured server issues, so it's brittle and may break unexpectedly.

## Installation

You'll need [`devtools`](https://cran.r-project.org/package=devtools).

```
devtools::install_github("thecjharries/txronaparser")
```

## Database Setup

You'll need to provide database connection details in something like the `~/.my.cnf` file using the `txronaparser` group.

```ini
[txronaparser]
database = txronaparser
user = some_user
password = some_password
...
```
