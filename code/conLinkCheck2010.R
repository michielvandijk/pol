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

setwd("C:/Users/Tomas/Documents")
TZA <- readRDS("GADM_2.7_TZA_adm3.rds")

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
  select(reg=NAME_1, dis=NAME_2, ward=NAME_3) %>%
  unique

# kill the islands which do not come into
# the analysis

islands <- c("Kaskazini-Unguja", "Zanzibar South and Central", "Zanzibar West",
             "Kaskazini-Pemba", "Kusini-Pemba")

wards2010 <- wards2010[!toupper(wards2010$reg) %in% toupper(islands),]

# -------------------------------------
# make all geographical units upper
# case for easier comparisons

wards2010$reg <- toupper(wards2010$reg)
wards2010$dis <- toupper(wards2010$dis)
wards2010$ward <- toupper(wards2010$ward)
wards2010 <- wards2010[!is.na(wards2010$reg),]

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

# regions
(missing_reg <- unique(wards2010[!wards2010$reg %in% conLink2010$reg, c(1)]))

# districts
(missing_dis <- unique(wards2010[!wards2010$dis %in% conLink2010$dis, c(1, 2)]))

conLink2010$dis <- gsub("MJINI", "URBAN", conLink2010$dis)
conLink2010$dis <- gsub("VIJIJINI", "RURAL", conLink2010$dis)

(missing_dis <- unique(wards2010[!wards2010$dis %in% conLink2010$dis, c(1, 2, 3)]))

# wards
(missing_ward <- unique(wards2010[!wards2010$ward %in% conLink2010$ward, c(1, 2, 3)]))

conLink2010$ward <- gsub("MAJI YA CHAI", "MAJIYA CHAI", conLink2010$ward)
conLink2010$ward <- gsub("KELAMFUA/MOKALA", "KELAMFUA MOKALA", conLink2010$ward)
conLink2010$ward <- gsub("KIRONGO/SAMANGA", "KIRONGO SAMANGA", conLink2010$ward)
conLink2010$ward <- gsub("ISONGO", "LSONGO", conLink2010$ward)
conLink2010$ward <- gsub("LUMEMO", "LUMELO", conLink2010$ward)
conLink2010$ward <- gsub("ILALA", "LLALA", conLink2010$ward)
conLink2010$ward <- gsub("MJIMWEMA", "MJI MWEMA", conLink2010$ward)
conLink2010$ward <- gsub("KIVINJE/SINGINO", "KIVINJE SINGINO", conLink2010$ward)
conLink2010$ward <- gsub("KILIMARONDO", "KILIMA RONDO", conLink2010$ward)
conLink2010$ward <- gsub("CHIENJELE", "CHIENJERE", conLink2010$ward)
conLink2010$ward <- gsub("CHIWONGA/NANDWAHI", "CHIWONGA", conLink2010$ward)
conLink2010$ward <- gsub("NAHNYANGA", "NANHYANGA", conLink2010$ward)
conLink2010$ward <- gsub("MAKONGOLOSI", "MAKONGOROSI", conLink2010$ward)
conLink2010$ward <- gsub("ISANGE", "LSANGE", conLink2010$ward)
conLink2010$ward <- gsub("NZEGA MJINI", "NZAGA MJINI", conLink2010$ward)
conLink2010$ward <- gsub("IGIGWA", "LGIGWA", conLink2010$ward)
conLink2010$ward <- gsub("HERU USHINGO", "ERU USHINGO", conLink2010$ward)
conLink2010$ward <- gsub("MUNZEZE", "MUZENZE", conLink2010$ward)
conLink2010$ward <- gsub("IZIGO", "LZIGO", conLink2010$ward)
conLink2010$ward <- gsub("BUPANDWA", "BUPANDWAMHELA", conLink2010$ward)

# some have just not come through
# and can be added in straight from
# file.

conLink2010 <- rbind(conLink2010,
      data.frame(reg="TANGA", dis="KOROGWE", con="KOROGWE RURAL", ward="MASHEWA",
           voters=1092, male=550, female=542))
conLink2010 <- rbind(conLink2010,
      data.frame(reg="TANGA", dis="KOROGWE", con="KOROGWE RURAL", ward="KERENGE",
           voters=1443, male=800, female=643))
conLink2010 <- rbind(conLink2010, 
                     data.frame(reg="TANGA", dis="KOROGWE", con="KOROGWE URBAN", ward="KOROGWE",
           voters=5825, male=2946, female=2879))
conLink2010 <- rbind(conLink2010,
                     data.frame(reg="TANGA", dis="KOROGWE", con="KOROGWE RURAL", ward="MAGOMA",
           voters=1341, male=725, female=616))
conLink2010 <- rbind(conLink2010, 
                     data.frame(reg="TANGA", dis="HANDENI", con="HANDENI", ward="MAZINGARA",
           voters=1518, male=758, female=760))
conLink2010 <- rbind(conLink2010, 
                     data.frame(reg="MTWARA", dis="NEWALA", con="NEWALA", ward="MCHOLI II",
                                voters=533, male=264, female=269))
