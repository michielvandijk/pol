# -------------------------------------
# match up all the wards that are in the
# 2010 Tanzania data with their constituencies
# via a constituency link file.
# -------------------------------------

wd <- "C:/Users/Tomas/Documents/LEI/pol"

library(rgdal)
library(haven)
library(dplyr)

# -------------------------------------
# read in the tanzania geo data 
# -------------------------------------

geoDir <- "C:/Users/Tomas/Documents/LEI/data/TZA/TZNPS2GEODTA/HH.Geovariables_Y2.dta"
gps <- read_dta(geoDir) %>%
  select(y2_hhid, longitude=lon_modified, latitude=lat_modified)

# -------------------------------------
# read in a map of tanzania
# -------------------------------------

setwd("C:/Users/Tomas/Documents/LEI/pol/data/2012 Wards Shapefiles")
TZA <- readOGR("TZwards.shp", layer="TZwards")

# -------------------------------------
# select ward of each household from
# the TZA map and make a spatial points
# dataframe
# -------------------------------------

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

# kill the islands which do not come into
# the analysis

islands <- c("Kaskazini Unguja", "Kusini Unguja", "Mjini Magharibi",
             "Kaskazini Pemba", "Kusini Pemba")

wards2010 <- wards2010[!toupper(wards2010$reg) %in% toupper(islands),]

# -------------------------------------
# make all geographical units upper
# case for easier comparisons

wards2010$reg <- toupper(wards2010$reg)
wards2010$dis <- toupper(wards2010$dis)
wards2010$ward <- toupper(wards2010$ward)

# -------------------------------------
# for each household we need to be able 
# to match the legislative information
# from the 2010 alection. read in conLink
# file and make upper case

load(paste(wd, "data/conLink2010.RData", sep="/"))
conLink2010$reg <- toupper(conLink2010$reg)
conLink2010$dis <- toupper(conLink2010$dis)
conLink2010$con <- toupper(conLink2010$con)
conLink2010$ward <- toupper(conLink2010$ward)

# -------------------------------------
# check which regions in the LSMS-ISA
# data are not in the conLink2010 - need
# to use earlier map!!!

# for now concentrate on matching up the
# constituencies in the conLink and the 
# election data

leg10 <- read.table(paste(wd, "data/leg10.txt", sep="/"), header=TRUE)

# -------------------------------------
# summarise the leg10 data

leg10 <- group_by(leg10, region, district, const) %>% 
  summarise(ccm=ifelse(party[which.max(votes)] %in% "CCM", 1, 0),
            split=ifelse(length(party)==1, perc,
                         abs(perc[party %in% "CCM"] - max(perc[!party %in% "CCM"]))))

names(leg10) <- c("reg", "dis", "con", "ccm", "split")
leg10$reg <- toupper(leg10$reg)
leg10$dis <- toupper(leg10$dis)
leg10$con <- toupper(leg10$con)

# find which constituencies from the 
# conLink2010 file are missing from the
# leg10 file

(missing_reg <- unique(conLink2010[!conLink2010$reg %in% leg10$reg, c(1)]))

leg10$reg <- gsub("DAR ES SALAAM", "DAR-ES-SALAAM", leg10$reg)

(missing_dis <- unique(conLink2010[!conLink2010$dis %in% leg10$dis, c(1, 2, 4)]))

leg10$dis <- gsub("WILAYA YA ", "", leg10$dis)

(missing_con <- unique(conLink2010[!conLink2010$con %in% leg10$con, c(1, 2, 3, 4)]))

leg10$con <- gsub("ARUSHA  MJINI", "ARUSHA MJINI", leg10$con)

# -------------------------------------
# -------------------------------------
# -------------------------------------

# dar-es-salaam missing wards

missing_data[missing_data$reg %in% "Dar-es-salaam",]
conLink2010$ward <- gsub("Hananasif", "Hananasifu", conLink2010$ward)

