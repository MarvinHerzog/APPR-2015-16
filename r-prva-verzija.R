require(dplyr)
require(rvest)
require(gsubfn)


CurUSD = read.csv(file = "podatki/SIPRI Milex data 1988-2014 Nov15 - Current USD.csv", sep = ";", dec = ".")



podatki <- data.frame()
NATOurl <- "https://en.wikipedia.org/wiki/Member_states_of_NATO"
stran <- html_session(NATOurl) %>% read_html(encoding = "UTF-8")
tabela <- stran %>% html_nodes(xpath ="//table[3]") %>% html_table() 

NATO <- data.frame(tabela)
bt <- strapplyc(NATO[1],"^Â\s([.]*$",)