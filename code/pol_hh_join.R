# -------------------------------------
# match wards to constituencies with the 
# 2010 legislative and presidential
# results 

library(haven)
library(rgdal)
library(dplyr)

setwd("c:/users/tomas/documents/lei/pol/data")

# read in the link file
ward_con_link2010 <- read.csv("ward_con_link2010.csv")

# read in the legislative and presidenial results

leg2010 <- read.csv("leg2010.csv") %>% select(-dis)
prez2010 <- read.csv("prez/prez2010.csv") %>% select(-dis)

pol2010 <- left_join(ward_con_link2010, leg2010) %>% left_join(prez2010)

rm(list=ls()[!ls() %in% "pol2010"])

# -------------------------------------
# now try and join this up with the 
# actual LSMS-ISA data
# -------------------------------------

# read in the gps information
geoDir1 <- "C:/Users/Tomas/Documents/LEI/data/TZA/TZNPS2GEODTA/HH.Geovariables_Y2.dta"
gps1 <- read_dta(geoDir1) %>%
  select(y2_hhid, longitude=lon_modified, latitude=lat_modified)

setwd("C:/Users/Tomas/Documents")
TZA <- readRDS("GADM_2.7_TZA_adm3.rds")

# -------------------------------------
# Overlay the gps coordinates of each
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
  select(reg=NAME_1, dis=NAME_2, ward=NAME_3) 



gps1 <- cbind(gps1, wards2010)
gps1$reg <- toupper(gps1$reg)
gps1$dis <- toupper(gps1$dis)
gps1$ward <- toupper(gps1$ward)

gps1 <- left_join(gps1, pol2010)

# kill of the islands

islands <- c("KASKAZINI-UNGUJA", "ZANZIBAR SOUTH AND CENTRAL", "ZANZIBAR WEST",             
             "KASKAZINI-PEMBA", "KUSINI-PEMBA")

gps1 <- gps1[!gps1$reg %in% islands, ]