reg <- rep("Dar-es-salaam", 7)
dis <- c("Kinondoni", "Kinondoni", "Kinondoni", "Ilala", "Temeke", "Temeke", "Temeke")
con <- c("Kawe", "Kawe", "Kibamba", "Ukonga", "Kigamboni", "Mbagala", "Mbagala")
ward <- c("Wazo", "Mabwepande", "Saranga", "Majohe", "Tungi", "Mianzini", "Kijichi")
voters <- NA
male <- NA
female <- NA
DES_miss <- data.frame(reg, dis, con, ward, voters, male, female)

conLink2010 <- rbind(conLink2010, DES_miss)

# ARUSHA missing wards
missing_data[missing_data$reg%in% "Arusha",]

Arusha_miss <- data.frame(
  reg="Arusha",
  dis="Arusha",
  con="Arusha Urban",
  ward="Olasiti",
  voters=NA,
  male=NA,
  female=NA)

conLink2010 <- rbind(conLink2010, Arusha_miss)

# dodoma missing wards

missing_data[missing_data$reg%in% "Dodoma",]

Dodoma_miss <- data.frame(
  reg="Dodoma",
  dis="Dodoma",
  con="Dodoma Mjini",
  ward="Chigongwe",
  voters=NA,
  male=NA,
  female=NA)

conLink2010 <- rbind(conLink2010, Dodoma_miss)

# Geita missing wards 

# Iringa Missing wards
missing_data[missing_data$reg%in% "Iringa",]

Iringa_miss <- data.frame(
  reg=rep("Iringa", 2),
  dis=c("Iringa", "Kilolo"),
  con=c("Iringa Mjini", "Kilolo"),
  ward=c("Isakalilo", "Ruaha Mbuyuni"),
  voters=NA,
  male=NA,
  female=NA)

conLink2010 <- rbind(conLink2010, Iringa_miss)

# missing wards Kagera
missing_data[missing_data$reg%in% "Kagera",]

Kagera_miss <- data.frame(
  reg="Kagera",
  dis="Missenyi",
  con="Nkenge",
  ward="Kassambya",
  voters=NA,
  male=NA,
  female=NA)

conLink2010 <- rbind(conLink2010, Kagera_miss)

# missing wards katavi
missing_data[missing_data$reg %in% "Katavi",]

Katavi_miss <- data.frame(
  reg="Katavi",
  dis="Nsimbo",
  con="Nsimbo",
  ward="Litapunga",
  voters=NA,
  male=NA,
  female=NA)

conLink2010 <- rbind(conLink2010, Katavi_miss)

# missing wards Kigoma
missing_data[missing_data$reg%in% "Kigoma",]

Kigoma_miss <- data.frame(
  reg=rep("Kigoma", 2),
  dis=c("Kasulu", "Buhigwe"),
  con=c("Kasulu", "Buhigwe"),
  ward=c("Heru Shingo", "Mugera"),
  voters=NA,
  male=NA,
  female=NA)

conLink2010 <- rbind(conLink2010, Kigoma_miss)

# Kilimajaro missing wards
missing_data[missing_data$reg%in% "Kilimanjaro",]

reg <- rep("Kilimanjaro", 5)
dis <- c("Rombo", rep("Moshi", 3), "Siha")
con <- c("Rombo", "Vunjo", "Moshi Vijijini", "Vunjo", "Siha")
ward <- c("Kirongo Samanga", "MwikaKaskazini",
          "Old Moshi Mashariki", "KiruaVunjo Mashariki",
          "Olkolili")
voters <- NA
male <- NA
female <- NA
Kili_miss <- data.frame(reg, dis, con, ward, voters, male, female)

conLink2010 <- rbind(conLink2010, Kili_miss)

# Misisng manyara wards

missing_data[missing_data$reg%in% "Manyara",]

reg <- rep("Manyara", 5)
dis <- c("Babati", "Mbulu", rep("Simanjiro", 2), "Kiteto")
con <- c("Babati Vijijini", "Mbulu Vijijini", rep("Simanjiro", 2), "Kiteto")
ward <- c("Nar", "Dinamu", "Naisinyai", "Endiantu", "Chapakazi")
voters <- NA
male <- NA
female <- NA
Many_miss <- data.frame(reg, dis, con, ward, voters, male, female)

