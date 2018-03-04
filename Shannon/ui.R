#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
source("server.R")

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Medals Won by Men and Women in Each Country"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("country_name", "Choose a country:",
                  choices = summer$Country)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("Plot")
    )
  )
))
