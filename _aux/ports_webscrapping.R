# Ports data download ----

## Load packages ----

source("_aux/set_up.R")

## Webscrapping process ----

# Url
url_base <- "https://www.puertos.es/"
const<- "datos/estadisticas/mensuales"
url <- paste0(url_base, const)

# Get website
webpage <- read_html(url)

dates <- webpage %>% 
  html_nodes("option") %>% 
  html_text() %>% 
  as.numeric() %>% 
  na.omit()


session <- selenider_session(
  "chromote",
  timeout = 10,
  options = chromote_options(headless = FALSE)
)


open_url(url)




