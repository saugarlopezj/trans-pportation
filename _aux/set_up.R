# Load necesary packages ----


## Package load function ----
load_package <- function(pkg) {
  
  # Assure to hace installed packages
  if (!requireNamespace(pkg, quietly = TRUE)) {
    message(sprintf("Installing package: %s", pkg))
    install.packages(pkg)
  }
  
  # Load package if is not in the global environment
  if (!pkg %in% loadedNamespaces()) {
    suppressPackageStartupMessages(library(pkg, character.only = TRUE))
  }
}

## Set packages to load ----
packages <- c("rvest", "tidyverse")

# Load packages
invisible(lapply(packages, load_package))