conLink2010 <- rbind(conLink2010, Many_miss)

# missing Lindi wards
missing_data[missing_data$reg%in% "Lindi",]

reg <- rep("Lindi", 5)
dis <- c(rep("Kilwa", 2), "Nachingwea", rep("Liwale", 2))
con <- c("Kilwa Kaskazini", "Kilwa Kusini", "Nachingwea", rep("Liwale", 2))
ward <- c("Kibata", "Kivinjesingino", "Kilima Rondo", "Lilombe", "Liwale \'B\'")
voters <- NA
male <- NA
female <- NA
lindi_miss <- data.frame(reg, dis, con, ward, voters, male, female)

conLink2010 <- rbind(conLink2010, lindi_miss)

# missing wards Mara
missing_data[missing_data$reg%in% "Mara",]

Mara_miss <- data.frame(
  reg="Mara",
  dis="Bunda",
  con="Bunda Mjini",
  ward="Balili",
  voters=NA,
  male=NA,
  female=NA)

conLink2010 <- rbind(conLink2010, Mara_miss)

# Missing wards Mbeya

missing_data[missing_data$reg%in% "Mbeya",]

Mbeya_miss <- data.frame(
  reg=rep("Mbeya", 3),
  dis=c("Chunya", "Mbeya Rural", "Mbozi"),
  con=c("Lupa", "Mbeya Vijijini", "Vwawa"),
  ward=c("Makongorosi", "Itawa", "Nanyala"),
  voters=NA,
  male=NA,
  female=NA)

conLink2010 <- rbind(conLink2010, Mbeya_miss)

# missing wards Mtwara
missing_data[missing_data$reg%in% "Mtwara",]

Mtwara_miss <- data.frame(
  reg=rep("Mtwara", 8),
  dis=c(rep("Mtwara Rural", 2), "Masasi Township Authority",
        "Tandahimba", rep("Newala", 4)),
  con=c("Nanyamba", "Mtwara Vijijini", "Masasi", "Tandahimba",
        rep("Newala Mjini", 2), rep("Newala Vijijini", 2)),
  ward=c("Mtimbwilimbwi", "Libobe", "Migongo", "Nanhyanga",
         "Luchindu", "Mcholi II", "Mtunguru", "Chiwonga"),
  voters=NA,
  male=NA,
  female=NA)

conLink2010 <- rbind(conLink2010, Mtwara_miss)

# missing wards Njombe
missing_data[missing_data$reg%in% "Njombe",]

njombe_miss <- data.frame(
  reg="Njombe",
  dis="Njombe Urban",
  con="Njombe Mjini",
  ward="Ramadhani",
  voters=NA,
  male=NA,
  female=NA)

conLink2010 <- rbind(conLink2010, njombe_miss)

# missing wards Pwani

missing_data[missing_data$reg%in% "Pwani",]

pwani_miss <- data.frame(
  reg=rep("Pwani", 2),
  dis=c("Bagamoyo", "Kibaha Urban"),
  con=c("Bagamoyo", "Kibaha Mjini"),
  ward=c("Bwilingu", "Mbwawa"),
  voters=NA,
  male=NA,
  female=NA)

conLink2010 <- rbind(conLink2010, pwani_miss)

# missing wards Ruvuma
missing_data[missing_data$reg%in% "Ruvuma",]

ruvu_miss <- data.frame(
  reg=rep("Ruvuma", 8),
  dis=c(rep("Tunduru", 3), rep("Songea Rural", 2),
        "Nyasa", rep("Namtumbo", 2)),
  con=c(rep("Tunduru Kaskazini",3), rep("Peramiho", 2),
        "Nyasa", rep("Namtumbo", 2)),
  ward=c("Sisikwasisi", "Mchangani", "Nanjoka", "Muhuruku",
         "Peramiho", "Luhangarasi", "Hanga", "Mchomoro"),
  voters=NA,
  male=NA,
  female=NA)

