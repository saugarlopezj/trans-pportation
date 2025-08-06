# Dataestur downloads ----

## Load functions and dataframe ----

source("_aux/R/downloads/dataestur/dataestur_functions.R")
load("_aux/data/airports_code.RData")
download_aena_data <- function(params_df, endpoint = "AENA_DESTINOS_DL", sleep_time = 6) {
  
  df_airports <- pmap_df(params_df, function(airport, year = NULL, month = NULL) {
    
    # Construye solo los parámetros no nulos
    params <- list("Aeropuerto AENA" = airport)
    
    if (!is.null(year) && !is.null(month)) {
      params[["desde (año)"]] <- year
      params[["desde (mes)"]] <- month
      params[["hasta (año)"]] <- year
      params[["hasta (mes)"]] <- month
    }
    
    # Construye URL
    query <- construct_urls(endpoint, params)
    print(query)
    
    Sys.sleep(sleep_time)
    
    tryCatch({
      df <- get_dataestur_df(query)[[1]]
      df$AEROPUERTO <- airport
      df
    }, error = function(e) {
      message("Error in airport: ", airport)
      return(NULL)
    })
  })
  
  return(df_airports)
}

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


airport_params <- tibble(airports = airports_code$AENA_NAME)

df_airports <- download_aena_data(airports)
















## Process data ----
