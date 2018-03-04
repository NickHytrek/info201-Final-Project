library("shiny")
library("ggplot2")
library("dplyr")
library("rsconnect")

summer <- read.csv("../data/summer.csv", stringsAsFactors = FALSE)
all_country <- sort(unique(summer$Country))
code <- read.csv("../data/dictionary.csv", stringsAsFactors = FALSE)
code[202, ]=c("The IOC country code for mixed teams at the Olympics", "ZZX")


shinyServer(function(input, output) {
  output$plot <- renderPlot({
    
    plot.data <- summer %>% 
      filter(summer$Discipline == input$sports, summer$Year == input$period) %>%
      mutate(AAA = paste(Country, Medal)) %>% 
      group_by(Country, Medal, AAA) %>% 
      count()
    
    if (is.na(plot.data)) {
      return("")
    } else {
      ggplot(plot.data) + 
        geom_histogram(mapping=aes(x=Country, y=n, fill = Medal), stat="identity") +
        scale_fill_manual(values = alpha(c("#ac6b25", "#ffd700", "#c0c0c0"), 0.5)) +
        labs(y = "Number of medals") +
        coord_flip()
    }
  })
  
  output$userText <- renderText({
    code.data <- code %>% 
      filter(Code == toupper(input$text))
    return(paste0(input$text, " = ", code.data$Country))
  })
})



