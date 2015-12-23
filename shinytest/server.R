
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
require(reshape2)
setwd("..")
source("lib/uvozi.zemljevid.r", encoding = "UTF-8")

CurUSD = read.csv(file = "podatki/USD-urejeno.csv", sep = ",", dec = ".", check.names = FALSE)

NATO <- read.csv(file = "podatki/NATO-urejeno.csv", sep = ",", dec = ".", check.names = FALSE)
read.csv(file = "podatki/PerCap-urejeno.csv", sep = ",", dec = ".", check.names = FALSE) -> PerCap
read.csv(file = "podatki/GDP-urejeno.csv", sep = ",", dec = ".", check.names = FALSE) -> GDP
GDPzem <- GDP
svet <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/ne_110m_admin_0_countries.zip",pot.zemljevida= "ne_110m_admin_0_countries",mapa = "zemljevidi")


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
    p1<-ggplot(NORD1[-tr,]) +
      aes(x = reorder(Country,`Military expenditures 2014 US millions`), y= `Military expenditures 2014 US millions`) +
      geom_bar(stat="identity") + xlab("Country")+ ylab("US millions")+ coord_flip()
    #p1 <-barplot(NORD1$`Military expenditures 2014 US millions`[-tr], horiz=TRUE,names.arg = NORD1$Country[-tr])
    })
  
  output$distPlot <- renderPlot({
    print(p11())
  })
  
  row.names(PerCap) <- PerCap[,1]
  PerCap = PerCap[,-1]
  row.names(GDP) <- GDP[,1]
  GDP = GDP[,-1]
  row.names(GDPzem) <- GDPzem[,1]
  GDPzem = GDPzem[,-1]
  


  
  p22 <- reactive({
    
    drzave = input$variable
    
    
    
    GDPt = t(GDP)
    GDPt<-as.data.frame(GDPt)
    names(GDP)[16]<-"Côte dIvoire"
    GDPt<-as.matrix(GDPt)

    
    sel = subset(GDPt, select=drzave)
    sel2 = melt(sel,id=row.names(sel))
    
    sel2 = na.omit(sel2) #vklopljeno po želji
    
    plGDP<- ggplot(sel2) + aes(x=Var1, y = value*100,colour=Var2) + geom_line() 
    plGDP <- plGDP + xlab("Leto") + ylab("delež BDP v %") + scale_color_discrete("Država")
    
    
    
    #p1 <-barplot(NORD1$`Military expenditures 2014 US millions`[-tr], horiz=TRUE,names.arg = NORD1$Country[-tr])
  })
  
  output$distPlot2 <- renderPlot({
    print(p22())
  })
  
  
  p33 <- reactive({
    
    drzave1 = input$variable
    
    
    
    PerCapt = t(PerCap)
    PerCapt<-as.data.frame(PerCapt)
    names(PerCapt)[16]<-"Côte dIvoire"
    PerCapt<-as.matrix(PerCapt)
 
    
    sel3 = subset(PerCapt, select=drzave1)
    sel4 = melt(sel3,id=row.names(sel3))
    
    sel4 = na.omit(sel4) #vklopljeno po želji
    
    plPerCap<- ggplot(sel4) + aes(x=Var1, y = value,colour=Var2) + geom_line() 
    plPerCap <- plPerCap + xlab("Leto") + ylab("Izdatki PC v $") + scale_color_discrete("Država")
    
    
    
    #p1 <-barplot(NORD1$`Military expenditures 2014 US millions`[-tr], horiz=TRUE,names.arg = NORD1$Country[-tr])
  })
  
  output$distPlot3 <- renderPlot({
    print(p33())
  })
  
  #ZEMLJEVID
  
  
  pretvori.zemljevid <- function(zemljevid) {
    fo <- fortify(zemljevid)
    data <- zemljevid@data
    data$id <- as.character(0:(nrow(data)-1))
    return(inner_join(fo, data, by="id"))
  }
  
  hz <-pretvori.zemljevid(svet)
  GDPzem=GDPzem*100
  row.names(GDPzem)[c(140,82,52,112,16,141)] <- c("Russia","China", "Dominican Republic", "Bosnia and Herzegovina","Ivory Coast", "Republic of Serbia")
  row.names(GDPzem)[c(12,15,142,61,162)] <- c("Central African Republic", "Democratic Republic of the Congo", "Slovakia", "Trinidad and Tobogo","United Arab Emirates")
  row.names(GDPzem)[c(131,147,116,63,85,25)] <- c("Macedonia", "United Kingdom","Czech Republic","United States of America", "South Korea","Guinea Bissau")
  GDPzem[,"admin"]<-row.names(GDPzem)
  zt <- merge(x=GDPzem,y=hz,all.y=TRUE)
  zt<- zt[with(zt, order(admin, order)), ]
  zt <- zt[,-c(38:87)]
  zt <- zt[,-c(43:47)]
  filter(zt,zt$admin=="Russia")-> rus
  rus[39] <-"Asia"
  zt[zt$admin=="Russia",]<-rus
  names(zt)[2:28] <- paste("l",names(zt)[2:28],sep="")
  
  p44 <- reactive({
    
    kontinent = input$variable2
    leto = input$animation
    l2 = as.character(leto)
    
    if(kontinent=="World"){
      ut = zt
    }else if(kontinent=="Europe"){
      ut <-filter(zt,zt$continent==kontinent)
      ut <- filter(ut,ut$lat>20, ut$lat<75)
    }else if(kontinent=="Asia"){
      ut <-filter(zt,zt$continent==kontinent)
      ut <- filter(ut,ut$long>-50)
    }else
      ut <-filter(zt,zt$continent==kontinent)
    zu = paste("l",l2,sep="")
    zemy <- ggplot() + geom_polygon(data = ut, aes_string(x="long",y="lat",group="group", fill=zu)) +
      scale_fill_gradient("% BDP",low="#ff6666", high="#000000",limits=c(0,10))

    
    #p1 <-barplot(NORD1$`Military expenditures 2014 US millions`[-tr], horiz=TRUE,names.arg = NORD1$Country[-tr])
  })
  
  output$distPlot4 <- renderPlot({
    print(p44())
  },width=800,height=600)
  
  
  
  
  
})