conLink2010 <- rbind(conLink2010, ruvu_miss)

# missing wards Shinyanga
missing_data[missing_data$reg%in% "Shinyanga",]

shin_miss <- data.frame(
  reg=rep("Shinyanga", 2),
  dis=rep("Shinyanga Urban", 2),
  con=rep("Shinyanga Mjini", 2),
  ward=c("Lubaga", "Old Shinyanga"),
  voters=NA,
  male=NA,
  female=NA)

conLink2010 <- rbind(conLink2010, shin_miss)

# Missing wards Simiyu
missing_data[missing_data$reg%in% "Simiyu",]

simi_miss <- data.frame(
  reg=rep("Simiyu", 2),
  dis=c("Itilima", "Bariadi"),
  con=c("Itilima", "Bariadi"),
  ward=c("Budalabujiga", "Ngulyati"),
  voters=NA,
  male=NA,
  female=NA)

conLink2010 <- rbind(conLink2010, simi_miss)

# missing wards Singida
missing_data[missing_data$reg%in% "Singida",]

sing_miss <- data.frame(
  reg=rep("Singida", 3),
  dis=c("Ikungi", "Manyoni", "Singida Urban"),
  con=c("Singida Mashariki", "Manyoni Magharibi", "Singida Mjini"),
  ward=c("Mkiwa", "Mitundu", "Mitunduru"),
  voters=NA,
  male=NA,
  female=NA)

conLink2010 <- rbind(conLink2010, sing_miss)

# missing wards Tabora

missing_data[missing_data$reg%in% "Tabora",]

tabo_miss <- data.frame(
  reg=rep("Tabora", 3),
  dis=c("Kaliua", "Sikonge", "Tabora Urban"),
  con=c(NA, "Sikonge", "Tabora Mjini"),
  ward=c("Milambo", "Mpombwe", "Ng`ambo"),
  voters=NA,
  male=NA,
  female=NA)

conLink2010 <- rbind(conLink2010, tabo_miss)

# missing wards Tanga

missing_data[missing_data$reg%in% "Tanga",]

tang_miss <- data.frame(
  reg=rep("Tanga", 7),
  dis=c("Korogwe", "Korogwe Township Authority",
        NA, "Muheza", "Pangani", "Handeni",
        "Handeni Township Authority"),
  con=c("Korogwe Vijijini", "Korogwe Mjini", NA,
        "Muheza", "Pangani", "Handeni Vijijini",
        "Handeni Mjini"),
  ward=c("Kerenge", "Kilole", "Maheza ngulu", "Mbomole",
         "Mikunguni", "Mazingara", "Kwenjugo"),
  voters=NA,
  male=NA,
  female=NA)

conLink2010 <- rbind(conLink2010, tang_miss)

# check again what is missing
# from the conLink file

missing <- !wards %in% toupper(conLink2010$ward)
sum(missing) # 3 wards are missing
missing_data <- wards2010[missing, ]
table(missing_data$reg[drop=TRUE])

rm(list=ls()[!ls() %in% c("conLink2010", "gps", "wards2010")])

# -------------------------------------
# join the wards and the conlink together

wards2010 <- wards2010[!is.na(wards2010$reg), ]
wards2010$reg <- toupper(wards2010$reg)
wards2010$ward <- toupper(wards2010$ward)
conLink2010$reg <- toupper(conLink2010$reg)
conLink2010$ward <- toupper(conLink2010$ward)

wards2010_2 <- left_join(wards2010, conLink2010, by=c("reg", "ward"))

# still missing 27 constituencies

wards2010_2[is.na(wards2010_2$con),]

# add these in

reg <- c(rep("Njombe", 5), rep("Simiyu", 4), rep("KATAVI", 3), "Rukwa")
dis <- c("Makete", "Wanging'ombe", rep("Ludewa", 3),
         rep("Maswa", 2), rep("Meatu", 2), "Mpanda Rural",
         rep("Mpanda Urban", 2), "Sumbawanga Urban")
