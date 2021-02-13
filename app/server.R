#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

source("global.R")


shinyServer(function(input, output) {
  
#-------------------- Tab Home Page -----------------------------
    
    output$timestamp <- renderText({
      paste0("Updated On: ", as.character(nyc_total$NUMBER_OF_NYC_RESIDENTS[nyc_total$MEASURE == "DATE_UPDATED"]))
      })
    
    
    output$NYCtotal <- renderInfoBox({
      infoBox(
        title = tags$p("Total NYC Cases", style = "font-size: 100%;"),
        value = tags$p(prettyNum(nyc_total$NUMBER_OF_NYC_RESIDENTS[nyc_total$MEASURE == "NYC_CASE_COUNT"], big.mark = ","), style = "font-size: 200%;"),
        icon = icon("fas fa-bed"),
        fill = T,
        color = "navy")
      })
    
    output$Boro <- renderInfoBox({
      infoBox(
        title = tags$p("Borough with Most Cases", style = "font-size: 100%;"),
        value = tags$p(data_by_boro$BOROUGH_GROUP[data_by_boro$CASE_COUNT == max(data_by_boro$CASE_COUNT)], style = "font-size: 200%;"),
        icon = icon("fas fa-user-times"),
        fill = T,
        color = "yellow")
    })
    
    output$Zipcode <- renderInfoBox({
      infoBox(
        title = tags$p("Zip Code with Most Cases", style = "font-size: 100%;"),
        value = tags$p(data_by_modzcta$MODIFIED_ZCTA[data_by_modzcta$COVID_CASE_COUNT == max(data_by_modzcta$COVID_CASE_COUNT)], style = "font-size: 200%;"),
        icon = icon("fas fa-user-times"),
        fill = T,
        color = "yellow")
    })
    
    output$Boro_safe <- renderInfoBox({
      infoBox(
        title = tags$p("Borough with Least Cases", style = "font-size: 100%;"),
        value = tags$p(data_by_boro$BOROUGH_GROUP[data_by_boro$CASE_COUNT == min(data_by_boro$CASE_COUNT)], style = "font-size: 200%;"),
        icon = icon("fas fa-user-check"),
        fill = T,
        color = "green")
    })
    
    output$Zipcode_safe <- renderInfoBox({
      infoBox(
        title = tags$p("Zip Code with Least Cases", style = "font-size:100%:"),
        value = tags$p(data_by_modzcta$MODIFIED_ZCTA[data_by_modzcta$COVID_CASE_COUNT == min(data_by_modzcta$COVID_CASE_COUNT)], style = "font-size: 200%;"),
        icon = icon("fas fa-user-check"),
        fill = T,
        color = "green")
    })


    
#-------------------- Tab Neighborhood Analysis -----------------
    
    # construct plotly pie charts for Age, Race, and Gender 
    fig <- plot_ly()
    fig <- fig %>% add_pie(data = group_case_boro[group_case_boro$group == 'Age', ], labels = ~subgroup, values = ~get(input$boroname),
                           name = "AGE", title = "AGE", domain = list(row=0, column=0))
    fig <- fig %>% add_pie(data = group_case_boro[group_case_boro$group == 'Race/ethnicity', ], labels = ~subgroup, values = ~get(input$boroname), 
                           name = "RACE", title = "RACE", domain = list(row=0, column=1))
    fig <- fig %>% add_pie(data = group_case_boro[group_case_boro$group == 'Sex', ], labels = ~subgroup, values = ~get(input$boroname),
                           name = "GENDER", title = "GENDER", domain = list(row=0, column=2))
    fig <- fig %>% layout(title = "Percentage of Case Count by Category", showlegend = F, grid = list(rows=1, columns=3),
                          paper_bgcolor="transparent",
                          xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                          yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    
    output$pie_chart <- renderPlotly({ggplotly(fig)})
    
    
    # construct plotly time series chart for borough's case count
    fig1 <- plot_ly(data = data_by_date, x = ~date_of_interest, y = ~get(input$boroname), type ='scatter', mode = 'lines', line = list(color = 'orange'))
    fig1 <- fig1 %>% layout(
      title = "Case Count Over Time",
      paper_bgcolor="transparent",
      xaxis = list(title = "Date", rangeslider = list(type = "date"), showgrid = FALSE),
      yaxis = list(title = "Case Count", showgrid = FALSE))
    
    output$time_series_plot <- renderPlotly({ggplotly(fig1)})

}) # closing the entire code block
