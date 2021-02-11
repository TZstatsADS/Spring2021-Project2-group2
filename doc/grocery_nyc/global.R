# data preprocessing

# loading data sets
retail_stores = read.csv("/Users/yingyaowu/Desktop/Spring2021/5243 Applied Data Science/Project 2/grocery_nyc/Retail_Food_Stores.csv")
covid = read_csv("/Users/yingyaowu/Desktop/Spring2021/5243 Applied Data Science/Project 2/grocery_nyc/data-by-modzcta.csv")

# subset only number of cases and zip codes
covid_sub = covid[,c("MODIFIED_ZCTA","COVID_CASE_COUNT")]
unique_zip_codes = unique(retail_stores$Zip.Code)

#head(retail_stores)

location = function(l){
  loc = strsplit(l,split="\n")[[1]][3]
  long = as.numeric(strsplit(strsplit(loc,split = ",")[[1]][1],split = "\\(")[[1]][2])
  lat = as.numeric(strsplit(strsplit(loc,split = ",")[[1]][2],split = "\\)")[[1]][1])
  return(c(long,lat))
}

retail_stores$longitude = rep(NA,nrow(retail_stores))
retail_stores$latitude = rep(NA,nrow(retail_stores))

for(i in 1:nrow(retail_stores)){
  curr_l = retail_stores$Location[i]
  loc = location(curr_l)
  retail_stores$longitude[i] = loc[1]
  retail_stores$latitude[i] = loc[2]
}


