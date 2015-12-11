require(dplyr)
require(rvest)
require(gsubfn)
require(ggplot2)


CurUSD = read.csv(file = "podatki/SIPRI Milex data 1988-2014 Nov15 - Current USD.csv", sep = ";", dec = ".")



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
  print(class(NATO[,i]))
  
}


View(NATO)
NORD1 = NATO[order(NATO$'Military expenditures 2014 US millions',decreasing = TRUE,]
ggplot(NORD1) + aes(y = Country, x = NORD1$`Military expenditures 2014 US millions`) +geom_point()
