#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# UI begins

dashboardPage(
    skin = "green",
    
    dashboardHeader(title = "Get Your Grocery Safely"),
    
    dashboardSidebar(sidebarMenu(
        menuItem("Home", tabName = "Home", icon = icon("home")),
        menuItem("NYC Map", tabName = "NYCMap", icon = icon("fas fa-globe-americas")),
        menuItem("Grocery Map", tabName = "GroceryMap", icon = icon("fas fa-shopping-cart")),
        menuItem("Neighborhood Analysis", tabName = "Neighborhood", icon = icon("fas fa-users")),
        menuItem("Analysis", tabName = "Analysis", icon = icon("fas fa-chart-bar")),
        menuItem("Conclusion", tabName = "Conclusion", icon = icon("far fa-address-card"))
    )),
    
    dashboardBody(
        
        tabItems(
            
            #----------------------------Home Page------------------------------------
            
            tabItem(tabName = "Home",
                    fluidPage(
                        
                        # header image
                        img(src = 'https://raw.githubusercontent.com/TZstatsADS/Spring2021-Project2-group2/master/app/www/header.png?token=ASOKTIRIASA5QBLBYDHGXVDAGQ52E', width = '100%'),
                        
                        
                        # dashboard for current stats
                        fluidRow(
                            column(4,
                                   fluidRow(
                                       h2("Current NYC Status", align = "left"),
                                       textOutput("timestamp")),
                                   br(),
                                   fluidRow(infoBoxOutput("NYCtotal", width = 12)),
                                   fluidRow(infoBoxOutput("Boro", width = 12)),
                                   fluidRow(infoBoxOutput("Zipcode", width = 12)),
                                   fluidRow(infoBoxOutput("Boro_safe", width = 12)),
                                   fluidRow(infoBoxOutput("Zipcode_safe", width = 12))),
                        
                        # the introduction section    
                            column(8,
                                   box(width = '100%',
                                       h1("Travel Safely for Your Grocery Today!", align = "center"),
                                       br(),
                                       tags$div(tags$ul("The American life has been dramatically changed by COVID-19 since 2020, with confirmed cases climbing from thousands to millions within a span of a few months.",
                                                        "The state of New York has been the top 5 states with most COVID cases in America since the beginning of the pandemic, and ", span(strong("New York City")), 
                                                        "has 5 times higher case counts than the rest of the state. Activities and restaurants are open and shut-down with changes in health guidelines, leaving only the essential businesses open.",
                                                        br(),br(),
                                                        "Shopping for grocery is one essential task for many New Yorkers, and how to get around safely to get your grocery has become a challenge during COVID.",
                                                        "Living in the City of New York, we need to learn how to continue our daily routine while keeping ourselves and our community safe.",
                                                        "As a result, we have created this webpage to help our fellow New Yorkers to receive up-to-date COVID information about the areas where they want to shop for grocery.",
                                                        br(),br(),
                                                        span(strong("If you ever have some of these similar ideas:")),
                                                        br(),br(),
                                                        tags$li("I enjoy picking out my own grocery."),
                                                        tags$li("I like to have fresh food."),
                                                        tags$li("I don't use app delivery for food."),
                                                        tags$li("I don't like other people touching my food."),
                                                        tags$li("I enjoy going to the store physically."),
                                                        tags$li("I crave for food randomly and want to know what's available around my area."),
                                                        tags$li("I just want to go out and walk around!!!"),
                                                        "and many more...")),
                                       h2(id ="smalltitle", "You have come to the right place!!!", align = "center"),
                                       tags$style(HTML("#smalltitle{color:green; font-style: bold;}")),
                                       div(img(src = "https://raw.githubusercontent.com/TZstatsADS/Spring2021-Project2-group2/master/app/www/footer.gif?token=ASOKTIWBNAS2SZ5NG7PKU6DAGQ57S", width = '70%'), style = "text-align: center;")
                                       )))
                    )),            
            
            #------------------------------NYC Map------------------------------------
            
            tabItem(tabName = "NYCMap",
                    fluidPage(
                        fluidRow(
                            width = 70,
                            h1("Cases count in ZipCode", align = "center")),
                        sidebarLayout(
                            position = "right",
                            sidebarPanel(
                                h3("Locate the Zipcode area", align = "center"),
                                textInput("ZipCode", label = h3("Zip Code:"), 
                                          value = "Input Zip code, example: 10001"),
                                
                                helpText("Select the information you want to display on the NYC Map."),
                                
                                selectInput("type", 
                                            label = "NYC COVID Information:",
                                            choices = list("COVID Case Count" = "COVID Case Count",
                                                           "COVID Death Count" = "COVID Death Count", 
                                                           "Percentage of Positive COVID Tests" = "Percentage of Positive COVID Tests", 
                                                           "Percentage of Positive Antibody Tests" = "Percentage of Positive Antibody Tests"), 
                                            selected = "COVID Case Count"), 
                                
                                helpText("", br(), 
                                         "Slide the bar below to check the most recent 2 months data.", br(),
                                         "The data shows the percentage of people tested who tested positive in the 7 days.", br(),
                                         "Time period: Nov 13st, 2020 to Feb 11th, 2021", br(), 
                                         "", br()), 
                                
                                checkboxInput("checkbox", label = "Check Recent Data?", value = FALSE),
                                
                                sliderInput(inputId = "slider", 
                                            label = "The data __ Days Ago",
                                            min = 0,
                                            max = 91,
                                            value = 0,
                                            step = 1)
                            ), 
                            mainPanel(leafletOutput("myMap", height = 800))
                        )
                    )
            ),
            
            
            #------------------------------Grocery Map------------------------------------
            
            tabItem(tabName = "GroceryMap",
                    fluidPage(
                        titlePanel("Grocery Stores in NYC"),
                        fluidRow(
                            column(4,
                                   wellPanel(
                                       helpText("Select the range for zip code:"),
                                       sliderInput("Range", label = h3("Range"), min = 0, max = 10, value = 0)
                                   )),
                            column(4,
                                   helpText("Select the zip code of your interest:"),
                                   selectInput("Zip Code", "Choose Zip Code", choices=nyc_only$Zip.Code))
                        ),
                        #table
                        textOutput("store_display"),
                        DT::dataTableOutput("table1"), 
                        
                        # suppress error message
                        tags$style(type="text/css",
                                   ".shiny-output-error { visibility: hidden; }",
                                   ".shiny-output-error:before { visibility: hidden; }"
                        ),
                        # map
                        mainPanel(leafletOutput("grocery_map", height = 600), width = 12)
                    )),           
            
            
            #----------------------------Neighborhood Analysis------------------------------------
            
            tabItem(tabName = "Neighborhood",
                     fluidPage(
                         
                         # tab title 
                         fluidRow(
                             width = 60,
                             h1("How Well Do You Know Your Borough During COVID?")),
                         
                         # create a drop down to select borough
                         fluidRow(
                             width = 60, 
                             selectInput("boroname", 
                                         label = "Select Your Borough", 
                                         choices = c('Bronx', 'Brooklyn', 'Manhattan', 'Queens', 'Staten Island'), 
                                         multiple = F, selected = "Bronx")),
                         
                         # create pie charts for selected borough
                         fluidRow(plotlyOutput("pie_chart")),
                         
                         # time series chart on boro's case count
                         fluidRow(plotlyOutput("time_series_plot"))
                         
                     )),
            
            
            
            #------------------------------------More Analysis------------------------------------
            
            tabItem(tabName = "Analysis",
                    fluidPage(
                        
                        fluidRow(
                            width = 60,
                            h1("MORE ANALYSIS GOES HERE", align = "center"))
                    )),            
           
            
             #-------------------------------------Conclusion Page---------------------------------
            tabItem(tabName = "Conclusion",
                    fluidPage(
                        
                        fluidRow(
                            width = 60,
                            h1("CREDITS, DISCLAIMERS, AND MORE!", align = "center"))
                    ))
    )))


