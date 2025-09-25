# Dataestur downloads ----

## Load functions and dataframe ----

source("_aux/R/downloads/dataestur/dataestur_functions.R") # download and tidy functions
load("_aux/data/airports_code.rda") # airports codes with aena names
load("_aux/data/variable_ids.rda") # variables ids with original names
load("_aux/data/dataestur_endpoints.rda") # endpoints



## Get data frame ----

### Get endpoints ----
endpoints_filter <- str_subset(endpoints, "AENA_DESTINOS")

### Save parameters for the query ----

# Airports
airports <- airports_code$AEROPUERTO_AENA

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


airport_params <- tibble(airport = airports)

df1 <- download_aena_data(airport_params, sleep_time = 10,
                          endpoint = endpoints_filter)

##  Process data ----
df_airports <- tidy_aenadata(df1, airports_code, variable_ids) 


save(df_airports, file = "_aux/data/df_airports.rda")













