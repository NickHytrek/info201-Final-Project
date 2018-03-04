library(shiny)
library(rsconnect)
library(plotly)
library(dplyr)

summer_data <- read.csv("../data/summer.csv")
dictionary_data <- read.csv("../data/dictionary.csv")

sorted_summer <- summer_data %>%
  group_by(Year, Country) %>%
  summarise("Medals" = n())

colnames(sorted_summer)[colnames(sorted_summer) == "Country"] <- "Code"
sorted_summer <- left_join(sorted_summer, dictionary_data, by = "Code")

shinyServer(function(input, output) {

  output$worldmap <- renderPlotly({  
  
    df <- filter(sorted_summer, Year == input$year)
    
    for (i in 1:nrow(df)) {
      if (is.na(df[i,"Medals"])) {
        df[i, "Medals"] <- 0
      }
    }
    View(df)
    plot_geo(df) %>%
      add_trace(
        z = df$Medals, color = df$Medals, colors = "Blues",
        text = df$Country, locations = df$Code, marker = list(line = list(color = toRGB("black"), width = 0.5))
      ) %>%
      colorbar(title = "Number of Medals") %>%
      layout(
        title = "Total Olympic Medals Won for Each Country",
        geo = list(showframe = FALSE,
                   showcoastlines = FALSE,
                   showcountries = TRUE,
                   projection = list(type = "Mercator")
              )
      )
  })
})

