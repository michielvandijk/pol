# -------------------------------------
# organize the presidential election
# data for 2010. Summarise and store
# in a single file
# -------------------------------------

library(dplyr)

setwd("c:/users/tomas/documents/LEI/pol/data/prez")

# read in data
prez2010 <- data.frame()

# note that some excel files were missing when downloaded
# from nec website
for( i in c(1:12, 16:24)){
  fileName <- paste("prez", i, ".csv", sep="")
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
prez2010 <- group_by(prez2010, reg, dis, con) %>% 
  summarise(ccm_prez10=ifelse(party[which.max(votes)] %in% "CCM", 1, 0),
            split_prez10=ifelse(length(party) == 1, ifelse(is.na(perc), 100, perc),
                               abs(perc[party %in% "CCM"] - max(perc[!party %in% "CCM"],
                                                                na.rm=TRUE))))

rm(list=ls()[!ls() %in% "prez2010"])

write.csv(prez2010, "prez2010.csv", row.names=FALSE)
