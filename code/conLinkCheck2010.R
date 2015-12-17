# -------------------------------------
# check for wards and constituencies that
# do not match-up with the 2010 constituency
# ward link and the constituency election data
# -------------------------------------

setwd("C:/Users/Tomas/Documents/LEI/pol")

library(rgdal)
library(haven)
library(dplyr)

# -------------------------------------
# read in the conLink file

load(paste(getwd(), "data/conLink2010.RData", sep="/"))

# -------------------------------------
# use ward shapefile from the NBS 2012

setwd("C:/Users/Tomas/Documents/LEI/pol/data/2012 Wards Shapefiles")

library(rgdal)
ogrListLayers("TZwards.shp")
TZA <- readOGR("TZwards.shp", layer="TZwards")
wards <- toupper(TZA@data$Ward_Name)

# -------------------------------------
# check which wards are missing from the
# conLink file

missing <- !toupper(conLink2010$ward) %in% wards
sum(missing)

missing_data <- conLink2010[missing, ]

table(missing_data$reg[drop=TRUE])
table(missing_data$dis[drop=TRUE])

# -------------------------------------
# check which wards we actually need
# using the 2010 household geovariables
# file and the tanzania shapefile

geoDir <- "C:/Users/Tomas/Documents/LEI/data/TZA/TZNPS2GEODTA/HH.Geovariables_Y2.dta"
gps <- read_dta(geoDir) %>%
  select(y2_hhid, longitude=lon_modified, latitude=lat_modified)

# -------------------------------------
# select ward of each long and lat from
# the TZA map and make a spatial points
# dataframe

# make a spatial points object
gps_mat <- cbind(gps$longitude, gps$latitude)
row.names(gps_mat) <- 1:nrow(gps_mat)

# make sure projection used in map is
# the same as in the spatial object

llCRS <- CRS(proj4string(TZA))
sp <- SpatialPoints(gps_mat, llCRS)

# overlay the map with the points
# and join with the data frame

wards2010 <- over(sp, TZA) %>%
  select(reg=Region_Nam, dis=District_N, ward=Ward_Name) %>%
  unique

# check which are missing but first kill
# off the islands

islands <- c("Kaskazini Unguja", "Kusini Unguja", "Mjini Magharibi",
             "Kaskazini Pemba", "Kusini Pemba")

wards2010 <- wards2010[!toupper(wards2010$reg) %in% toupper(islands),]
wards <- toupper(wards2010$ward)
missing <- !wards %in% toupper(conLink2010$ward)
sum(missing) # 74 wards are missing
missing_data <- wards2010[missing, ]

table(missing_data$reg[drop=TRUE])
table(missing_data$dis[drop=TRUE])

# look at what is missing per region and cross
# check with the 2015 constituencies
# information

reg <- rep("Dar-es-salaam", 7)
dis <- c("Kinondoni", "Kinondoni", "Kinondoni", "Ilala", "Temeke", "Temeke", "Temeke")
con <- c("Kawe", "Kawe", "Kibamba", "Ukonga", "Kigamboni", "Mbagala", "Mbagala")
ward <- c("Wazo", "Mabwepande", "Saranga", "Majohe", "Tungi", "Mianzini", "Kijichi")
voters <- NA
male <- NA
female <- NA
DES_miss <- data.frame(reg, dis, con, ward, voters, male, female)

missing_data[missing_data$reg%in% "Arusha",]
conLink2010[conLink2010$reg %in% "Arusha",]


missing_data[missing_data$reg%in% "Dar-es-salaam",]
conLink2010[conLink2010$dis %in% "Kinondoni",]

conLink2010$ward <- gsub("Hananasif", "Hananasifu", conLink2010$ward)

missing_data[missing_data$reg%in% "Dodoma",]
missing_data[missing_data$reg%in% "Geita",]
missing_data[missing_data$reg%in% "Iringa",]
missing_data[missing_data$reg%in% "Kagera",]
missing_data[missing_data$reg%in% "Katavi",]
missing_data[missing_data$reg%in% "Kigoma",]
missing_data[missing_data$reg%in% "Kilimanjaro",]
missing_data[missing_data$reg%in% "Lindi",]
missing_data[missing_data$reg%in% "Manyara",]
missing_data[missing_data$reg%in% "Mara",]
missing_data[missing_data$reg%in% "Mbeya",]
missing_data[missing_data$reg%in% "Mtwara",]
missing_data[missing_data$reg%in% "Njombe",]
missing_data[missing_data$reg%in% "Pwani",]
missing_data[missing_data$reg%in% "Ruvuma",]
missing_data[missing_data$reg%in% "Shinyanga",]
missing_data[missing_data$reg%in% "Simiyu",]
missing_data[missing_data$reg%in% "Singida",]
missing_data[missing_data$reg%in% "Tabora",]
missing_data[missing_data$reg%in% "Tanga",]
