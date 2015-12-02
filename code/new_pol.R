# -------------------------------------
# ward constituency map


# -------------------------------------
# use ward shapefile from the NBS 2012

setwd("C:/Users/Tomas/Documents/LEI/pol/data/2012 Wards Shapefiles")

library(rgdal)
ogrListLayers("TZwards.shp")
TZA <- readOGR("TZwards.shp", layer="TZwards")
wards <- toupper(TZA@data$Ward_Name)
"M,AGOWEKO" %in% wards


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
# check which regions are responsible for the
# missing values

table(missing$Region_Nam[drop=TRUE])
table(missing$District_N[drop=TRUE])

# missing four wards
missing[missing$Region_Nam %in% "Pwani",]
missing[missing$Region_Nam %in% "Katavi",]

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

# missing thirteen wards
missing[missing$Region_Nam %in% "Mwanza",]
missing[missing$Region_Nam %in% "Mbeya",]

# missing fourteen wards
missing[missing$Region_Nam %in% "Manyara",]
missing[missing$Region_Nam %in% "Mara",]
missing[missing$Region_Nam %in% "Kilimanjaro",]

# missing sixteen wards
missing[missing$Region_Nam %in% "Tanga",]
missing[missing$Region_Nam %in% "Ruvuma",]

# missing seventeen wards
missing[missing$Region_Nam %in% "Mtwara",]

# missing eighteen wards
missing[missing$Region_Nam %in% "Tabora",]


# missing twenty two wards
missing[missing$Region_Nam %in% "Arusha",]

# -------------------------------------
# compare with NEC constituency, ward 
# maps to complete the constituency ward 
# table
plot(TZA[TZA@data$Region_Nam %in% "Arusha",])
plot(TZA[TZA@data$Region_Nam %in% "Dodoma",])
plot(TZA[TZA@data$Region_Nam %in% "Kilimanjaro",])
plot(TZA[TZA@data$Region_Nam %in% "Tanga",])
plot(TZA[TZA@data$Region_Nam %in% "Morogoro",])
plot(TZA[TZA@data$Region_Nam %in% "Lindi",])
plot(TZA[TZA@data$Region_Nam %in% "Ruvuma",])
plot(TZA[TZA@data$Region_Nam %in% "Kagera",])
plot(TZA[TZA@data$Region_Nam %in% "Kigoma",])
plot(TZA[TZA@data$Region_Nam %in% "Manyara",])
plot(TZA[TZA@data$Region_Nam %in% "Mara",])
plot(TZA[TZA@data$Region_Nam %in% "Mbeya",])
plot(TZA[TZA@data$Region_Nam %in% "Mtwara",])
plot(TZA[TZA@data$Region_Nam %in% "Mwanza",])
plot(TZA[TZA@data$Region_Nam %in% "Njombe",])
plot(TZA[TZA@data$Region_Nam %in% "Rukwa",])
plot(TZA[TZA@data$Region_Nam %in% "Shinyanga",])
plot(TZA[TZA@data$Region_Nam %in% "Singida",])
plot(TZA[TZA@data$Region_Nam %in% "Tabora",])

# -------------------------------------
# plots for finding missing wards

sengerema <- TZA[TZA@data$District_N %in% "Sengerema",]
Ibisabageni <- TZA[TZA@data$Ward_Nam %in% "Ibisabageni",]

col <- toupper(sengerema@data$Ward_Name) %in% toupper(c("Ibisabageni"))
plot(sengerema, col=col)

# -------------------------------------
# matching constituency names
# read in the constituency data for 2010

# clearl a problem with the constituency data, wards where constituencies should be

leg10 <- read.table("C:/Users/Tomas/Documents/LEI/pol/data/leg10.txt", header=TRUE)
tst <- unique(select(leg10, region, const))

# cut out the islands
islands <- c("Kaskazini Unguja", "Kusini Unguja", "Mjini Magharibi", "Kaskazini Pemba", "Kusini Pemba")
islands <- toupper(islands)
tst <- tst[!tst$region %in% islands, ]

# check what is still missing
missing <- !toupper(tst$const) %in% toupper(df$con)
sum(missing) # 35
tst[missing, ]

