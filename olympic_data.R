library(jsonlite)
library(httr)
library(RCurl)

OlympicsData <- function(location){
  #query.params <- list(competitor = 5719, api_key = mdvfq3f2rrukpzjtcxse39ba)
  response <- GET("http://api.sportradar.us/curling-t1/en/competitors/sr:competitor:5707/profile.json?api_key=mdvfq3f2rrukpzjtcxse39ba")
  body <- content(response, "text")
  results <- fromJSON(body)
  players <- flatten(results$players)
  return(players)
  
}

 df <- OlympicsData(duh)

 