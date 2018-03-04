

library(shiny)
library(dplyr)
library(ggplot2)

summer <- read.csv("../data/summer.csv", stringsAsFactors = FALSE)

sort_summer <- summer %>% 
  group_by(Gender, Year, Country) %>% 
  count(Gender)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  output$Plot <- renderPlot({
    #test <- input$country_namedfdf
    summer_country <- summer %>% group_by(Gender, Year, Country) %>% filter(Country == input$country_name) %>% count()
    colnames(summer_country)[colnames(summer_country) == 'n'] <- 'Medals'
    ggplot(summer_country, aes(x = Year, y = Medals)) + 
      geom_line(aes(colour = Gender)) + 
      ggtitle("Medals Won by Men and Women in Each Country", subtitle="This is a comparison of the amount of medals won by men and women in the country of the user's choosing.")
  })
  
})
