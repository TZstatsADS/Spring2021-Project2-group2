
fluidPage(
    titlePanel("Grocery Stores in NYC"),
    
    sidebarLayout(
        # range slider
        sidebarPanel(
            wellPanel(
                sliderInput("Range", label = h3("Range"), min = 0, max = 10, value = 0),
                hr(), p("Current Range:", style = "color:#888888;"), verbatimTextOutput("Range")
            )
        ),
        
        # table
        sidebarPanel(
            selectInput("Zip Code", "Choose Zip Code", choices=retail_stores$Zip.Code, selected = 12158),
            tableOutput("table1"),
            width = 12)
    )
    
    #mainPanel(leafletOutput("nyc_map", height = 600), width = 12)
    #))
)