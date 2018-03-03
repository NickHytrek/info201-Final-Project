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

world = map_data("world")

ggplot(twenty12) +
  geom_map(aes(map_id = "Total Medals"), map = world) +
  expand_limits(x = world$long, y = world$lat)


ggplot(world, aes(long, lat)) +
  geom_polygon(aes(group = group))
  

plot_ly(twenty12, x = twenty12$Medals, y = twenty12$GDP.per.Capita , mode = "markers")

