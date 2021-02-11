# install required packages
if (!require("tidyverse")) {
  install.packages("tidyverse")
  library(tidyverse)
}
if (!require("dplyr")) {
  install.packages("dplyr")
  library(dplyr)
}
if (!require("ggplot2")) {
  install.packages("ggplot2")
  library(ggplot2)
}



#===============getting the food retail store data=========================================

# download from link "https://data.ny.gov/Economic-Development/Retail-Food-Stores/9a8c-vfzj/data"
foodstore <- read.csv('Retail_Food_Stores.csv')
foodstore$Coordinate <- sapply(strsplit(foodstore$Location, '[()]'), '[', 2)
foodstore$Latitude <- sapply(strsplit(foodstore$Coordinate, ', '), '[', 1)
foodstore$Longitude <- sapply(strsplit(foodstore$Coordinate, ', '), '[', 2)
head(foodstore)

# show list fo county and check for NA in Coordinate (we can probably omit these)
table(foodstore$County, is.na(foodstore$Coordinate))
