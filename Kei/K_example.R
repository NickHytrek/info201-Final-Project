library(dplyr)

dictionary <- read.csv("../data/dictionary.csv", stringsAsFactors = FALSE)
winter <- read.csv("../data/winter.csv", stringsAsFactors = FALSE)
summer <- read.csv("../data/summer.csv", stringsAsFactors = FALSE)

sort_summer <- summer %>% 
  group_by(Country) %>% 
  count(Country)

combined <- left_join(sort_winter, dictionary, by = "Code")


