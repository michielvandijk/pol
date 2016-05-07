# maps of parties for the 2010 election and
# electoral results

library(raster)
library(dplyr)

TZA <- getData('GADM', country = "TZA", level = 2)
TZA@data$NAME_1 <- toupper(TZA@data$NAME_1)
TZA@data$NAME_2 <- toupper(TZA@data$NAME_2)

setwd("c:/users/tomas/documents/LEI/pol/data")
# link <- unique(select(TZA@data, NAME_1, NAME_2))
# names(link) <- c("REGMAP", "DISMAP")
# write.csv(link, "map2pol.csv", row.names=FALSE)
map2pol <- read.csv("map2pol.csv")
names(map2pol) <- c("NAME_1", "NAME_2", "reg", "dis")

TZA@data <- left_join(TZA@data, map2pol)

# read in the political data

setwd("c:/users/tomas/documents/LEI/pol/data/prez2010")
prez2010_dis_All <- readRDS("prez2010_dis_All.rds")

# join pol data with map

TZA@data <- left_join(TZA@data, prez2010_dis_All)

# -------------------------------------
# mapping
# -------------------------------------

library(ggplot2)

tf <- fortify(TZA, regions=OBJECTID)
TZA@data$OBJECTID <- as.character(TZA@data$OBJECTID)
tf <- left_join(tf, TZA@data, by=c("id"="OBJECTID"))

#colors
brewer.pal.info

# CCM

CCMgg <- ggplot(tf) + 
  geom_polygon(data=tf, aes(x=long, y=lat, group=group, fill=CCM), colour="black", size = .1) +
  coord_map("mercator") + ggtitle("CCM percent of votes 2010") +
  theme(legend.position="bottom") +
  scale_fill_gradientn(colours=c("#ffffff", brewer.pal(n=9, name="Blues")),
                       na.value="#ffffff")

# CHADEMA
CHADEMAgg <- ggplot(tf) + 
  geom_polygon(data=tf, aes(x=long, y=lat, group=group, fill=CHADEMA), colour="black", size = .1) +
  coord_map("mercator") + ggtitle("CHADEMA percent of votes 2010") +
  theme(legend.position="bottom") +
  scale_fill_gradientn(colours=c("#ffffff", brewer.pal(n=9, name="YlOrRd")),
                       na.value="#ffffff")

# CUF
CUFgg <- ggplot(tf) + 
  geom_polygon(data=tf, aes(x=long, y=lat, group=group, fill=CUF), colour="black", size = .1) +
  coord_map("mercator") + ggtitle("CUF percent of votes 2010") +
  theme(legend.position="bottom") +
  scale_fill_gradientn(colours=c("#ffffff", brewer.pal(n=9, name="PuRd")),
                       na.value="#ffffff")

# TLP
TLPgg <- ggplot(tf) + 
  geom_polygon(data=tf, aes(x=long, y=lat, group=group, fill=TLP), colour="black", size = .1) +
  coord_map("mercator") + ggtitle("TLP percent of votes 2010") +
  theme(legend.position="bottom") +
  scale_fill_gradientn(colours=c("#ffffff", brewer.pal(n=9, name="Greens")),
                       na.value="#ffffff")

# UPDPgg
UPDPgg <- ggplot(tf) + 
  geom_polygon(data=tf, aes(x=long, y=lat, group=group, fill=UPDP), colour="black", size = .1) +
  coord_map("mercator") + ggtitle("UPDP percent of votes 2010") +
  theme(legend.position="bottom") +
  scale_fill_gradientn(colours=c("#ffffff", brewer.pal(n=9, name="Oranges")),
                       na.value="#ffffff")

