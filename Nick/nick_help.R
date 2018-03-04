library(dplyr)
library(ggplot2)
library(plotly)

summer_data <- read.csv("data/summer.csv")
dictionary_data <- read.csv("data/dictionary.csv")

sorted_summer <- summer_data %>%
  group_by(Year, Country) %>%
  summarise("Medals" = n())


colnames(sorted_summer)[colnames(sorted_summer) == "Country"] <- "Code"
combined_summer <- left_join(sorted_summer, dictionary_data, by = "Code")

twenty12 <- filter(combined_summer, Year == 2012)
twenty12 <- left_join(dictionary_data, twenty12, by = "Code")

for (i in 1:nrow(twenty12)) {
  if (is.na(twenty12[i,"Medals"])) {
    twenty12[i, "Medals"] <- 0
  }
}
  
#border
l <- list(color = toRGB("black"), width = 0.5)

#map projection/options
g <- list (
  showframe = FALSE,
  showcoastlines = FALSE,
  showcountries = TRUE,
  projection = list(type = "Mercator")
)

#graph
plot_geo(twenty12) %>%
  add_trace(
    z = twenty12$Medals, color = twenty12$Medals, colors = "Blues",
    text = twenty12$Country, locations = twenty12$Code, marker = list(line = l)
  ) %>%
  colorbar(title = "Medals by country") %>%
  layout(
    title = "Medals by Country",
    geo = g
  )