conLink2010 <- rbind(conLink2010, 
                     data.frame(reg="MBEYA", dis="ILEJE", con="ILEJE", ward="ISONGOLE",
                                voters=4381, male=1913, female=2468))
conLink2010 <- rbind(conLink2010, 
                     data.frame(reg="MBEYA", dis="MBOZI", con="MBOZI MAGHARIBI", ward="LSANSA",
                                voters=19699, male=8726, female=10973))
conLink2010 <- rbind(conLink2010, 
                     data.frame(reg="MBEYA", dis="MBOZI", con="MBOZI MAGHARIBI", ward="LSANSA",
                                voters=19699, male=8726, female=10973))
conLink2010 <- rbind(conLink2010, 
                     data.frame(reg="LINDI", dis="LIWALE", con="LIWALE", ward="LIWALE \'B\'",
                                voters=3554, male=1708, female=1846))
conLink2010 <- rbind(conLink2010, 
                     data.frame(reg="TABORA", dis="NZEGA", con="NZEGA", ward="MILAMBO",
                                voters=4777, male=2255, female=2522))
conLink2010 <- rbind(conLink2010, 
                     data.frame(reg="DODOMA", dis="DODOMA URBAN", con="DODOMA URBAN", ward="CHILANGA",
                                voters=1439, male=681, female=758))
conLink2010 <- rbind(conLink2010, 
                     data.frame(reg="DODOMA", dis="DODOMA RURAL", con="MTERA", ward="MVUMI MISSION",
                                voters=8912, male=3811, female=5101))
conLink2010 <- rbind(conLink2010, 
                     data.frame(reg="DODOMA", dis="DODOMA RURAL", con="BAHI", ward="CHIBELELA",
                                voters=4962, male=2117, female=2845))
conLink2010 <- rbind(conLink2010, 
                     data.frame(reg="DODOMA", dis="DODOMA RURAL", con="BAHI", ward="BAHI",
                                voters=8741, male=4277, female=4464))
conLink2010 <- rbind(conLink2010, 
                     data.frame(reg="MOROGORO", dis="MOROGORO RURAL", con="MOROGORO KUSINI MASHARIKI", ward="MKUYUNI",
                                voters=10718, male=4802, female=5916))
conLink2010 <- rbind(conLink2010, 
                     data.frame(reg="KILIMANJARO", dis="HAI", con="SIHA", ward="SIHA KATI",
                                voters=31183, male=14901, female=16282))
conLink2010 <- rbind(conLink2010, 
                     data.frame(reg="LINDI", dis="KILWA", con="KILWA KUSINI", ward="PANDE",
                                voters=5509, male=2535, female=2974))
conLink2010 <- rbind(conLink2010, 
                     data.frame(reg="MTWARA", dis="NEWALA", con="MASASI", ward="NANGANGA",
                                voters=10686, male=5094, female=5592))
conLink2010 <- rbind(conLink2010, 
                     data.frame(reg="MTWARA", dis="MTWARA URBAN", con="MASASI", ward="MWENA",
                                voters=5997, male=2992 , female=3005))
conLink2010 <- rbind(conLink2010, 
                     data.frame(reg="RUVUMA", dis="NAMTUMBO", con="PERAMIHO", ward="MATIMIRA",
                                voters=18051, male=8660, female=9391))
conLink2010 <- rbind(conLink2010, 
                     data.frame(reg="TABORA", dis="URAMBO", con="NZEGA", ward="MILAMBO",
                                voters=1001, male=491, female=510))
conLink2010 <- rbind(conLink2010, 
                     data.frame(reg="KAGERA", dis="BUKOBA RURAL", con="NKENGE", ward="KASAMBYA",
                                voters=10237, male=4905, female=5332))
conLink2010 <- rbind(conLink2010, 
                     data.frame(reg="KAGERA", dis="BUKOBA RURAL", con="NKENGE", ward="KITOBO",
                                voters=4080, male=1833, female=2247))
conLink2010 <- rbind(conLink2010, 
                     data.frame(reg="KAGERA", dis="BUKOBA RURAL", con="NKENGE", ward="BUGANDIKA",
                                voters=4889, male=2154, female=2735))
conLink2010 <- rbind(conLink2010, 
                     data.frame(reg="KAGERA", dis="BIHARAMULO", con="BIHARAMULO MASHARIKI", ward="BUSERESERE",
                                voters=4069, male=2006, female=2063))
conLink2010 <- rbind(conLink2010, 
                     data.frame(reg="MWANZA", dis="NYAMAGANA", con="ILEMELA", ward="NYAMANORO",
                                voters=27933, male=14034, female=13899))


# LUMUMA ward is completely absent from the
# conLink2010 file. however information
# is available for the 2015 election

conLink2010 <- rbind(conLink2010, 
                     data.frame(reg="DODOMA", dis="MPWAPWA", con="KIBAKWE", ward="LUMUMA",
                                voters=NA, male=NA, female=NA))

# check how many are still missing
# just the one missing in the lake
# use google maps to find it later

(missing_ward <- unique(wards2010[!wards2010$ward %in% conLink2010$ward, c(1, 2, 3)]))
(missing_dis <- unique(wards2010[!wards2010$dis %in% conLink2010$dis, c(1, 2, 3)]))

