library("shiny")
library("dplyr")
library("rsconnect")

summer <- read.csv("../data/summer.csv", stringsAsFactors = FALSE)
all_sports <- sort(unique(summer$Discipline))

shinyUI(fluidPage(
  
  titlePanel("Comparing total medal"),
  
  sidebarLayout(
    sidebarPanel(
      
      selectInput(inputId = "sports",
                  label = "Which sports are you interested in",
                  choices = all_sports
      ),
      
      sliderInput(inputId = "period", 
                  label = "What period are you interested in", 
                  min = 1896, max = 2012, value = 1896, step = 4, 
                  ticks = TRUE,
                  animate = animationOptions(interval = 4000)
      )
      
    ),
    
    mainPanel(
      plotOutput("plot")
    )
  )
))