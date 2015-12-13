require(dplyr)
require(rvest)
require(gsubfn)
require(ggplot2)


CurUSD = read.csv(file = "podatki/SIPRI Milex data 1988-2014 Nov15 - Current USD.csv", sep = ";", dec = ".")
#uredimo CurUSD


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

for(i in 2:28){
  CurUSD[,i] <- as.numeric(CurUSD[,i])
  
}

View(CurUSD)


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


View(NATO)
NORD1 = NATO[order(NATO$'Military expenditures 2014 US millions',decreasing = TRUE),]


#bar plot, celoten NATO
ggplot(NORD1) + aes(x = reorder(Country,`Military expenditures 2014 US millions`), y= `Military expenditures 2014 US millions`) +xlab("Country")+geom_bar(stat="identity") + coord_flip()


ggplot(NORD1[-c(1,2),]) + aes(x = reorder(Country,`Military expenditures 2014 US millions`), y= `Military expenditures 2014 US millions`) +geom_bar(stat="identity") + xlab("Country")+ coord_flip()
