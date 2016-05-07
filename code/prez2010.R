# -------------------------------------
# organize the presidential election
# data for 2010. Summarise and store
# in a single file - do this at the
# constituency and the district level
# -------------------------------------

library(dplyr)
library(reshape2)

setwd("c:/users/tomas/documents/LEI/pol/data/prez2010")

# read in data
prez2010 <- data.frame()

# note that some excel files were missing when downloaded
# from nec website - but all regions and districts are available
# so these files likely contained nothing

for( i in c(1:12, 16:24)){
  fileName <- paste("prez2010_", i, ".csv", sep="")
  file <- read.csv(fileName)
  prez2010 <- rbind(prez2010, file)
}

# remove header rows and empty space from 
# file

bad <- prez2010$X %in% "RegionID" | prez2010$X %in% ""
prez2010 <- prez2010[!bad, ]
names(prez2010) <- c("regID", "reg", "disID", "dis", "conID", "con",
                     "candidate", "party", "votes", "spoilt", "perc")

# kill of the islands which we do not need
# and change Dar es salaam region name

islands <- c("KASKAZINI PEMBA", "KASKAZINI UNGUJA", "KUSINI PEMBA",
             "KUSINI UNGUJA")
prez2010 <- prez2010[!prez2010$reg %in% islands, ]

prez2010$reg <- gsub("DAR ES SALAAM", "DAR-ES-SALAAM", prez2010$reg)

# change factor variables to numerics
prez2010$votes <- as.numeric(as.character(prez2010$votes))
prez2010$spoilt <- as.numeric(as.character(prez2010$spoilt))
prez2010$perc <- as.numeric(as.character(prez2010$perc))
                                           
# summarise the data by constituency
# prez2010_con <- group_by(prez2010, reg, dis, con) %>% 
#   summarise(ccm_prez10=ifelse(party[which.max(votes)] %in% "CCM", 1, 0),
#             split_prez10=ifelse(length(party) == 1, ifelse(is.na(perc), 100, perc),
#                                abs(perc[party %in% "CCM"] - max(perc[!party %in% "CCM"],
#                                                                 na.rm=TRUE))))

# summarise the data by district
prez2010_dis <- group_by(prez2010, reg, dis, party) %>%
  summarise(votes=sum(votes)) 
prez2010_dis.x <- group_by(prez2010, reg, dis) %>%
  summarise(votesTotal=sum(votes))
prez2010_dis <- left_join(prez2010_dis, prez2010_dis.x); rm(prez2010_dis.x)
prez2010_dis <- mutate(prez2010_dis, percent = votes/votesTotal*100)

# Here a party has won a district if they
# have the overall highest number of votes
# in that district. This does not necessarily 
# mean that they won every constituency

# looking at all parties in each district

prez2010_dis_All <- select(prez2010_dis, reg, dis, party, percent) %>%
  dcast(reg + dis ~ party)

# just looking at ruling party
prez2010_dis <- group_by(prez2010_dis, reg, dis) %>%
  summarise(ccm_prez10=ifelse(party[which.max(votes)] %in% "CCM", 1, 0),
            split_prez10=ifelse(length(party) == 1, ifelse(is.na(percent), 100, percent),
                                abs(percent[party %in% "CCM"] - max(percent[!party %in% "CCM"],
                                                                 na.rm=TRUE))))

# file for matching up the districts
# in the political data with the
# district names in the LSMS-ISA data
# pol2lsms <- select(prez2010_dis, reg, dis)
# write.csv(pol2lsms, "c:/users/tomas/documents/LEI/pol/data/link_files/pol2lsms.csv", row.names=FALSE)

rm(list=ls()[!ls() %in% c("prez2010_dis", "prez2010_dis_All")])

# save the constituency and the district results.
saveRDS(prez2010_dis_All, "prez2010_dis_All.rds")
saveRDS(prez2010_dis, "prez2010_dis.rds")
