read.csv(file = "podatki/NATO-urejeno.csv", sep = ",", dec = ".", check.names = FALSE) -> NATO
read.csv(file = "podatki/USD-urejeno.csv", sep = ",", dec = ".", check.names = FALSE) -> CurUSD



NORD1 = NATO[order(NATO$'Military expenditures 2014 US millions',decreasing = TRUE),]
ggplot(NORD1) + aes(x = reorder(Country,`Military expenditures 2014 US millions`), y= `Military expenditures 2014 US millions`) +xlab("Country")+geom_bar(stat="identity") + coord_flip()


ggplot(NORD1[-c(1,2),]) + aes(x = reorder(Country,`Military expenditures 2014 US millions`), y= `Military expenditures 2014 US millions`) +geom_bar(stat="identity") + xlab("Country")+ coord_flip()