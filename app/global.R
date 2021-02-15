############# THIS FILE CONTAINS ALL REQUIRED PACKAGES AND DATA SETS##############

#---------------Install required packages-------------------------------------
if (!require("dplyr")) {
  install.packages("dplyr")
  library(dplyr)
}
if (!require("plotly")) {
  install.packages("plotly")
  library(plotly)
}
if (!require("shiny")) {
  install.packages("shiny")
  library(shiny)
}
if (!require("shinydashboard")) {
  install.packages("shinydashboard")
  library(shinydashboard)
}
if (!require("leaflet")) {
  install.packages("leaflet")
  library(leaflet)
}


#---------------Load required data sets--------------------------------------

# get the total case count in nyc
nyc_total <- read.csv("https://raw.githubusercontent.com/nychealth/coronavirus-data/master/totals/summary.csv")

# case count by zip code and boro
data_by_modzcta<- read.csv("https://raw.githubusercontent.com/nychealth/coronavirus-data/master/totals/data-by-modzcta.csv")

# summarize case count by boro
data_by_boro <- data_by_modzcta %>% group_by(BOROUGH_GROUP) %>% summarise(CASE_COUNT = sum(COVID_CASE_COUNT))

# covid case by borough and stats
group_case_boro <- read.csv("https://raw.githubusercontent.com/nychealth/coronavirus-data/master/totals/group-cases-by-boro.csv")
group_case_boro <- group_case_boro %>% 
  select(group, subgroup, BK_CASE_COUNT, BX_CASE_COUNT, MN_CASE_COUNT, QN_CASE_COUNT, SI_CASE_COUNT) %>% 
  rename("Brooklyn" = "BK_CASE_COUNT", "Bronx" = "BX_CASE_COUNT", "Manhattan" = "MN_CASE_COUNT" , 
         "Queens" = "QN_CASE_COUNT", "Staten Island" = "SI_CASE_COUNT")

# case count by date by borough for time series graph
data_by_date <- read.csv("https://raw.githubusercontent.com/nychealth/coronavirus-data/master/trends/data-by-day.csv")
data_by_date <- data_by_date %>% select(date_of_interest, CASE_COUNT, BX_CASE_COUNT, BK_CASE_COUNT, MN_CASE_COUNT, QN_CASE_COUNT, SI_CASE_COUNT) %>%
  rename("Brooklyn" = "BK_CASE_COUNT", "Bronx" = "BX_CASE_COUNT", "Manhattan" = "MN_CASE_COUNT" , "Queens" = "QN_CASE_COUNT", "Staten Island" = "SI_CASE_COUNT")
data_by_date$date_of_interest <- as.Date(data_by_date$date_of_interest, format = "%m/%d/%Y")


