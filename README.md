# Analiza svetovnih vojaških izdatkov
Avtor: Marvin Herzog

V tem projektu nameravam med drugimi analizirati naslednje stvari:
* povezavo vojaških izdatkov z BDP
* višino izdatkov per capita
* primerjava Slovenije z drugimi državami
* izdatke vojaških velesil
* (po možnosti) najti povezave finančnih šokov izdatkov z raznimi dogodki po svetu/krizami
* ...
pri tem pa želim prikazati spreminjanje navedenih podatkov skozi čas ter jih geografsko dinamično ilustrirati s časovnico



## Viri:
http://www.sipri.org/research/armaments/milex/milex_database
  Excel
  
http://data.worldbank.org/indicator/MS.MIL.XPND.GD.ZS

https://en.wikipedia.org/wiki/Member_states_of_NATO#Military_expenditures
  Spletni viri



## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`. Ko ga prevedemo,
se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`. Podatkovni
viri so v mapi `podatki/`. Zemljevidi v obliki SHP, ki jih program pobere, se
shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Spletni vmesnik

Spletni vmesnik se nahaja v datotekah v mapi `shiny/`. Poženemo ga tako, da v
RStudiu odpremo datoteko `server.R` ali `ui.R` ter kliknemo na gumb *Run App*.
Alternativno ga lahko poženemo tudi tako, da poženemo program `shiny.r`.

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `maptools` - za uvoz zemljevidov
* `sp` - za delo z zemljevidi
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `httr` - za pobiranje spletnih strani
* `XML` - za branje spletnih strani
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)
