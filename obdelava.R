require(reshape2)
#require(rworldmap)
require(ggplot2)
require(dplyr)
require(gridExtra)
library(maptools)
source("lib/uvozi.zemljevid.r", encoding = "UTF-8")

read.csv(file = "podatki/NATO-urejeno.csv", sep = ",", dec = ".", check.names = FALSE) -> NATO
read.csv(file = "podatki/USD-urejeno.csv", sep = ",", dec = ".", check.names = FALSE) -> CurUSD
read.csv(file = "podatki/GDP-urejeno.csv", sep = ",", dec = ".", check.names = FALSE) -> GDP
read.csv(file = "podatki/PerCap-urejeno.csv", sep = ",", dec = ".", check.names = FALSE) -> PerCap
read.csv(file = "podatki/debt-urejeno.csv", sep = ",", dec = ".", check.names = FALSE) -> debt
read.csv(file = "podatki/PC2-urejeno.csv", sep = ",", dec = ".", check.names = FALSE) -> PC2

NORD1 = NATO[order(NATO$'Military expenditures 2014 US millions',decreasing = TRUE),]
norplot <- ggplot(NORD1) + aes(x = reorder(Country,`Military expenditures 2014 US millions`), y= `Military expenditures 2014 US millions`) +xlab("Country")+geom_bar(stat="identity") + coord_flip()


plNAT<-ggplot(NORD1[-c(1,2),]) + aes(x = reorder(Country,`Military expenditures 2014 US millions`), y= `Military expenditures 2014 US millions`) +geom_bar(stat="identity") + xlab("Country")+ coord_flip()

CurUSDtidy = melt(CurUSD)
names(CurUSDtidy) <- c("Country", "Year","US millions")

PerCaptidy = melt(PerCap)

names(PerCaptidy) <- c("Country", "Year","Expenditures per capita in USD")

GDPtidy = melt(GDP)
names(GDPtidy) <- c("Country", "Year","%GDP")
GDPtidy[,3]<-GDPtidy[,3]*100



drzave = c("USA","Slovenia")

row.names(GDP) <- GDP[,1]
GDP = GDP[,-1]
GDPt = t(GDP)

sel = subset(GDPt, select=drzave)
sel2 = melt(sel,id=row.names(sel))

sel2 = na.omit(sel2) #vklopljeno po želji

plGDP<- ggplot(sel2) + aes(x=Var1, y = value,colour=Var2) + geom_line() + xlab("Leto")+ylab("% BDP")+scale_colour_discrete("Države")
#plGDP






#svet <- readShapeSpatial("podatki/mape/ne_110m_admin_0_countries.shp")
#testi <- merge(svet, sel2)

svet <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/ne_110m_admin_0_countries.zip",pot.zemljevida= "ne_110m_admin_0_countries",mapa = "zemljevidi")

# ptm <- proc.time()
# plot(svet,xlim=c(-124.5, -115),ylim=c(15, 115))
# proc.time() - ptm
# 




pretvori.zemljevid <- function(zemljevid) {
  fo <- fortify(zemljevid)
  data <- zemljevid@data
  data$id <- as.character(0:(nrow(data)-1))
  return(inner_join(fo, data, by="id"))
}

hz <-pretvori.zemljevid(svet)
# 
# zem <- ggplot() + geom_polygon(data = hz, aes(x=long, y=lat, group=group,fill=sovereignt))
# 
# 
# ptm <- proc.time()
# print(zem)
# proc.time() - ptm

row.names(GDP)[c(140,82,52,112,16,141)] <- c("Russia","China", "Dominican Republic", "Bosnia and Herzegovina","Ivory Coast", "Republic of Serbia")
row.names(GDP)[c(12,15,142,61,162)] <- c("Central African Republic", "Democratic Republic of the Congo", "Slovakia", "Trinidad and Tobogo","United Arab Emirates")
row.names(GDP)[c(131,147,116,63,85,25)] <- c("Macedonia", "United Kingdom","Czech Republic","United States of America", "South Korea","Guinea Bissau")


