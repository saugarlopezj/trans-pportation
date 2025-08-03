# Load necesary packages ----


## Package load function ----
load_package <- function(pkg) {
  if (!pkg %in% loadedNamespaces()) {
    suppressPackageStartupMessages(library(pkg, character.only = TRUE))
  }
}

## Set packages to load ----
packages <- c("dplyr", "ggplot2", "readr")

# Load packages
invisible(lapply(packages, load_package))
