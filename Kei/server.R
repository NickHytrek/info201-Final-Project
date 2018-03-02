library("shiny")
library("ggplot2")
library("dplyr")
library("rsconnect")

summer <- read.csv("../data/summer.csv", stringsAsFactors = FALSE)
all_country <- sort(unique(summer$Country))


shinyServer(function(input, output) {
  output$plot <- renderPlot({
    
    plot.data <- summer %>% 
      filter(summer$Discipline == input$sports, summer$Year == input$period) %>%
      group_by(Country) %>% 
      count(Country)
    
    
    ggplot(plot.data) + 
      geom_bar(mapping=aes(x=Country, y=n), stat="identity") + 
      coord_flip()
    
    
  })
})

plot.data <- summer %>% 
  filter(summer$Discipline == "Basketball", summer$Year == "2012") %>% 
  group_by(Country) %>% 
  count(Country)

