# Load necesary packages ----


## Package load function ----
load_package <- function(pkg) {
  
  # Assure to hace installed packages
  if (!requireNamespace(pkg, quietly = TRUE)) {
    message(sprintf("Installing package: %s", pkg))
    install.packages(pkg)
  }
  
  # Load package if is not in the global environment
  tryCatch({
    suppressPackageStartupMessages(library(pkg, character.only = TRUE))
  }, error = function(e) {
    message(sprintf("Error loading package '%s': %s", pkg, e$message))
  })
}

## Set packages to load ----
packages <- c("rvest", "tidyverse", "selenider", "RSelenium", "chromote")


# Load packages
invisible(lapply(packages, load_package))

rm(list = c("load_package", "packages"))