# join the LSMS-ISA data with the conLink file

wards2010_2 <- left_join(wards2010, conLink2010)
t <- group_by(wards2010_2, reg, dis, ward, con) %>%
  summarise(n=n())

# -------------------------------------
# read in the legislative election data

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
leg10$con <- gsub("DODOMA URBAN", "DODOMA MJINI", leg10$con)
leg10$con <- gsub("KOROGWE VIJIJINI", "KOROGWE RURAL", leg10$con)
leg10$con <- gsub("KOROGWE MJINI", "KOROGWE URBAN", leg10$con)

tunduru_kaskazini <- c("KIDODOMA", "MATEMANGA", "MINDU",
                       "MUHUWESI", "MLINGOTI MAGHARIBI",
                       "MLINGOTI MASHARIKI", "NANDEMBO",
                       "LIGUNGA", "KALULU", "NAMWINYU",
                       "NAMPUNGU", "NGAPA", "NAKAPANYA")
tunduru_kusini <- c("LIGOMA", "LUKUMBULE", "MCHESI",
                    "MBESA", "NAMASAKATA", "MARUMBA",
                    "MISECHELA", "MCHOTEKA", "MTINA",
                    "NALASI", "TUWEMACHO")

# in 2010 there are only results for TUNDURU,
# no distinction for north and south
tunduru <- conLink2010[conLink2010$con %in% "TUNDURU",]
conLink2010 <- conLink2010[!conLink2010$con %in% "TUNDURU",]
tunduru$con <- ifelse(tunduru$ward %in% tunduru_kusini, "TUNDURU KUSINI",
                      ifelse(tunduru$ward %in% tunduru_kaskazini, "TUNDURU KASKAZINI", NA))
conLink2010 <- rbind(conLink2010, tunduru)

# missing from singida

SINGIDA_MAGHARIBI <- c("IHANJA", "IRISYA", "MGUNGIRA",
                       "MINYUGHE", "MUHINTIRI", "MWARU",
                       "PUMA", "SEPUKA") 
SINGIDA_MASHARIKI <- c("IKUNGI", "ISSUNA", "DUNG'UNYI",
                       "MANG'ONYI", "MISUGHAA", "MUNGAA",
                       "NTUNTU", "SIUYU")

SINGIDA <- conLink2010[conLink2010$con %in% "SINGIDA KUSINI",]
conLink2010 <- conLink2010[!conLink2010$con %in% "SINGIDA KUSINI",]
SINGIDA$con <- ifelse(SINGIDA$ward %in% SINGIDA_MAGHARIBI, "SINGIDA MAGHARIBI",
                      ifelse(SINGIDA$ward %in% SINGIDA_MASHARIKI, "SINGIDA MASHARIKI", NA))
conLink2010 <- rbind(conLink2010, SINGIDA)

# NKASI
NKASI_KASKAZINI <- c("MKWAMBA", "KIRANDO", "MTENGA", "NAMANYERE",
                     "KABWE")
NKASI_KUSINI <- c("NINDE", "WAMPEMBE", "ISALE", "KATE",
                  "KIPANDE", "SINTALI", "CHALA", "KALA")

NKASI <- conLink2010[conLink2010$con %in% "NKASI",]
conLink2010 <- conLink2010[!conLink2010$con %in% "NKASI",]
NKASI$con <- ifelse(NKASI$ward %in% NKASI_KASKAZINI, "NKASI KASKAZINI",
                      ifelse(NKASI$ward %in% NKASI_KUSINI, "NKASI KUSINI", NA))
conLink2010 <- rbind(conLink2010, NKASI)

# MPANDA VIJIJINI

# MPANDA_VIJIJINI <- c("IKOLA", "KABUNGU", "KAREMA", "KATUMA",
#                      "MISHAMO", "KATUMBA", "MPANDA NDOGO",
#                      "MWESE", "ILELA", "ILUNDE", "INYONGA",
#                      "")
# MPANDA_MJINI <- c("KASOKOLA")
# KATAVI <- c("ILELA", "ILUNDE", "INYONGA")

# maswa

MASWA_MASHARIKI <- c("SUKUMA", "BUDEKWA", "DAKAMA", "BUSILILI",
                     "LALAGO", "NGULIGULI", "IPILILO")
MASWA_MAGHARIBI <- c("SHISHIYU", "ISANGA", "MASELA", "BADI", 
                     "KADOTO", "KULIMI", "NYABUBINZA", "MALAMPAKA")

MASWA <- conLink2010[conLink2010$con %in% "MASWA",]
conLink2010 <- conLink2010[!conLink2010$con %in% "MASWA",]
MASWA$con <- ifelse(MASWA$ward %in% MASWA_MASHARIKI, "MASWA MASHARIKI",
                    ifelse(MASWA$ward %in% MASWA_MAGHARIBI, "MASWA MAGHARIBI", NA))
conLink2010 <- rbind(conLink2010, MASWA)

# -------------------------------------
# -------------------------------------
# -------------------------------------

