library(dplyr)

dictionary <- read.csv("dictionary.csv", stringsAsFactors = FALSE)
winter <- read.csv("winter.csv", stringsAsFactors = FALSE)

sort_winter <- winter %>% 
  group_by(Country) %>% 
  count(Country) %>% 
  mutate(Code = Country)

combined <- left_join(sort_winter, dictionary, by = "Code")
