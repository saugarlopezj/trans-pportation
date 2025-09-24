test_that("object classes", {
  expect_type(get_dataestur_endpoints(), "character")
  
  # Test construct_urls function
  endpoints <-  get_dataestur_endpoints()
  params <- list(
  "País destino" = "Todos",
  "CCAA de residencia" = "Todos",
  "CCAA de destino" = "Todos"
  )
  urls <- construct_urls(endpoints, params)
  expect_type(urls, "character")

})
