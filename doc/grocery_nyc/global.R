# data preprocessing

# loading data sets
retail_stores = read.csv("Retail_Food_Stores.csv")
covid = read_csv("data-by-modzcta.csv")

retail_stores2 = retail_stores[!duplicated(retail_stores$Location),]

# subset only number of cases and zip codes
covid_sub = covid[,c("MODIFIED_ZCTA","COVID_CASE_COUNT")]
unique_zip_codes = unique(retail_stores$Zip.Code)


# function to extract longitudes and latitudes
location = function(l){
  loc = strsplit(l,split="\n")[[1]][3]
  long = as.numeric(strsplit(strsplit(loc,split = ",")[[1]][1],split = "\\(")[[1]][2])
  lat = as.numeric(strsplit(strsplit(loc,split = ",")[[1]][2],split = "\\)")[[1]][1])
  return(c(long,lat))
}

retail_stores$longitude = rep(NA,nrow(retail_stores))
retail_stores$latitude = rep(NA,nrow(retail_stores))
retail_stores$location = rep(NA,nrow(retail_stores))

# function to clean `Location`
location2 = function(l){
  curr.address = paste(strsplit(l,split="\n")[[1]][1],strsplit(l,split="\n")[[1]][2])
  address = strsplit(curr.address, split = ",")[[1]][1]
  no.city = strsplit(address, split = " ")
  sub.add = no.city[[1]][-length(no.city[[1]])]
  address2 = sub.add[1]
  for(i in 2:length(sub.add)){
    address2 = paste(address2,sub.add[i])
  }
  return(address2)
}

for(i in 1:nrow(retail_stores)){
  curr_l = retail_stores$Location[i]
  loc = location(curr_l)
  retail_stores$longitude[i] = loc[1]
  retail_stores$latitude[i] = loc[2]
  retail_stores$location[i] = location2(curr_l)
}
