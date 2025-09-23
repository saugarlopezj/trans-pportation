test_that("class objects", {
  source("_aux/R/downloads/dataestur/dataestur_functions.R")
  expect_type(get_dataestur_endpoints(), "character")
  
})
