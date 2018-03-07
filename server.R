library("shiny")
library("ggplot2")
library("dplyr")
library("rsconnect")
library("plotly")



shinyServer(function(input, output) {
#----------------From here (K)---------------------------------
  
  ## read and organize data I need 
  summer <- read.csv("data/summer.csv", stringsAsFactors = FALSE)
  all_country <- sort(unique(summer$Country))
  code <- read.csv("data/dictionary.csv", stringsAsFactors = FALSE)
  code[202, ]=c("The IOC country code for mixed teams at the Olympics", "ZZX")
  
  output$plot <- renderPlot({
    ## make a df which depends on user experience
    plot.data <- summer %>% 
      filter(summer$Discipline == input$sports, summer$Year == input$period) %>%
      mutate(AAA = paste(Country, Medal)) %>% 
      group_by(Country, Medal, AAA) %>% 
      count()
    
    ## show data only when there is data to show
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
  
  ## search what abbriviation means
  output$userText <- renderText({
    code.data <- code %>% 
      filter(Code == toupper(input$text))
    
    return(paste0(input$text, " = ", code.data$Country))
  })
#----------------------to here (K)-------------------------
#----------------------from here (Nick)---------------------
  
  summer_data <- read.csv("Nick/NickData/summer2.csv")
  dictionary_data <- read.csv("Nick/NickData/dictionary2.csv")
  
  #Sort summer data by year and country and sum every medal won by that country for that year
  sorted_summer <- summer_data %>%
    group_by(Year, Country) %>%
    summarise("Medals" = n())
  
  #Change the name of the column to match the other data frame, the join the two dataframes to make 
  #pulling the data by the year easier
  colnames(sorted_summer)[colnames(sorted_summer) == "Country"] <- "Code"
  sorted_summer <- left_join(sorted_summer, dictionary_data, by = "Code")
  
  #Server output for the world map
  output$worldmap <- renderPlotly({  
    
    #Get the rows of data for the user specified year
    df <- filter(sorted_summer, Year == input$year)
    
    #Clean any rows where a country did not win a medal of NA's to 0's
    for (i in 1:nrow(df)) {
      if (is.na(df[i,"Medals"])) {
        df[i, "Medals"] <- 0
      }
    }
    
    #Plotly ouput a choropleth map. Color is based upon medals won by each country. It is associated to the map by
    #Country code and will display the code and total medals on hover over of the country. Builds a color bar to the right
    #of the map, and removes coastlines and makes sure all countries are visible even if there is no data at all.
    plot_geo(df) %>%
      add_trace(
        z = df$Medals, color = df$Medals, colors = "Blues",
        text = df$Country, locations = df$Code, marker = list(line = list(color = toRGB("black"), width = 0.5))
      ) %>%
      colorbar(title = "Medals", x = 0.75) %>%
      layout(
        
        geo = list(showframe = FALSE,
                   showcoastlines = FALSE,
                   showcountries = TRUE,
                   projection = list(type = "Mercator")
        )
      )
  })
#---------------------to here (Nick)----------------------
#---------------------from here (Shannon)-----------------
  
  #by filtering through the choice in country, we can break down by location how men and women have won medals
  output$Plot <- renderPlotly({
    summer_country <- summer %>% group_by(Gender, Year, Country) %>% filter(Country == input$country_name) %>% count()
    colnames(summer_country)[colnames(summer_country) == 'n'] <- 'Medals'
    p <- ggplot(summer_country, aes(x = Year, y = Medals)) + 
      geom_line(aes(colour = Gender)) + 
      ggtitle("Medals Won by Men and Women in Each Country", subtitle="This is a comparison of the amount of medals won by men and women in the country of the user's choosing.")
    p <- ggplotly(p)
  })
  ## search what abbriviation means
  output$Text <- renderText({
    code.data <- code %>% 
      filter(Code == toupper(input$texty))
    
    return(paste0(input$texty, " = ", code.data$Country))
  })
#---------------------to here (Shannon)-------------------
  
})