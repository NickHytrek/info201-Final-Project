library("shiny")
library("ggplot2")
library("dplyr")
library("rsconnect")
library("plotly")

summer <- read.csv("data/summer.csv", stringsAsFactors = FALSE)
all_sports <- sort(unique(summer$Discipline))

shinyUI(
  navbarPage("Tab",
             
#--------------Kei-----------------------------------------------------  
    tabPanel("Kei", titlePanel("Comparing Total Medals"),
      sidebarLayout(
        sidebarPanel(
          selectInput(inputId = "sports", 
                      label = "Which sports are you interested in", 
                      choices = all_sports
          ),
          sliderInput(inputId = "period", 
                      label = "What period are you interested in", 
                      min = 1896, max = 2012, value = 2012, step = 4, 
                      ticks = TRUE, 
                      animate = animationOptions(interval = 4000)
          ),
          helpText(h5("Notice: "), 
                   p("There is no such data recorded if the error shows", strong(em("argument is of length zero")))
          ),
          textInput("text", label = h5("Convert abbreviation to actual name"), value = "USA"),
          textOutput('userText')
        ),
        mainPanel(
         plotOutput("plot")
        )
      )
    ),

#---------------------------Nick----------------------------------------
    tabPanel("Nick", titlePanel("Nick"),
     verticalLayout(
       titlePanel("Total Metals Won by Each Country for Every Olympic Year"),
       plotlyOutput("worldmap"),
       wellPanel(
         sliderInput(inputId = "year",
                     label = "Which year are you intersted in?",
                     min = 1896, max = 2012, value = 1896, step = 4, 
                     ticks = TRUE,
                     animate = animationOptions(interval = 4000)
         )
       )
     )
    ),

#----------------------Shannon-------------------------------------
    tabPanel("Medals by Gender", titlePanel("Medals Won by Men and Women in Each Country"),
      sidebarLayout(
        sidebarPanel(
          selectInput("country_name", "Choose a country:", choices = summer_locate$Country, selected = "USA")
        ),
        
      #Show a plot of the generated distribution
        mainPanel(
          plotOutput("Plot")
        )
      )
    )



))
