library(jsonlite)
library(httr)
library(RCurl)

source("keys.R")
OlympicsData <- function(location){
  #query.params <- list(competitor = 5719, api_key = mdvfq3f2rrukpzjtcxse39ba)
  response <- GET(key = api.key)
  body <- content(response, "text")
  results <- fromJSON(body)
  players <- flatten(results$players)
  return(players)
  
}

 df <- OlympicsData(duh)

 
