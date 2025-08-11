# Dataestur downloads ----

## Load functions and dataframe ----

source("_aux/R/downloads/dataestur/dataestur_functions.R")
load("_aux/data/airports_code.RData")


## Get data frame ----

### Get endpoints ----
endpoints <- get_dataestur_endpoints()
endpoints_filter <- str_subset(endpoints, "AENA_DESTINOS")

### Save parameters for the query ----

# Airports
airports <- airports_code$AENA_NAME

# Years and months
current_date <- Sys.Date()
current_year <- year(current_date)
current_month <- month(current_date)


date_seq <- seq.Date(from = as.Date("2004-01-01"),  # Get sequence
                     to = as.Date(sprintf("%d-%02d-01", current_year, current_month - 1)), 
                     by = "month")

# Get years and months
year_month_df <- tibble(
  year = as.character(year(date_seq)),
  month = str_pad(month(date_seq), width = 2, pad = "0")
)


# Combinations 
params_df <- expand_grid(
  airport = airports,
  year_month_df
)


airport_params <- tibble(airport = airports_code$AENA_NAME)

df_airports <- download_aena_data(airport_params, sleep_time = 8)




save(df_airports.rda, file = "_aux/data/df_airports.rda")











## Process data ----