con <- c("Makete", "Wanging'ombe", rep("Ludewa", 3),
         rep("Maswa Magharibi", 2), "Meatu", "Kisesa", "Mpanda Vijijini",
         rep("Mpanda Mjini", 2), "Sumbawanga Mjini")
ward <- c("MATAMBA", "MDANDU", "MAWENGI", "LUPINGU", "LUDEWA",
          "BUCHAMBI", "BADI", "MWAMISHALI", "MWABUSALU", "MISHAMO",
          "KAWAJENSE", "KASHAULILI", "Majengo")
voters <- NA
male <- NA
female <- NA

x <- data.frame(reg, dis, con, ward, voters, male, female)
conLink2010 <- rbind(conLink2010, x)

wards2010$reg <- toupper(wards2010$reg)
wards2010$ward <- toupper(wards2010$ward)
conLink2010$reg <- toupper(conLink2010$reg)
conLink2010$ward <- toupper(conLink2010$ward)

wards2010_2 <- left_join(wards2010, conLink2010, by=c("reg", "ward"))

# still missing 14 constituencies

wards2010_2[is.na(wards2010_2$con),]

reg <- c("LINDI", "SINGIDA", "Tabora", "Kigoma", "SHINYANGA")
dis <- c("Kilwa", "Ikungi", "Sikonge", "Kibondo", "SHINYANGA Rural")
con <- c("Kilwa Kusini", "Singida Magharibi", "Sikonge", "MUHAMBWE",
         "Solwa")
ward <- c("Pande", "KITUNTU", "KISANGA", "KIBONDO", "MWENGE")

x <- data.frame(reg, dis, con, ward, voters, male, female)
conLink2010 <- rbind(conLink2010, x)

wards2010$reg <- toupper(wards2010$reg)
wards2010$ward <- toupper(wards2010$ward)
conLink2010$reg <- toupper(conLink2010$reg)
conLink2010$ward <- toupper(conLink2010$ward)

wards2010_2 <- left_join(wards2010, conLink2010, by=c("reg", "ward"))

# still missing 9 constituencies
wards2010_2[is.na(wards2010_2$con),]

# -------------------------------------
# read in the election results data
# and check what constituencies are
# missing from the conLink file

setwd("C:/Users/Tomas/Documents/LEI/pol/data")
leg10 <- read.table("leg10.txt", header=TRUE)

# -------------------------------------
# summarise the leg10 data

leg10 <- group_by(leg10, region, district, const) %>% 
  summarise(ccm=ifelse(party[which.max(votes)] %in% "CCM", 1, 0),
            split=ifelse(length(party)==1, perc,
                         abs(perc[party %in% "CCM"] - max(perc[!party %in% "CCM"]))))

names(leg10) <- c("reg", "dis", "con", "ccm", "split")
leg10$reg <- as.character(leg10$reg)
leg10$con <- toupper(as.character(leg10$con))
wards2010_2$con <- toupper(wards2010_2$con)

# -------------------------------------
# check how many constituencies in the
# wards2010_3 data are not in the leg data

missing <- !toupper(unique(wards2010_2$con)) %in% toupper(unique(leg10$con))
sum(missing) # 25 constituencies do not match
unique(wards2010_2$con)[missing]

wards2010_2$con <- gsub("HANDENI VIJIJINI", "HANDENI", wards2010_2$con)
wards2010_2$con <- gsub("HANDENI MJINI", "HANDENI", wards2010_2$con)
wards2010_2$con <- gsub("ARUSHA URBAN", "ARUSHA MJINI", wards2010_2$con)


missing <- !toupper(unique(wards2010_2$con)) %in% toupper(unique(leg10$con))
sum(missing) # 21 constituencies do not match
unique(wards2010_2)[missing, c("reg", "dis.x", "con", "ward")]


wards2010_3 <- left_join(wards2010_2, leg10, by=c("reg", "con"))
