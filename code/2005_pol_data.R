library(dplyr)


setwd("c:/users/tomas/documents/lei/pol/data")
ward_con_link2010 <- read.csv("ward_con_link2010.csv")


leg05 <- read.table("leg05.txt", header=TRUE)

leg05$reg <- gsub("DAR ES SALAAM", "DAR-ES-SALAAM", leg05$reg)

leg05 <- group_by(leg05, region, district, const) %>% 
  summarise(ccm_leg05=ifelse(party[which.max(votes)] %in% "CCM", 1, 0),
            split_leg05=ifelse(length(party) == 1, ifelse(is.na(perc), 100, perc),
                               abs(perc[party %in% "CCM"] - max(perc[!party %in% "CCM"], na.rm=TRUE))))

names(leg05) <- c("reg", "dis", "con", "ccm_leg05", "split_leg05")
leg05 <- leg05[, c("reg", "con", "ccm_leg05", "split_leg05")]

t <- left_join(ward_con_link2010, leg05)

nrow(t[is.na(t$ccm_leg05), ]) # 149 missing values

setwd("c:/users/tomas/documents")
write.csv(leg05, "leg05.csv", row.names=FALSE)
