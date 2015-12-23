wd <- "C:/Users/Tomas/Documents/LEI/pol"

library(rgdal)
library(haven)
library(dplyr)

# -------------------------------------
# read in the tanzania geo data 
# -------------------------------------

geoDir1 <- "C:/Users/Tomas/Documents/LEI/data/TZA/TZNPS2GEODTA/HH.Geovariables_Y2.dta"
geoDir2 <- "C:/Users/Tomas/Documents/LEI/data/TZA/TZA_2012_LSMS_v01_M_STATA_English_labels/HouseholdGeovars_Y3.dta"

gps1 <- read_dta(geoDir1) %>%
  select(y2_hhid, longitude=lon_modified, latitude=lat_modified)
gps2 <- read_dta(geoDir2) %>%
  select(y3_hhid, longitude=lon_dd_mod, latitude=lat_dd_mod)

# -------------------------------------
# read in a map of tanzania
# -------------------------------------

setwd("C:/Users/Tomas/Documents")
TZA <- readRDS("GADM_2.7_TZA_adm3.rds")

# -------------------------------------
# Ovrlay the gps coordinates of each
# household to match up wards
# -------------------------------------

# make sure projection used in map is
# the same as in the spatial object

llCRS <- CRS(proj4string(TZA))

# 2010

# make a spatial points object
gps_mat <- cbind(gps1$longitude, gps1$latitude)
row.names(gps_mat) <- 1:nrow(gps_mat)


sp <- SpatialPoints(gps_mat, llCRS)

# overlay the map with the points
# and join with the data frame

wards2010 <- over(sp, TZA) %>%
  select(reg=NAME_1, dis=NAME_2, ward=NAME_3) %>%
  unique

# 2012

# make a spatial points object
gps_mat <- cbind(gps2$longitude, gps2$latitude)
row.names(gps_mat) <- 1:nrow(gps_mat)

sp <- SpatialPoints(gps_mat, llCRS)

# overlay the map with the points
# and join with the data frame

wards2012 <- over(sp, TZA) %>%
  select(reg=NAME_1, dis=NAME_2, ward=NAME_3) %>%
  unique

# kill the islands which do not come into
# the analysis

islands <- c("Kaskazini-Unguja", "Zanzibar South and Central", "Zanzibar West",
             "Kaskazini-Pemba", "Kusini-Pemba")

wards2010 <- wards2010[!toupper(wards2010$reg) %in% toupper(islands),]
wards2012 <- wards2012[!toupper(wards2012$reg) %in% toupper(islands),]

wards <- rbind(wards2010, wards2012) %>% unique
wards$reg <- toupper(wards$reg)
wards$dis <- toupper(wards$dis)
wards$ward <- toupper(wards$ward)


# read in the new_pol2 file

setwd("C:/Users/Tomas/Documents/LEI/pol/data")
pol_data2 <- read.csv("pol_data2.csv", header=TRUE)
pol_data2$id <- NULL

pol_data3 <- left_join(wards, pol_data2)
pol_data3$id <- 1:nrow(pol_data3)

pol_data3 <- pol_data3[, c(9,1,2,4,3)]

write.csv(pol_data3, "pol_data3.csv", row.names=FALSE)
