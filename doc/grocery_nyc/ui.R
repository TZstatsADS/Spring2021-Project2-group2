library(shiny)

retail_stores = read.csv("/Users/yingyaowu/Desktop/Spring2021/5243 Applied Data Science/Project 2/grocery_nyc/Retail_Food_Stores.csv")
head(retail_stores)


shinyUI(fluidPage(
    titlePanel("Grocery Stores in NYC"),
    #numericInput("num", label = h3("Numeric input"), value = 1),
    #hr(),
    #fluidRow(column(3, verbatimTextOutput("value"))),
    #fluidRow(column(3, verbatimTextOutput("zip"))),
    
 
    sidebarLayout(
        sidebarPanel(
            # range
            wellPanel(
                sliderInput("Range", label = h3("Range"), min = 0, max = 10, value = 0),
                hr(), p("Current Range:", style = "color:#888888;"), verbatimTextOutput("Range")
            )
        ),
        sidebarPanel(
            selectInput("Zip Code", "Choose Zip Code", choices=retail_stores$Zip.Code, selected = 12158),
            tableOutput("table1"),
            width = 12)
        
        
    )
    
    #mainPanel(leafletOutput("nyc_map", height = 600), width = 12)
))