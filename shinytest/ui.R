
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyUI(fluidPage(
  
  # Application title
  headerPanel("NATO Military expenditures 2014 US millions"),
  
  # Sidebar with a slider input for number of bins
  fluidRow(
  sidebarPanel(
    sliderInput("bins",
                "Number of countries:",
                min = 1,
                max = 29,
                value = 6)
  ),

  
  #sidebarPanel("gagg"),

  
  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("distPlot")
  )
  
  ),
  hr(),
  
  sidebarPanel(
    sliderInput("bins2",
                "Number of countries:",
                min = 1,
                max = 29,
                value = 6)
  ),
  mainPanel(
    plotOutput("distPlot2")
  )
))
