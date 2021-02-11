
source("global.R")


shinyServer(function(input, output) {
    output$value <- renderPrint({ input$num })
    
    df_subset <- reactive({
        # stores with input zip code
        store_outputs = retail_stores[retail_stores$Zip.Code == input$`Zip Code`, c("Entity.Name","location","City","Zip.Code")]
        
        # stores within range
        curr_range = input$Range
        curr_ranges = seq(as.numeric(input$`Zip Code`) - curr_range, as.numeric(input$`Zip Code`) + curr_range,1)
        
        for (i in 1:length(curr_ranges)){
            if(curr_ranges[i] %in% unique_zip_codes){
                curr_stores = retail_stores[retail_stores$Zip.Code == curr_ranges[i], c("Entity.Name","location","City","Zip.Code")]
                store_outputs = rbind(store_outputs, curr_stores)
            }
        }
        
        # select zip code that has the lowest number of cases
        curr.zip.codes = unique(store_outputs$`Zip.Code`)
        filter.stores = data.frame(zip = curr.zip.codes, cases = rep(NA, length(curr.zip.codes)))
        #for (i in 1:length(curr.zip.codes)){
        #    filter.stores[i,"cases"] = covid_sub[covid_sub$MODIFIED_ZCTA == curr.zip.codes[i], "COVID_CASE_COUNT"]
        #}
        #best.zip = filter.stores[which.min(filter.stores$cases),1]
        #store_outputs2 = store_outputs[store_outputs$`Zip.Code` == best.zip,]
        
        return(store_outputs)
    })
    
    output$table1 <- renderTable(df_subset())
    # sort zip codes by case counts
    output$Range <- renderPrint({ input$Range })
    
    
    # map
    #output$nyc_map = renderLeaflet({
    
    #})
})
