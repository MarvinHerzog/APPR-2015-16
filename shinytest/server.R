
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

CurUSD = read.csv(file = "C:/Users/Spitfire/Documents/Vojaski-izdatki/APPR-2015-16/podatki/SIPRI Milex data 1988-2014 Nov15 - Current USD.csv", sep = ";", dec = ".")



podatki <- data.frame()
NATOurl <- "https://en.wikipedia.org/wiki/Member_states_of_NATO"
stran <- html_session(NATOurl) %>% read_html(encoding = "UTF-8")
tabela <- stran %>% html_nodes(xpath ="//table[3]") %>% html_table() 


#uredimo NATO

NATO <- data.frame(tabela)
bt <- sub("^Â\\s","",NATO[,1])
NATO[,1] <- bt
NATO = NATO[-30,]
names(NATO) <- gsub("(\\.)+"," ", names(NATO)) %>% gsub("\\s$","",.) %>% gsub("Â","%",.)
NATO[13,7] <- 0
for(i in 2:7){
  NATO[,i] = gsub(",","",NATO[,i])
  NATO[,i] <- as.numeric(NATO[,i])
}


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
