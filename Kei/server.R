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
      mutate(AAA = paste(Country, Medal)) %>% 
      group_by(Country, Medal, AAA) %>% 
      count()
    
    
    ggplot(plot.data) + 
      geom_histogram(mapping=aes(x=Country, y=n, fill = Medal), stat="identity", color = "black") +
      scale_fill_manual(values = c("#ac6b25", "#ffd700", "#c0c0c0")) +
      coord_flip()
    
    
  })
  output$userText <- renderText({
    return(paste0('The user typed: ', input$text))
  })
})

plot.data <- summer %>% 
  filter(summer$Discipline == "Swimming", summer$Year == "2012") %>% 
  mutate(AAA = paste(Country, Medal)) %>% 
  group_by(Country, Medal, AAA) %>% 
  count()

