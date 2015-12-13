
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)
require(dplyr)
require(rvest)
require(gsubfn)
require(ggplot2)
setwd("..")
CurUSD = read.csv(file = "podatki/USD-urejeno.csv", sep = ",", dec = ".", check.names = FALSE)

NATO <- read.csv(file = "podatki/NATO-urejeno.csv", sep = ",", dec = ".", check.names = FALSE)



NORD1 = NATO[order(NATO$'Military expenditures 2014 US millions',decreasing = TRUE),]


shinyServer(function(input, output) {
   
  #output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    #x    <- faithful[, 2] 
    #bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    #hist(x, breaks = bins, col = 'darkgray', border = 'white')

    
    
    #bar plot, celoten NATO
    #ggplot(NORD1) + aes(x = reorder(Country,`Military expenditures 2014 US millions`), y= `Military expenditures 2014 US millions`) +xlab("Country")+geom_bar(stat="identity") + coord_flip()

  
  p11 <- reactive({
    if (input$bins == 29){
      tr = 35
      
    } else{
      tr = c(1:(29-input$bins))
      input$bins2 -> zz
  }
    p1<-ggplot(NORD1[-tr,]) + aes(x = reorder(Country,`Military expenditures 2014 US millions`), y= `Military expenditures 2014 US millions`) +geom_bar(stat="identity") + xlab("Country")+ coord_flip()
    #p1 <-barplot(NORD1$`Military expenditures 2014 US millions`[-tr], horiz=TRUE,names.arg = NORD1$Country[-tr])
    })
  
  output$distPlot <- renderPlot({
    print(p11())
  })
  
})
