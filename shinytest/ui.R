
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
  fluidRow(mainPanel(plotOutput("distPlot"))),

  fluidRow(
    column(6,offset = 1,
    sliderInput("bins",
                "Število držav:",
                min = 1,
                max = 29,
                value = 6, step = 1,width ='100%')
    )
  
  ),

  
  #sidebarPanel("gagg"),

  
  # Show a plot of the generated distribution
 
  

  hr(),
  h2("Delež BDP namenjen za vojaške izdatke"),
  fluidRow(column(12,plotOutput("distPlot2"))),
  

div(
fluidRow(column(10, offset=1,
  checkboxGroupInput("variable", "Države:",inline=TRUE,selected=c("Slovenia"), choices = c('Afghanistan','Albania','Algeria','Angola','Argentina','Armenia','Australia','Austria','Azerbaijan','Bahrain','Bangladesh','Belarus','Belgium','Belize','Benin','Bolivia','Bosnia-Herzegovina','Botswana','Brazil','Brunei','Bulgaria','Burkina Faso','Burundi','Cambodia','Cameroon','Canada','Cape Verde','Central African Rep.','Chad','Chile','China, P. R.','Colombia','Congo','Congo, Dem. Rep.','Côte d’Ivoire','Croatia','Cyprus','Czech Rep.','Denmark','Djibouti','Dominican Rep.','Ecuador','Egypt','El Salvador','Equatorial Guinea','Eritrea','Estonia','Ethiopia','Fiji','Finland','France','Gabon','Gambia','Georgia','Germany','Ghana','Greece','Guatemala','Guinea','Guinea-Bissau','Guyana','Haiti','Honduras','Hungary','Iceland','India','Indonesia','Iran','Iraq','Ireland','Israel','Italy','Jamaica','Japan','Jordan','Kazakhstan','Kenya','Korea, South','Kuwait','Kyrgyzstan','Laos','Latvia','Lebanon','Lesotho','Liberia','Libya','Lithuania','Luxembourg','Macedonia, FYR','Madagascar','Malawi','Malaysia','Mali','Malta','Mauritania','Mauritius','Mexico','Moldova','Mongolia','Montenegro','Morocco','Mozambique','Myanmar','Namibia','Nepal','Netherlands','New Zealand','Nicaragua','Niger','Nigeria','Norway','Oman','Pakistan','Panama','Papua New Guinea','Paraguay','Peru','Philippines','Poland','Portugal','Qatar','Romania','Russia/USSR','Rwanda','Saudi Arabia','Senegal','Serbia','Seychelles','Sierra Leone','Singapore','Slovak Rep.','Slovenia','South Africa','South Sudan','Spain','Sri Lanka','Sudan','Swaziland','Sweden','Switzerland','Syria','Taiwan','Tajikistan','Tanzania','Thailand','Timor Leste','Togo','Trinidad & Tobago','Tunisia','Turkey','Turkmenistan','UAE','Uganda','UK','Ukraine','Uruguay','USA','Uzbekistan','Venezuela','Viet Nam','Yemen','Zambia','Zimbabwe'))
  
  
  
)
),

style = "font-size: 75%; width: 100%"
)


))
