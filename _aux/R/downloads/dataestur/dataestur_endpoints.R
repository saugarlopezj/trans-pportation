# Get endpoints ----

## Load functions  ----

source("_aux/R/downloads/dataestur/dataestur_functions.R")

## Get endpoints ----
endpoints <- get_dataestur_endpoints()
print(endpoints)

## Save endpoints ----
save(endpoints, file = "_aux/data/dataestur_endpoints.rda")