GDP[,"admin"]<-row.names(GDP)
zt <- merge(x=GDP,y=hz,all.y=TRUE)
zt<- zt[with(zt, order(admin, order)), ]
zt <- zt[,-c(38:87)]
zt <- zt[,-c(43:47)]
filter(zt,zt$admin=="Russia")-> rus
rus[39] <-"Asia"
zt[zt$admin=="Russia",]<-rus
kontinent = "Asia"
if(is.null(kontinent)){
  ut = zt
}else if(kontinent=="Europe"){
  ut <-filter(zt,zt$continent==kontinent)
  ut <- filter(ut,ut$lat>20, ut$lat<75)
}else if(kontinent=="Asia"){
  ut <-filter(zt,zt$continent==kontinent)
  ut <- filter(ut,ut$long>-50)
}else
  ut <-filter(zt,zt$continent==kontinent)


zem <- ggplot() + geom_polygon(data = ut , aes(x=long,y=lat,group=group,fill=`2011`*100)) +
  scale_fill_gradient("% BDP",low="#ff6666", high="#000000") 

#ptm <- proc.time()
#zem
#proc.time() - ptm

#ggplot(filter(GDPtidy,Country !="Kuwait")) + aes(x=`Year`,y=`%GDP`) + geom_point()+ geom_jitter() + geom_boxplot()
meanUSD = colMeans(CurUSD[2:28],na.rm=TRUE)
meanGDP=colMeans(GDP[1:27],na.rm=TRUE)*100
meanPerCap = colMeans(PerCap[2:28],na.rm=TRUE)


GDPscat = ggplot(GDPtidy) + aes(x=`Year`,y=`%GDP`) + 
  geom_point(alpha = 0.3) + 
  scale_color_discrete(guide = FALSE)+
  geom_jitter(position = position_jitter(width = 0.2),alpha = 0.3) +
  stat_summary(fun.y=mean, geom="point",size=15,shape="__", aes(group=1,color="#FF0000")) +
  geom_boxplot(colour="black",alpha=0.1,outlier.size = 0,coef=0)+coord_cartesian(ylim = c(0,7)) +
  geom_smooth(method="lm",aes(group = 1))

PerCapscat=ggplot(PerCaptidy) + aes(x=`Year`,y=`Expenditures per capita in USD`) + 
  geom_point(alpha = 0.3) + 
  geom_jitter(position = position_jitter(width = 0.2),alpha = 0.3) +
  stat_summary(fun.y=mean, geom="point",size=15,shape="__", aes(group=1,color="#FF0000")) +
  geom_boxplot(colour="black",alpha=0.1,outlier.size = 0,coef=0)+
  geom_smooth(method="lm",aes(group = 1))+
  coord_cartesian(ylim = c(0,600))  



  CurUSDscat=ggplot(CurUSDtidy) + aes(x=`Year`,y=`US millions`)+
    geom_point(alpha = 0.3) + 
    geom_jitter(position = position_jitter(width = 0.2),alpha = 0.3) +
    scale_colour_continuous(guide = FALSE)+
    stat_summary(fun.y=mean, geom="point",size=15,shape="__", aes(group=1,color="#FF0000")) +
    geom_boxplot(colour="black",alpha=0.1,outlier.size = 0,coef=0)+
    geom_smooth(method="lm",aes(group = 1))+
    coord_cartesian(ylim = c(0,15000))  
  
  
  
  
  
  
  
  
  GDPtidy = melt(GDP)
  names(GDPtidy) <- c("Country", "Year","%GDP")
  GDPtidy[,3]<-GDPtidy[,3]*100
  
  set.seed(1)
  as.character(PC2[,1])->PC2[,1]
  PC2[c(11),1]<-c("United States of America")
  zuz = merge(PC2,GDPtidy)
  zuz=zuz[complete.cases(zuz),]
  test = zuz
  test[,c(3,4)] = scale(test[,c(3,4)])
  k <- kmeans(test[,c(3,4)], 4,nstart=5000)
  test[5]=k[1]
  test[,5]<-factor(test[,5])
  km=ggplot(zuz)+aes(x=GDPpc,y=`%GDP`,color = test$cluster)+geom_point()+
    scale_color_discrete("Skupina")
  #km
  names(test)[1]<-"admin"
  zt2=merge(x=zt,y=test,all.x=TRUE)
  zt2<- zt2[with(zt2, order(admin, order)), ]
  zem2 <- ggplot() + 
    geom_polygon(data = zt2 , aes(x=long,y=lat,group=group,fill=cluster)) +
    scale_fill_discrete("Skupina")
    
  #zem2
  
  
  
  
  
  
  
