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
                        
                        fluidRow(
                            width = 60,
                            h1("THIS IS OUR HOME PAGE", align = "center")),
                        
                        # dashboard for current stats
                        fluidRow(
                                h2("Current NYC Status", align = "left"),
                                textOutput("timestamp")), br(),
                        
                        fluidRow(infoBoxOutput("NYCtotal")),
                        
                        fluidRow(infoBoxOutput("Boro")),
                        
                        fluidRow(infoBoxOutput("Zipcode")),
                        
                        fluidRow(infoBoxOutput("Boro_safe")),
                        
                        fluidRow(infoBoxOutput("Zipcode_safe"))
                    )),
            
            
            #------------------------------NYC Map------------------------------------
            
            tabItem(tabName = "NYCMap",
                    fluidPage(
                        
                        fluidRow(
                            width = 60,
                            h1("SHOWS OUR BEAUTIFUL MAP", align = "center"))
                    )),
            
            
            #------------------------------Grocery Map------------------------------------
            
            tabItem(tabName = "GroceryMap",
                    fluidPage(
                        
                        fluidRow(
                            width = 60,
                            h1("SHOWS OUR BEAUTIFUL MAP", align = "center"))
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


