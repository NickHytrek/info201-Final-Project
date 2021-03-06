library("shiny")
library("ggplot2")
library("dplyr")
library("rsconnect")
library("plotly")

summer <- read.csv("data/summer.csv", stringsAsFactors = FALSE)
all_sports <- sort(unique(summer$Discipline))
#this will be used to parse the names of the country for selection
summer_locate <- summer %>% group_by(Country) %>% count()

shinyUI(
  navbarPage("Tabs",
             
#--------------Kei-----------------------------------------------------  
    tabPanel("Total Medals", titlePanel("Comparing Total Medals"),
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
    tabPanel("World Map", titlePanel(" "),
     verticalLayout(
       
       #Title of graph
       titlePanel("Total Metals Won by Each Country for Every Olympic Year"),
       
       #Text to inform users about missing data for some years
       helpText(h5("Notice: "), 
                p("There is no data for the following years due to global conflicts; 1916, 1940, 1944")),
       
       #Output map
       plotlyOutput("worldmap"),
       
       #Create slider that will allow users to change what year of data they would like to have displayed
       wellPanel(
         sliderInput(inputId = "year",
                     label = "Which year are you intersted in?",
                     min = 1896, max = 2012, value = 1896, step = 4, 
                     ticks = TRUE,
                     animate = animationOptions(interval = 4000)
         )
       ),
       wellPanel(
         helpText(h5("Analysis"),
                  p("This graph displays the total number of medals that each country earned for each Summer Olympics that 
            has taken place since 1896, except for 1916, 1940, and 1944. What you can see from the graph is as  
            time progresses, you can see more and more countries beginning to participate in the Olympics. You can 
            also see that very often global politics influence the olympics, such as the 1980 olympics in the USSR
            that the U.S. and many other countries boycotted, and then the following olympics of 1984 in the U.S. 
            which the USSR boycotted as well. In addition it seems that quite often the country hosting the olympics 
            tends to see an increase in the total medals that it wins, for example Greece in 1896 and Germany in 1936.
           "))
       )
     )
    ),

#----------------------Shannon-------------------------------------
    tabPanel("Medals by Gender", titlePanel("Trend of Medals Won by Men and Women in Each Country"),
      sidebarLayout(
        sidebarPanel(
          
          #choose your country and find the abbreviation meaning
          selectInput("country_name", "Choose a country:", choices = summer_locate$Country, selected = "USA"),
          textInput("texty", label = h5("Convert abbreviation to actual name"), value = "USA"),
          textOutput('Text')
        ),
        
        
      #Show a plot of the generated distribution
        mainPanel(
          plotlyOutput("Plot"),
          
          helpText(h5("Analysis"),
                   p("This graph depicts all the women and men medal winners for the history of the Summer Olympics 
                   (1896-2012). Grouping by country, you can see the rise and fall of each country's winnings. Depending on
                   sport and country, you'll notice there are different induction years into sport participation in the Olympics.
                   What varies greatly for almost every country is the induction date for females vs. males. Commonly, men are
                   inducted into participations first with women to follow in later years, if at all. Not one country has only 
                   females representing their country. Notice: For all countries, there will be no data for 1916, 1940, and 1944 
                   due to the Olympic games being cancelled because of the World Wars."))
        )
      )
    ),
    
    #creating a summary intro for our intent in a separate tab
    tabPanel("About Us", titlePanel("The History of the Olympics"),
      mainPanel(
        helpText("The Olympic Games are an international sports festival that began in ancient Greece.
                  The original Greek games were staged every fourth year for several hundred years, until 
                  they were abolished in the early Christian era. The revival of the Olympic Games took place 
                  in 1896, and since then they have been staged every fourth year, except during World War I and
                  World War II (1916, 1940, 1944). The purpose of our analysis is to find important trends in the
                  medals won by the Olympians from every country, man and woman from 1896 to 2014. Depending on the
                  country and their specific rules, women were not able to compete until later years, explaining the
                  disparity in their display on the third visualization."),
        helpText("Keishiro Miwa is an International Student from Japan. He's in his second quarter as a Sophmore at Waseda University."),
        helpText("Shannon Gatta is an Informatics major at the University of Washington. She is a Junior. She is from Dallas, TX."),
        helpText("Nick Hytrek is a Classics major and an Informatics minor at the University of Washington. He is a Junior. He is from Auburn, WA. ")
      )
    )
  )
)
