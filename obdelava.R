require(reshape2)
read.csv(file = "podatki/NATO-urejeno.csv", sep = ",", dec = ".", check.names = FALSE) -> NATO
read.csv(file = "podatki/USD-urejeno.csv", sep = ",", dec = ".", check.names = FALSE) -> CurUSD
read.csv(file = "podatki/GDP-urejeno.csv", sep = ",", dec = ".", check.names = FALSE) -> GDP


NORD1 = NATO[order(NATO$'Military expenditures 2014 US millions',decreasing = TRUE),]
ggplot(NORD1) + aes(x = reorder(Country,`Military expenditures 2014 US millions`), y= `Military expenditures 2014 US millions`) +xlab("Country")+geom_bar(stat="identity") + coord_flip()


ggplot(NORD1[-c(1,2),]) + aes(x = reorder(Country,`Military expenditures 2014 US millions`), y= `Military expenditures 2014 US millions`) +geom_bar(stat="identity") + xlab("Country")+ coord_flip()





drzave = c("UK","Algeria","USA","Slovenia","Israel")
row.names(GDP) <- GDP[,1]
GDP = GDP[,-1]
GDPt = t(GDP)

sel = subset(GDPt, select=drzave)
sel2 = melt(sel,id=row.names(sel))

sel2 = na.omit(sel2) #vklopljeno po želji

plGDP<- ggplot(sel2) + aes(x=Var1, y = value,colour=Var2) + geom_line()
plGDP





test_data <- data.frame(
  var0 = 100 + c(0, cumsum(runif(49, -20, 20))),
  var1 = 150 + c(0, cumsum(runif(49, -10, 10))),
  date = seq.Date(as.Date("2002-01-01"), by="1 month", length.out=100))


