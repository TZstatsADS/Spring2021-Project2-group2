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
        menuItem("Grocery Stores", tabName = "GroceryStores", icon = icon("fas fa-shopping-cart"),
                 menuSubItem("Grocery Stores Search Tool", tabName = "GroceryMap", icon = icon("fas fa-search")),
                 menuSubItem("Summary", tabName = "Summary", icon = icon("fas fa-chart-area"))),
        menuItem("Safety Map", tabName = "SafetyMap", icon = icon("fas fa-globe")),
        menuItem("Neighborhood Analysis", tabName = "Neighborhood", icon = icon("fas fa-users")),
        menuItem("Age Group Analysis", tabName = "Age", icon = icon("fas fa-chart-bar")),
        menuItem("About", tabName = "About", icon = icon("fas fa-asterisk"))
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
                            h1("Cases Count by ZipCode", align = "center")),
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
                        fluidRow(
                            width = 60,
                            h1("Grocery Stores in NYC", align = "center")),
                        fluidRow(
                            column(4,
                                   wellPanel(
                                       helpText("Select the range for zip code:"),
                                       sliderInput("Range", label = h3("Range"), min = 0, max = 10, value = 0),
                                       hr(),
                                       p("Current List of Zip Codes:", style = "color:#888888;"), 
                                       verbatimTextOutput("ranges_display")
                                       
                                   )),
                            column(4,
                                   helpText("Select the zip code of your interest:"),
                                   selectInput("Zip Code", "Choose Zip Code", choices=nyc_only$Zip.Code)),
                            column(4,
                                   helpText("", br(),
                                            strong("Choose a zip code and range of your interest to search for safe stores to get your grocery."),
                                            hr(),
                                            "Example:", br(), "A zip code of 10002 and a range of 1 would search for stores in zip codes 10001, 10002, and 10003, the current stores with lowest case counts will be displayed in the following table.",
                                            hr(),
                                            "Note:", br(), "Only the current safest stores in NYC will be displayed.",
                                            "", br()))
                        ),
                        br(),
                        br(),
                        #table
                        h2("Best Stores within Selected Range"),
                        DT::dataTableOutput("table1"), 
                        
                        # suppress error message
                        tags$style(type="text/css",
                                   ".shiny-output-error { visibility: hidden; }",
                                   ".shiny-output-error:before { visibility: hidden; }"
                        ),
                        # map
                        mainPanel(leafletOutput("grocery_map", height = 600), width = 12)
                    )),
            
            tabItem(tabName = "Summary",
                    fluidPage(
                        plotOutput("hist"),
                        br(),
                        br(),
                        h2("Stores with Lowest Cases", align = "center"),
                        DT::dataTableOutput("table2")
                    )),         
            #------------------------------Safety Map------------------------------------
            
            tabItem(tabName = "SafetyMap",
                    fluidPage(
                        
                        fluidRow(
                            width = 60,
                            h1("NYC Shooting Statistics", align = "center")),
                        
                        mainPanel(leafletOutput("safetymap", height=600),
                        br(),
                        plotlyOutput("pie"), width=12)
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
            
            
            
            #------------------------------------Age Group Analysis------------------------------------
            
            tabItem(tabName = "Age",
                    fluidPage(
                        
                        #title
                        fluidRow(
                            width = 60,
                            h1("What can we see from the age distribution of COVID-19?")),
                        
                        #The distribution of death by age
                        
                        fluidRow(plotlyOutput("count")),
                        fluidRow(
                            width = 60,
                            h2("Compared with the counts, would the rates give us a different tendency?")),
                        #Show the comparison of the rates
                        fluidRow(
                            tabBox(
                                # Title can include an icon
                                title = tagList("COVID-19 Illness Rate by Disease Severity"),
                                tabPanel("Case Rate",
                                         plotlyOutput("case_rate")
                                ),
                                tabPanel("Hospitalized Rate",plotlyOutput("hos_rate")),
                                tabPanel("Death Rate",plotlyOutput("death_rate"))
                                
                            )),
                        fluidRow(
                            width = 60,
                            h2("Results from the two groups of plots:")
                        ),                              
                        fluidRow(
                            width = 60,
                            h3("Both the count and the rate suggest the old people are not easier to get COVID-19 compared with younger groups, but is this result totally reasonable?")),
                        fluidRow(
                            width = 60,
                            h3("")),
                        fluidRow(
                            width = 60,
                            h3("")),
                        fluidRow(
                            width = 60,
                            h2("Assumption: The survivor bias caused by the passive test policy can effect the data NYC collected")),
                        fluidRow(
                            width = 60,
                            h3("Old people and kids should have a lower test rate as it can be harder for them to go to the test spots")),  
                        fluidRow(plotlyOutput("test_rate")),
                        fluidRow(
                            width = 60,
                            h3(" ")),  
                        fluidRow(
                            width = 60,
                            h3("Besides, if the survivor bias exists, old people should have a lower positive rate because they're easier to get severe illness")), 
                        fluidRow(plotlyOutput("pos_rate"))
                    )),        
           
            
             #-------------------------------------Reference Page---------------------------------
            tabItem(tabName = "About", 
                    HTML(
                        "<h2> Data Source : </h2>
                              <h4><li>NYC COVID-19 Data : <a href='https://github.com/nychealth/coronavirus-data' target='_blank'>Github NYC Health</a></li></h4>
                              <h4><li>NYC Shooting Data : <a href='https://data.cityofnewyork.us/Public-Safety/NYPD-Shooting-Incident-Data-Year-To-Date-/5ucz-vwe8' target='_blank'>NYC Public Safety</a></li></h4>
                              <h4><li>NYC Retail Food Stores Data : <a href='https://catalog.data.gov/dataset/retail-food-stores' target='_blank'>State of NY government</a></li></h4>
                              <h4><li>NYC Farmers Market Data : <a href='https://catalog.data.gov/dataset/farmers-markets-in-new-york-state' target='_blank'>State of NY government</a></li></h4>"
                        
                    ),
                    
                    titlePanel("Disclaimers : "),
                    HTML(
                        "<b>NYC COVID-19 Data: </b> <br>
                              <li>This repository contains data on Coronavirus Disease 2019 (COVID-19) in New York City (NYC).  </li>
                              <li>The Health Department classifies the start of the COVID-19 outbreak in NYC as the date of the first laboratory-confirmed case, February 29, 2020. </li>
                              " 
                    ),
                    
                    HTML(
                        "<b>NYC Shooting Data : </b> <br>
                              <li>List of every shooting incident that occurred in NYC during the current calendar year.</li>"
                    ),
                    
                    HTML(
                        "<b>NYC Retail Food Stores Data : </b> <br>
                              <li>A listing of all retail food stores which are licensed by the Department of Agriculture and Markets. </li>"
                    ),
                    
                    HTML(
                        "<b>NYC Farmers Market Data : </b> <br>
                              <li> In the past decade the number of farmers' markets in New York State has grown at a rapid rate. </li>
                              <li> The dataset contains information detailing the time and location of community farmers' markets as well as the name and phone number of the market manager.</li>"
                    ),
                    
                    titlePanel("Credits : "),
                    HTML(
                        " <p>Our app was built using RShiny.</p>",
                        "<p>The following R packages were used in to build this RShiny application:</p>
                                <p>
                                <code>RCurl</code><code>dplyr</code><code>tibble</code>
                                <code>leaflet</code><code>tidyverse</code><code>shinythemes</code>
                                <code>tmap</code><code>plotly</code><code>ggplot2</code>
                                <code>tigris</code><code>shiny</code><code>shinydashboard</code><code>sf</code><code>shinyWidgets</code>
                                <code>tidyr</code><code>emojifont</code><code>viridis</code><code>readr</code><code>rgdal</code>
                                </p>
                                <p>This website is the result of 2021Spring GR5243 Project2 Group2, Class of 2021 of the M.A. Statistics program at Columbia University.</p>",
                        " <p>Chen,Pin-Chun     |email: pc2939@columbia.edu </p>",
                        " <p>Fang,Zi           |email: zf2258@columbia.edu </p>",
                        " <p>Gao,Catherine     |email: catherine.gao@columbia.edu </p>",
                        " <p>Sang,Siyuan       |email: ss6165@columbia.edu </p>",
                        " <p>Wu,Yingyao        |email: yw3659@columbia.edu </p>"
                    )
            )
    )))


