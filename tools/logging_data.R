# Code pulled from here to help me make a decision
# https://cran.r-project.org/web/packages/dlstats/vignettes/dlstats.html

library("ggplot2")
library("dlstats")

logging_packages <- c(
  "shinyEventLogger",
  "loggit",
  "log4r",
  "logging",
  "futile.logger",
  "logger"
)

x <- cran_stats(logging_packages)

if (!is.null(x)) {
  head(x)
  ggplot(x, aes(end, downloads, group=package, color=package)) +
    geom_line() + geom_point(aes(shape=package))
}
