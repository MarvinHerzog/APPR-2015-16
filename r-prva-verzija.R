require(dplyr)
require(rvest)
require(gsubfn)
require(ggplot2)


CurUSD = read.csv(file = "podatki/SIPRI Milex data 1988-2014 Nov15 - Current USD.csv", sep = ";", dec = ".")



podatki <- data.frame()
NATOurl <- "https://en.wikipedia.org/wiki/Member_states_of_NATO"
stran <- html_session(NATOurl) %>% read_html(encoding = "UTF-8")
tabela <- stran %>% html_nodes(xpath ="//table[3]") %>% html_table() 

NATO <- data.frame(tabela)
bt <- sub("^Â\\s","",NATO[,1])
NATO[,1] <- bt
NATO = NATO[-30,]



ggplot(NATO) + aes(x = Country, y = Milita)