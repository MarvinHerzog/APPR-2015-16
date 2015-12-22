require(reshape2)
require(rworldmap)
require(ggplot2)
require(dplyr)
library(maptools)
source("lib/uvozi.zemljevid.r", encoding = "UTF-8")

read.csv(file = "podatki/NATO-urejeno.csv", sep = ",", dec = ".", check.names = FALSE) -> NATO
read.csv(file = "podatki/USD-urejeno.csv", sep = ",", dec = ".", check.names = FALSE) -> CurUSD
read.csv(file = "podatki/GDP-urejeno.csv", sep = ",", dec = ".", check.names = FALSE) -> GDP
read.csv(file = "podatki/PerCap-urejeno.csv", sep = ",", dec = ".", check.names = FALSE) -> GDP


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

#svet <- readShapeSpatial("podatki/mape/ne_110m_admin_0_countries.shp")
#testi <- merge(svet, sel2)

svet <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/ne_110m_admin_0_countries.zip","ne_110m_admin_0_countries",force=TRUE)

ptm <- proc.time()
plot(svet,xlim=c(-124.5, -115),ylim=c(15, 115))
proc.time() - ptm




proc.time() - ptm

pretvori.zemljevid <- function(zemljevid) {
  fo <- fortify(zemljevid)
  data <- zemljevid@data
  data$id <- as.character(0:(nrow(data)-1))
  return(inner_join(fo, data, by="id"))
}

hz <-pretvori.zemljevid(svet)

zem <- ggplot() + geom_polygon(data = hz, aes(x=long, y=lat, group=group,fill=sovereignt))


ptm <- proc.time()
print(zem)
proc.time() - ptm

row.names(GDP)[c(140,82,52,112,16,141)] <- c("Russia","China", "Dominican Republic", "Bosnia and Herzegovina","Ivory Coast", "Republic of Serbia")
row.names(GDP)[c(12,15,142,61,162)] <- c("Central African Republic", "Democratic Republic of the Congo", "Slovakia", "Trinidad and Tobogo","United Arab Emirates")
row.names(GDP)[c(131,147,116,63,85,25)] <- c("Macedonia", "United Kingdom","Czech Republic","United States of America", "South Korea","Guinea Bissau")


GDP[,"sovereignt"]<-row.names(GDP)
zt <- merge(x=GDP,y=hz,all.y=TRUE)
zt<- zt[with(zt, order(sovereignt, order)), ]

zem <- ggplot() + geom_polygon(data = zt, aes(x=long, y=lat, group=group,fill=zt$"2011")) + scale_fill_gradient(low="#2412b4", high="#ff2a1a")

ptm <- proc.time()
print(zem)
proc.time() - ptm


