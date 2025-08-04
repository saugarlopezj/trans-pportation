# Dataestur downloads ----

## Load functions ----

source("_aux/R/downloads/dataestur/dataestur_functions.R")

## Get data frame
# Get endpoints
endpoints <- get_dataestur_endpoints()
endpoints_filter <- str_subset(endpoints, "AENA_DESTINOS")

airports <- c(
  "A Coruña", "Albacete", "Algeciras", "Alicante-Elche", "Almeria", "AS Madrid-Barajas", "Asturias",
  "Badajoz", "Bilbao", "Burgos", "Ceuta", "CM Lanzarote", "Cordoba", "El Hierro", "FGL Granada-Jaen",
  "Fuerteventura", "Girona-Costa Brava", "Gran Canaria", "Huesca-Pirineos", "Ibiza", "Jerez de la Frontera",
  "JT Barcelona-El Prat", "La Gomera", "La Palma", "Leon", "Logroño", "Madrid-Cuatro Vientos",
  "Madrid-Torrejón", "Malaga-Costa del Sol", "Melilla", "Menorca", "P. Mallorca", "Pamplona",
  "Región de Murcia IA", "Reus", "Sabadell", "Salamanca", "San Sebastian", "Santiago RC",
  "SB Santander", "Sevilla", "Son Bonet", "Tenerife Norte CL", "Tenerife Sur", "Valencia",
  "Valladolid", "Vigo", "Vitoria", "Zaragoza"
)



# Construct URLs

df <-map_df(airports, ~{
  params <- list(
    "Aeropuerto Aena" = .x
  )
  
  query <- construct_urls(endpoints_filter, params)
  
  # Wait to avoid 429 error
  Sys.sleep(5)
  
  # Get error
  tryCatch({
    df <- get_dataestur_df(query)[[1]]
    df$AEROPUERTO <- .x
    df
  }, error = function(e) {
    message("Error con aeropuerto: ", .x)
    return(NULL)
  })
  
  # Get df
  df <- get_dataestur_df(query)[[1]]
  df$AEROPUERTO <- .x
  
}) %>% 
  bind_rows() 




## Process data ----
