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

    #-------------------- Grocery Map --------------------------
    df_subset <- reactive({
      # stores with input zip code
      store_outputs = nyc_only[nyc_only$Zip.Code == input$`Zip Code`,c("Entity.Name","location","neighborhood","Zip.Code","case_counts")]
      # stores within range
      curr_ranges = seq(as.numeric(input$`Zip Code`) - input$Range, as.numeric(input$`Zip Code`) + input$Range,1)
      for (i in 1:length(curr_ranges)){
        if(curr_ranges[i] %in% nyc_zip_codes){
          curr_stores = nyc_only[nyc_only$Zip.Code == curr_ranges[i],c("Entity.Name","location","neighborhood","Zip.Code","case_counts")]
          store_outputs = rbind(store_outputs, curr_stores)
        }
      }
      best.zip = store_outputs[which.min(store_outputs$case_counts),"Zip.Code"]
      
      # select zip code that has the lowest number of cases
      store_outputs2 = store_outputs %>%
        filter(Zip.Code == best.zip)
      colnames(store_outputs2) = c("Store Name","Address","Neighborhood","Zip Code","Case Counts")
      return(store_outputs2)
    })
    
    zip_ranges = reactive({ 
      zip_codes = seq(as.numeric(input$`Zip Code`) - input$Range, as.numeric(input$`Zip Code`) + input$Range,1) 
      zip_codes[zip_codes %in% nyc_zip_codes]
    })
    output$ranges_display = renderPrint({ zip_ranges() })
    
    output$table1 = DT::renderDataTable(DT::datatable({ df_subset() }))
    curr_best = nyc_only[nyc_only$case_counts == min(nyc_only$case_counts),c("Entity.Name","location","neighborhood","Zip.Code","case_counts")] 
    colnames(curr_best) = c("Store Name","Address","Neighborhood","Zip Code","Case Counts")
    output$table2 = DT::renderDataTable(DT::datatable({ curr_best }))
    
    dd = nyc_only %>%
      group_by(borough) %>%
      summarise(count=n())
    # histogram
    output$hist = renderPlot({
      ggplot(dd, aes(x=borough, y=count)) +
        geom_col(color = 'orange', fill = 'orange') +
        geom_text(aes(label=count), vjust=-0.5, size=3.5) +
        labs(title = "Grocery Stores by Borough", y = "Number of Stores", x = "Borough")  +
        theme_grey(16)
    })
    
    # map
    output$grocery_map = renderLeaflet({
      popup_features = paste('Store Name:', nyc_only$Entity.Name, '</br>',
                             'Neighborhood:',nyc_only$neighborhood, '</br>',
                             'Current Confirmed Cases:',nyc_only$case_counts,'</br>')
      
      leaflet(nyc_only) %>% 
        addProviderTiles(providers$CartoDB.Positron) %>% 
        addMarkers(~longitude, ~latitude, clusterOptions = markerClusterOptions(), popup = popup_features)
    })
    
    #-------------------- NYC Map --------------------------
    
    sliderValues <- reactive({
      data.frame(value = date_data_modzcta[, as.numeric(95-input$slider)])
    })
    
    output$myMap <- renderLeaflet({
      
      chosen_parameter <- if (input$checkbox == TRUE){
        as.numeric(sliderValues()$value)
      }
      else{
        if (input$type == "COVID Case Count") {
          US_zipcode$COVID_CASE_COUNT
        } else if (input$type == "COVID Death Count") {
          US_zipcode$COVID_DEATH_COUNT 
        } else if (input$type == "Percentage of Positive COVID Tests") {
          US_zipcode$PERCENT_POSITIVE
        } else if (input$type == "Percentage of Positive Antibody Tests") {
          US_zipcode$ANTIPERSCENT
        } 
      }
      
      pal <- colorNumeric(
        palette = "YlOrRd",
        domain = chosen_parameter)
      
      labels <-  paste0(
        "Zip Code: ", US_zipcode$MODIFIED_ZCTA, "<br/>",
        "Neighborhood: ", US_zipcode$NEIGHBORHOOD_NAME, "<br/>",
        "Borough: ", US_zipcode$BOROUGH_GROUP, "<br/>",
        "Population: ", floor(US_zipcode$POP_DENOMINATOR), "<br/>",
        "COVID Case Count: ", US_zipcode$COVID_CASE_COUNT, "<br/>",
        "COVID Death Count: ", US_zipcode$COVID_DEATH_COUNT, "<br/>",
        "Percentage of Positive COVID Tests: ", US_zipcode$PERCENT_POSITIVE, "<br/>",
        "Percentage of Positive Antibody Tests: ", US_zipcode$ANTIPERSCENT
      ) %>%
        
        lapply(htmltools::HTML)
      
      US_zipcode %>%
        leaflet %>% 
        addProviderTiles("CartoDB.Positron") %>% 
        
        addPolygons(fillColor = ~pal(chosen_parameter),
                    weight = 2,
                    opacity = 1,
                    color = "white",
                    dashArray = "3",
                    fillOpacity = 0.7,
                    highlight = highlightOptions(weight = 2,
                                                 color = "#666",
                                                 dashArray = "",
                                                 fillOpacity = 0.7,
                                                 bringToFront = TRUE),
                    label = labels) %>%
        
        addPolygons(data = US_zipcode[US_zipcode$GEOID10 == input$ZipCode, ], 
                    color = "red", weight = 5, fill = FALSE) %>%
        
        # addMarkers(lng=US_zipcode[US_zipcode$GEOID10 == input$ZipCode, ]$geometry[0], lat=US_zipcode[US_zipcode$GEOID10 == input$ZipCode, ]$geometry[1] ,popup="New York") %>%
        
        addLegend(pal = pal, 
                  values = ~chosen_parameter,
                  opacity = 0.7, 
                  title = htmltools::HTML(if (input$checkbox == TRUE){"Percentage of Positive Test Results"} else{input$type}),
                  position = "bottomright")
      
    })
    
   #-------------------- NYC Safety Map -----------------
    
    
    output$safetymap <- renderLeaflet({
      leaflet(shooting) %>%
        setView(lng = -73.98928, lat = 40.75042, zoom = 10) %>%
        addProviderTiles("CartoDB.Positron", options = providerTileOptions(noWrap = TRUE)) %>%
        addCircleMarkers(
          lng=~Longitude, 
          lat=~Latitude,
          radius=4,
          stroke=FALSE, 
          fillOpacity=0.5, 
          col="red"
        )
    })
    
    output$pie <- renderPlotly({
      shooting <- read.csv("../data/NYPD_Shooting.csv", header=TRUE, stringsAsFactors=FALSE)
      shooting2 <- shooting[,c("BORO", "Longitude","Latitude")]
      shooting2$BORO <- as.factor(shooting2$BORO)
      
      
      shooting_BORO <- shooting2 %>%
        group_by(BORO) %>%
        summarise(count=n())
      
      shooting_BORO[,1:2]
      count <- as.vector(shooting_BORO[,2])
      count <- as.vector(unlist(count))
      
      
      colors <- c('rgb(211,94,96)', 'rgb(128,133,133)', 'rgb(144,103,167)', 'rgb(171,104,87)', 'rgb(114,147,203)')
      BORO <- c("BRONX","BROOKLYN","MANHATTAN","QUEENS","STATEN ISLAND")
      pie <- plot_ly(shooting_BORO, labels = BORO, values = count, type = 'pie',
                     textposition = 'inside',
                     textinfo = 'label+percent',
                     insidetextfont = list(color = '#FFFFFF'),
                     hoverinfo = 'text',
                     text = ~paste(count, ' cases'),
                     marker = list(colors = colors,
                                   line = list(color = '#FFFFFF', width = 1)),
                     showlegend = FALSE)
      
      
      pie <- pie %>% layout(title = 'NYC Shooting Cases by Boroughs',
                            xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                            yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
      pie
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
    
    
    
#-------------------- Age Group Analysis -----------------  
    
    #construct a pie chart to show death count and hospitalized count distribution by age
    d_pie <- plot_ly()
    d_pie<-d_pie %>% add_pie(data = ana_death , labels = ~ AGE_GROUP, values = ~DEATH_COUNT,
                             name = "Death count",title = "Death count by age",domain = list(row = 0, column = 0))
    d_pie<-d_pie %>% add_pie(data = ana_death , labels = ~ AGE_GROUP, values = ~HOSPITALIZED_COUNT,
                             name = "Hospitalized count",title = "Hospitalized count by age",domain = list(row = 0, column = 1))
    d_pie<-d_pie %>% add_pie(data = ana_death , labels = ~ AGE_GROUP, values = ~CASE_COUNT,
                             name = "Case count",title = "Case count by age",domain = list(row = 0, column = 2))
    d_pie<-d_pie %>% layout(title = "Severe illness counts in NYC", showlegend = T, grid = list(rows=1, columns=3),
                            paper_bgcolor="transparent",
                            xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                            yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    output$count<- renderPlotly({ggplotly(d_pie)})
    
    
    #construct a bar plot to show case rate by age
    crate <- plot_ly(ana_death, x = ~AGE_GROUP, y = ~CASE_RATE, type = 'bar', name = 'Case rate')
    crate<-crate %>% add_trace(ana_death, x = ~AGE_GROUP, y = ~CASE_RATE, type='scatter',mode='lines',color='blue')
    output$case_rate<- renderPlotly({ggplotly(crate)})
    
    #construct a bar plot to show test rate by age
    trate <- plot_ly(ana_death, x = ~AGE_GROUP, y = ~TEST_RATE, type = 'bar', name = 'Test rate')
    trate<-trate %>% add_trace(ana_death, x = ~AGE_GROUP, y = ~TEST_RATE, type='scatter',mode='lines',color='blue')
    output$test_rate<- renderPlotly({ggplotly(trate)})
    
    #construct a bar plot to show hospitalized rate by age
    hrate <- plot_ly(ana_death, x = ~AGE_GROUP, y = ~HOSPITALIZED_RATE,color="orange", type = 'bar', name = 'Hospitalized rate')
    hrate<-hrate %>% add_trace(ana_death, x = ~AGE_GROUP, y = ~HOSPITALIZED_RATE, type='scatter',mode='lines',color='blue')
    output$hos_rate<- renderPlotly({ggplotly(hrate)})
    
    #construct a bar plot to show death rate by age
    drate <- plot_ly(ana_death, x = ~AGE_GROUP, y = ~DEATH_RATE, type = 'bar', name = 'Death rate')
    drate<-drate %>% add_trace(ana_death, x = ~AGE_GROUP, y = ~DEATH_RATE, type='scatter',mode='lines',color='blue')
    output$death_rate<- renderPlotly({ggplotly(drate)})
    
    #construct a bar plot to show positive rate by age
    prate <- plot_ly(ana_death, x = ~AGE_GROUP, y = ~POS_RATE,color="orange", type = 'bar', name = 'Positive rate')
    prate<-prate %>% add_trace(ana_death, x = ~AGE_GROUP, y = ~POS_RATE, type='scatter',mode='lines',color='blue')
    output$pos_rate<- renderPlotly({ggplotly(prate)})    

}) # closing the entire code block
