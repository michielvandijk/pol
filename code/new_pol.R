# -------------------------------------
# ward constituency map


# -------------------------------------
# use ward shapefile from the NBS 2012

setwd("C:/Users/Tomas/Documents/LEI/Afripol/TZA/2012 Wards Shapefiles")

library(rgdal)
ogrListLayers("TZwards.shp")
TZA <- readOGR("TZwards.shp", layer="TZwards")
TZA@data$Ward_Name <- toupper(TZA@data$Ward_Name)

# -------------------------------------
# read in dataframe which matches wards
# to constituencies - received from NBS
# and altered.


# -------------------------------------
# check which wards are missing from the
# dataframe with the constituency and
# ward link file

islands <- c("Kaskazini Unguja", "Kusini Unguja", "Mjini Magharibi", "Kaskazini Pemba", "Kusini Pemba")
map_data <- TZA@data[!TZA@data$Region_Nam %in% islands,]
map_wards <- toupper(TZA@data$Ward_Name)[!TZA@data$Region_Nam %in% islands]
table(map_wards %in% toupper(df$ward))
missing <- map_data[!(map_wards %in% toupper(df$ward)),]

# -------------------------------------
# check which regions are responsible for th
# missing values

table(missing$Region_Nam[drop=TRUE])
table(missing$District_N[drop=TRUE])

# missing four wards
missing[missing$Region_Nam %in% "Pwani",]
missing[missing$Region_Nam %in% "Katavi",]
missing[missing$Region_Nam %in% "Pwani",]

# missing five wards
missing[missing$Region_Nam %in% "Njombe",]
missing[missing$Region_Nam %in% "Dar-es-salaam",]

# missing six wards
missing[missing$Region_Nam %in% "Dodoma",]
missing[missing$Region_Nam %in% "Geita",]

# missing seven wards
missing[missing$Region_Nam %in% "Iringa",]
missing[missing$Region_Nam %in% "Shinyanga",]
missing[missing$Region_Nam %in% "Simiyu",]
missing[missing$Region_Nam %in% "Singida",]

# missing eight wards
missing[missing$Region_Nam %in% "Rukwa",]
missing[missing$Region_Nam %in% "Lindi",]

# missing ten wards
missing[missing$Region_Nam %in% "Kagera",]

# missing eleven wards
missing[missing$Region_Nam %in% "Kigoma",]
missing[missing$Region_Nam %in% "Morogoro",]
