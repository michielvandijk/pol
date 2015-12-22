# -------------------------------------
# add the 2005 legistlative results
# to the pol_data file
# -------------------------------------

library(dplyr)

setwd("c:/users/tomas/documents/lei/pol/data")
pol_data <- read.csv("pol_data.csv")

# -------------------------------------
# read in the 2005 leg results and 
# summarise

leg05 <- read.table("leg05.txt", header=TRUE)

leg05 <- group_by(leg05, region, district, const) %>% 
  summarise(ccm_leg05=ifelse(party[which.max(votes)] %in% "CCM", 1, 0),
            split_leg05=ifelse(length(party)==1, perc,
                         abs(perc[party %in% "CCM"] - max(perc[!party %in% "CCM"]))))
names(leg05) <- c("reg", "dis", "con", "ccm_leg05", "split_leg05")
leg05 <- leg05[, c("reg", "con", "ccm_leg05", "split_leg05")]

# -------------------------------------
# join by constituency

pol_data2 <- left_join(pol_data, leg05, by=c("reg", "con"))

# write to a csv file to finish any remaining changed by hand

write.csv(pol_data2, "pol_data2.csv", row.names=FALSE)
