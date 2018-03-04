library(shiny)
library(rsconnect)
library(plotly)
source("server.R")

shinyUI(fluidPage(
  sidebarLayout(
    
    sidebarPanel( 
      sliderInput(inputId = "year",
                  label = "Which year are you intersted in?",
                  min = 1896, max = 2012, value = 1896, step = 4, 
                  ticks = TRUE,
                  animate = animationOptions(interval = 4000)
      )

    ),
    
    mainPanel(
      plotlyOutput("worldmap")
    )
    
  )
  
))