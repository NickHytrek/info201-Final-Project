library("shiny")
library("ggplot2")
library("dplyr")
library("rsconnect")
library("plotly")



shinyServer(function(input, output) {
#----------------From here (K)---------------------------------
  
  summer <- read.csv("data/summer.csv", stringsAsFactors = FALSE)
  all_country <- sort(unique(summer$Country))
  code <- read.csv("data/dictionary.csv", stringsAsFactors = FALSE)
  code[202, ]=c("The IOC country code for mixed teams at the Olympics", "ZZX")
  
  output$plot <- renderPlot({
    plot.data <- summer %>% 
      filter(summer$Discipline == input$sports, summer$Year == input$period) %>%
      mutate(AAA = paste(Country, Medal)) %>% 
      group_by(Country, Medal, AAA) %>% 
      count()
    
    if (is.na(plot.data)) {
      return("")
    } else {
      ggplot(plot.data, aes(x=Country, y=n, fill = Medal)) + 
        geom_histogram(stat="identity") +
        scale_fill_manual(values = alpha(c("#ac6b25", "#ffd700", "#c0c0c0"), 0.7)) +
        geom_text(aes(label = n), position = position_stack(vjust = 0.5), color = "white") +
        labs(y = "Number of medals") +
        coord_flip()
    }
  })
  
  output$userText <- renderText({
    code.data <- code %>% 
      filter(Code == toupper(input$text))
    
    return(paste0(input$text, " = ", code.data$Country))
  })
#----------------------to here (K)-------------------------
#----------------------from here (Nick)---------------------
  
  summer_data <- read.csv("Nick/NickData/summer2.csv")
  dictionary_data <- read.csv("Nick/NickData/dictionary2.csv")
  
  sorted_summer <- summer_data %>%
    group_by(Year, Country) %>%
    summarise("Medals" = n())
  
  colnames(sorted_summer)[colnames(sorted_summer) == "Country"] <- "Code"
  sorted_summer <- left_join(sorted_summer, dictionary_data, by = "Code")
  
  output$worldmap <- renderPlotly({  
    
    df <- filter(sorted_summer, Year == input$year)
    
    for (i in 1:nrow(df)) {
      if (is.na(df[i,"Medals"])) {
        df[i, "Medals"] <- 0
      }
    }
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
#---------------------to here (Nick)----------------------
#---------------------from here (Shannon)-----------------
  
  sort_summer <- summer %>% 
    group_by(Gender, Year, Country) %>% 
    count(Gender)
  
  output$Plot <- renderPlot({
    #test <- input$country_namedfdf
    summer_country <- summer %>% group_by(Gender, Year, Country) %>% filter(Country == input$country_name) %>% count()
    colnames(summer_country)[colnames(summer_country) == 'n'] <- 'Medals'
    ggplot(summer_country, aes(x = Year, y = Medals)) + 
      geom_line(aes(colour = Gender)) + 
      ggtitle("Medals Won by Men and Women in Each Country", subtitle="This is a comparison of the amount of medals won by men and women in the country of the user's choosing.")
  })
#---------------------to here (Shannon)-------------------
  
})