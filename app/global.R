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
if (!require("tibble")) {
  install.packages("tibble")
  library(tibble)
}
if (!require("tidyverse")) {
  install.packages("tidyverse")
  library(tidyverse)
}
if (!require("shinythemes")) {
  install.packages("shinythemes")
  library(shinythemes)
}

if (!require("sf")) {
  install.packages("sf")
  library(sf)
}
if (!require("RCurl")) {
  install.packages("RCurl")
  library(RCurl)
}
if (!require("tmap")) {
  install.packages("tmap")
  library(tmap)
}
if (!require("rgdal")) {
  install.packages("rgdal")
  library(rgdal)
}
if (!require("leaflet")) {
  install.packages("leaflet")
  library(leaflet)
}
if (!require("ggplot2")) {
  install.packages("ggplot2")
  library(ggplot2)
}
if (!require("viridis")) {
  install.packages("viridis")
  library(viridis)
}
if (!require("shinydashboard")) {
  install.packages("shinydashboard")
  library(shinydashboard)
}
if (!require("readr")) {
  install.packages("readr")
  library(readr)
}

if (!require("tigris")) {
  install.packages("tigris")
  library(tigris)
}
if (!require("emojifont")) {
  install.packages("emojifont")
  library(emojifont)
}

if (!require("shinyWidgets")) {
  install.packages("shinyWidgets")
  library(shinyWidgets)
}


#---------------Load required data sets--------------------------------------

# get the total case count in nyc
nyc_total <- read.csv("https://raw.githubusercontent.com/nychealth/coronavirus-data/master/totals/summary.csv")

# case count by zip code and boro
data_by_modzcta<- read.csv("https://raw.githubusercontent.com/nychealth/coronavirus-data/master/totals/data-by-modzcta.csv")
antibody_by_modzcta <- read.csv("https://raw.githubusercontent.com/nychealth/coronavirus-data/master/totals/antibody-by-modzcta.csv")
date_data_by_modzcta <- read.csv("https://raw.githubusercontent.com/nychealth/coronavirus-data/master/latest/pp-by-modzcta.csv")

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

load('./output/US_zipcode.RData')




##### grocery map and table
covid = read_csv("https://raw.githubusercontent.com/nychealth/coronavirus-data/master/totals//data-by-modzcta.csv")
retail_stores = read.csv("../data/Retail_Food_Stores.csv")
farmers_market = read.csv("../data/Farmers__Markets_in_New_York_State.csv")

farmers_market_sub = farmers_market[,c("Market.Name","Address.Line.1","City","Zip","Longitude","Latitude")]
farmers_market_sub$location = paste(farmers_market_sub$Address.Line.1,farmers_market_sub$City)
farmers_market_sub = farmers_market_sub[,c("Market.Name","location","Zip","Longitude","Latitude")]

# subset only number of cases and zip codes
store_zip_codes = unique(retail_stores$Zip.Code)
covid_zip_codes = unique(covid$MODIFIED_ZCTA)

# filter only NYC stores
nyc_only = retail_stores[retail_stores$Zip.Code == covid_zip_codes[1],]
for (i in 2:length(covid_zip_codes)){
  nyc_only = rbind(nyc_only, retail_stores[retail_stores$Zip.Code == covid_zip_codes[i],])
}

# function to extract longitudes and latitudes
long_lat = function(l){
  loc = strsplit(l,split="\n")[[1]][3]
  long = as.numeric(strsplit(strsplit(loc,split = ",")[[1]][1],split = "\\(")[[1]][2])
  lat = as.numeric(strsplit(strsplit(loc,split = ",")[[1]][2],split = "\\)")[[1]][1])
  return(c(long,lat))
}

# function to clean `Location`
location = function(l){
  return(strsplit(l, split = ",")[[1]][1])
}
# new variables
nyc_only$longitude = rep(NA,nrow(nyc_only))
nyc_only$latitude = rep(NA,nrow(nyc_only))
nyc_only$location = rep(NA,nrow(nyc_only))


# assign values to new variables
for(i in 1:nrow(nyc_only)){
  curr_l = nyc_only$Location[i]
  loc = long_lat(curr_l)
  nyc_only$longitude[i] = loc[2]
  nyc_only$latitude[i] = loc[1]
  nyc_only$location[i] = location(curr_l)
}

nyc_only2 = nyc_only[,c("Entity.Name","location","Zip.Code","longitude","latitude")]
colnames(farmers_market_sub) = colnames(nyc_only2)
colSums(is.na(farmers_market_sub))
which(is.na(farmers_market_sub$Zip.Code))
farmers_market_sub = farmers_market_sub[-is.na(farmers_market_sub$Zip.Code),]

nyc_only2 = rbind(nyc_only2, farmers_market_sub[farmers_market_sub$Zip.Code == covid_zip_codes[1],])
for (i in 2:length(covid_zip_codes)){
  nyc_only2 = rbind(nyc_only2, farmers_market_sub[farmers_market_sub$Zip.Code == covid_zip_codes[i],])
}

## clean missing values
nyc_only2 = nyc_only2[!is.na(nyc_only2$location),]
nyc_only2 = nyc_only2[!is.na(nyc_only2$longitude),]
nyc_only = nyc_only2

nyc_only$case_counts = rep(NA,nrow(nyc_only))
nyc_only$neighborhood = rep(NA,nrow(nyc_only))
nyc_only$borough = rep(NA,nrow(nyc_only))

# add case counts to the stores data set `nyc_only`
for (i in 1:length(covid_zip_codes)){
  curr.zip = covid_zip_codes[i]
  nyc_only[nyc_only$Zip.Code == curr.zip, "case_counts"] = covid[covid$MODIFIED_ZCTA == curr.zip, "COVID_CASE_COUNT"]
  nyc_only[nyc_only$Zip.Code == curr.zip, "neighborhood"] = covid[covid$MODIFIED_ZCTA == curr.zip, "NEIGHBORHOOD_NAME"]
  nyc_only[nyc_only$Zip.Code == curr.zip, "borough"] = covid[covid$MODIFIED_ZCTA == curr.zip, "BOROUGH_GROUP"]
}
nyc_only$case_counts = as.integer(nyc_only$case_counts)
nyc_zip_codes = unique(nyc_only$Zip.Code)


shooting <- read.csv("../data/NYPD_Shooting.csv", header=TRUE, stringsAsFactors=FALSE)


#case count, testing rate, and death information by age
ana_age<-read.csv("./output/age_ana/ana_age.csv")
ana_death<-read.csv("./output/age_ana/ana_death.csv")

#reference 
#http://rstudio-pubs-static.s3.amazonaws.com/133599_c0d5471268584d47b53298f0ad27e8d3.html#loading-data
#https://data.cityofnewyork.us/Public-Safety/NYPD-Shooting-Incident-Data-Year-To-Date-/5ucz-vwe8
#https://plotly.com/r/pie-charts/

#https://rstudio.github.io/leaflet/markers.html
