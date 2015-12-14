
require(dplyr)
require(rvest)
require(gsubfn)
require(ggplot2)
require(reshape2)

convert.magic <- function(obj, type){
  FUN1 <- switch(type,
                 character = as.character,
                 numeric = as.numeric,
                 factor = as.factor)
  out <- lapply(obj, FUN1)
  as.data.frame(out)
}

options(stringsAsFactors = FALSE)





#uredimo CurUSD
CurUSD = read.csv(file = "podatki/SIPRI Milex data 1988-2014 Nov15 - Current USD.csv", sep = ";", dec = ".")



names(CurUSD) <- lapply(CurUSD[5,],as.character)
CurUSD[-c(1:5),] ->CurUSD
CurUSD[-c(187:194),] ->CurUSD
CurUSD[,-2] ->CurUSD

for(i in 1:28){
  CurUSD[,i] <- as.character(CurUSD[,i])
  
}
filter(CurUSD,CurUSD$'1988'!="")->CurUSD
CurUSD <- apply(CurUSD,2,function(x) gsub("xxx",NA,x))
CurUSD <- apply(CurUSD,2,function(x) gsub("\\.\\s\\.",NA,x))

CurUSD <- as.data.frame(CurUSD)

for(i in 2:28){
  CurUSD[,i] <- as.numeric(CurUSD[,i])
  
}
CurUSD <- filter(CurUSD, !apply(is.na(CurUSD[,-1]),1,all)) #po želji
write.table(CurUSD, file = "podatki/USD-urejeno.csv",row.names=FALSE, na="",col.names=TRUE, sep=",")

#uredimo NATO


podatki <- data.frame()
NATOurl <- "https://en.wikipedia.org/wiki/Member_states_of_NATO"
stran <- html_session(NATOurl) %>% read_html(encoding = "UTF-8")
tabela <- stran %>% html_nodes(xpath ="//table[3]") %>% html_table() 





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




write.table(NATO, file = "podatki/NATO-urejeno.csv",row.names=FALSE, na="",col.names=TRUE, sep=",")



#uredimo GDP
GDP = read.csv(file = "podatki/SIPRI Milex data 1988-2014 Nov15 - Share of GDP.csv", sep = ";", dec = ".")
View(GDP)
GDP <- data.frame(lapply(GDP, as.character), stringsAsFactors=FALSE)

names(GDP) <- lapply(GDP[5,],as.character)
GDP[,-c(30:71)] ->GDP
GDP[-c(192:199),] ->GDP
GDP[-c(1:5),] ->GDP
GDP[,-2] ->GDP

#for(i in 1:28){
#  GDP[,i] <- as.character(GDP[,i])

#}

filter(GDP,GDP$'1988'!="")->GDP
GDP <- apply(GDP,2,function(x) gsub("xxx",NA,x))
GDP <- apply(GDP,2,function(x) gsub("\\.\\s\\.",NA,x))
GDP <- apply(GDP,2,function(x) gsub("%","",x))
GDP <- apply(GDP,2,function(x) gsub("\\s+$","",x))


GDP <- as.data.frame(GDP)

for(i in 2:28){
  GDP[,i] <- as.numeric(GDP[,i])
  
}

GDP[2:28] <- apply(GDP[2:28],2,function(x){x/100})
GDP <- filter(GDP, !apply(is.na(GDP[,-1]),1,all)) #po želji
write.table(GDP, file = "podatki/GDP-urejeno.csv",row.names=FALSE, na="",col.names=TRUE, sep=",")