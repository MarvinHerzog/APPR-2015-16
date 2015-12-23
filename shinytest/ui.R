
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyUI(fluidPage(

  
  # Application title
  headerPanel("Analiza svetovnih vojaških izdatkov"),
  div(style = "height:100px"),
  
  
  # Sidebar with a slider input for number of bins
  h2("2014 NATO izdatki v milijonih USD"),
  fluidRow(column(12,align="center",plotOutput("distPlot",width = '70%'))),

  fluidRow(
    column(12,align="center",
    sliderInput("bins",
                "Število držav:",
                min = 1,
                max = 29,
                value = 6, step = 1,width ='60%',animate=animationOptions(interval=400, loop=F))
    )
  
  ),

  
  #sidebarPanel("gagg"),

  
  # Show a plot of the generated distribution
 
  

  hr(),
  h2("Vojaški izdatki kot delež BDP oz. per capita v USD"),
  fluidRow(column(6,
                  plotOutput("distPlot2")
                  ),
           column(6,plotOutput("distPlot3"))
           ),


  

div(
fluidRow(column(10,offset=1, align="center",
  checkboxGroupInput("variable", "Države:",inline=TRUE,selected=c("Slovenia"), choices = c('Afghanistan','Albania','Algeria','Angola','Argentina','Armenia','Australia','Austria','Azerbaijan','Bahrain','Bangladesh','Belarus','Belgium','Belize','Benin','Bolivia','Bosnia-Herzegovina','Botswana','Brazil','Brunei','Bulgaria','Burkina Faso','Burundi','Cambodia','Cameroon','Canada','Cape Verde','Central African Rep.','Chad','Chile','China, P. R.','Colombia','Congo','Congo, Dem. Rep.',"Côte dIvoire",'Croatia','Cyprus','Czech Rep.','Denmark','Djibouti','Dominican Rep.','Ecuador','Egypt','El Salvador','Equatorial Guinea','Eritrea','Estonia','Ethiopia','Fiji','Finland','France','Gabon','Gambia','Georgia','Germany','Ghana','Greece','Guatemala','Guinea','Guinea-Bissau','Guyana','Haiti','Honduras','Hungary','Iceland','India','Indonesia','Iran','Iraq','Ireland','Israel','Italy','Jamaica','Japan','Jordan','Kazakhstan','Kenya','Korea, South','Kuwait','Kyrgyzstan','Laos','Latvia','Lebanon','Lesotho','Liberia','Libya','Lithuania','Luxembourg','Macedonia, FYR','Madagascar','Malawi','Malaysia','Mali','Malta','Mauritania','Mauritius','Mexico','Moldova','Mongolia','Montenegro','Morocco','Mozambique','Myanmar','Namibia','Nepal','Netherlands','New Zealand','Nicaragua','Niger','Nigeria','Norway','Oman','Pakistan','Panama','Papua New Guinea','Paraguay','Peru','Philippines','Poland','Portugal','Qatar','Romania','Russia/USSR','Rwanda','Saudi Arabia','Senegal','Serbia','Seychelles','Sierra Leone','Singapore','Slovak Rep.','Slovenia','South Africa','South Sudan','Spain','Sri Lanka','Sudan','Swaziland','Sweden','Switzerland','Syria','Taiwan','Tajikistan','Tanzania','Thailand','Timor Leste','Togo','Trinidad & Tobago','Tunisia','Turkey','Turkmenistan','UAE','Uganda','UK','Ukraine','Uruguay','USA','Uzbekistan','Venezuela','Viet Nam','Yemen','Zambia','Zimbabwe'))
  
  
  
)
),

style = "font-size: 75%; width: 100%"
),
hr(),
h2("Zemljevid izdatkov kot delež BDP"),
fluidRow(column(12,align="center", plotOutput("distPlot4"))),
div(style = "height:200px"),
fluidRow(column(12,align="center",
  sliderInput("animation", "Leto:", 1988, 2014, 1988, step = 1,width ='60%', 
              animate=animationOptions(interval=800, loop=F),sep=""))),

fluidRow(column(12,align="center",
  radioButtons("variable2","Kontinent:",inline=TRUE,selected="World",choices = c('World',"Europe","Asia","Africa","North America","South America"))
)),
hr(),
div(style = "height:200px")




))
