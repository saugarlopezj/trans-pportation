source("_aux/R/_setup/source_packages.R")

# Download data ----

#' Get Endpoints from Dataestur API
#'
#' @param .url 
#'
#' @returns A character vector of API endpoints.
#' @export
#'
#' @examples
#' 
#' endpoints <-  get_dataestur_endpoints()
get_dataestur_endpoints <- function(.url = "https://www.dataestur.es/en/apidata/" ){
  session <- selenider_session(
    "chromote",
    timeout = 10,
    options = chromote_options(headless = TRUE)
  )
  
  open_url(.url)
  spans <- ss("span.opblock-summary-path")
  spans_list <- as.list(spans)
  endpoints <- purrr::map_chr(spans_list, ~ elem_attr(.x, "data-path"))
  
  close_session()
  
  
  return(endpoints)
}


#' Construct URLs for Dataestur API Endpoints
#'
#' @param endpoints 
#' @param params 
#' @param .url 
#'
#' @returns
#' @export
#'
#' @examples
#' endpoints <-  get_dataestur_endpoints()
#' params <- list(
#' "País destino" = "Todos",
#' "CCAA de residencia" = "Todos",
#' "CCAA de destino" = "Todos"
#' )
#' urls <- construct_urls(endpoints, params)
#' 
construct_urls <- function(endpoints, params, .url =  "https://dataestur.azure-api.net/API-SEGITTUR-v1/") {
  query <- paste0(
    URLencode(names(params), reserved = TRUE), "=",
    URLencode(params, reserved = TRUE),
    collapse = "&"
  )
  urls <- paste0(.url, endpoints, "?", query)
  return(urls)
}



# Process data ----


#' Get Data from Dataestur API
#' 
#' @param urls 
#'
#' @returns A list of data frames, each corresponding to an endpoint.
#' @export
#'
#' @examples
#' endpoints <-  get_dataestur_endpoints()
#' params <- list(
#' "País destino" = "Todos",
#' "CCAA de residencia" = "Todos",
#' "CCAA de destino" = "Todos"
#' )
#' urls <- construct_urls(endpoints, params)
#' get_data_dataestur(urls)
#' 
#' 
get_dataestur_df <- function(.url) {
  res <- map(.url, function(url) {
    respond <- GET(url)
    
    if (httr::status_code(respond) != 200) {
      message("Error: ", status_code(respond), " en ", url)
      return(NULL)
    }
    
    # Detectar nombre de archivo en header
    disp <- headers(respond)[["content-disposition"]]
    filename <- str_extract(disp, "(?<=filename=)[^;\\s]+")
    
    # Crear path temporal
    temp_file <- tempfile(fileext = paste0(".", tools::file_ext(filename)))
    writeBin(content(respond, as = "raw"), temp_file)
    
    # Leer según extensión
    ext <- tools::file_ext(filename)
    if (ext == "xlsx") {
      df <- read_excel(temp_file)
    } else if (ext == "csv") {
      df <-read_delim(temp_file,
                      show_col_types = FALSE,
                      delim = ";",
                      locale = locale(encoding = "ISO-8859-1", decimal_mark = ","),
                      escape_double = FALSE,
                      trim_ws = TRUE)
      
    } else {
      message("Extensión no reconocida: ", ext)
      return(NULL)
    }
    
    return(df)
  })
  
  # Nombrar la lista con el endpoint extraído del URL
  endpoint_names <- str_extract(.url, "(?<=API-SEGITTUR-v1/)[^?]+")
  names(res) <- endpoint_names
  
  return(res)
}










