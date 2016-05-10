# -------------------------------------
# prepare the 2010 presidential results
# for analysis later
# -------------------------------------

dataPath <- "C:/Users/Tomas/Documents/LEI/pol" 
prez2010 <- readRDS(file.path(dataPath, "data/prez2010/prez2010.rds"))

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
# mean that they won every constituency in that
# district

# All party vote shares
prez2010_dis_All <- select(prez2010_dis, reg, dis, party, percent) %>%
  dcast(reg + dis ~ party)

# just ruling party and vote split
prez2010_dis <- group_by(prez2010_dis, reg, dis) %>%
  summarise(ccm_prez10=ifelse(party[which.max(votes)] %in% "CCM", 1, 0),
            split_prez10=ifelse(length(party) == 1, ifelse(is.na(percent), 100, percent),
                                abs(percent[party %in% "CCM"] - max(percent[!party %in% "CCM"],
                                                                    na.rm=TRUE))))

rm(list=ls()[!ls() %in% c("prez2010_dis", "prez2010_dis_All", "dataPath")])

# save the results for use in analysis later
# saveRDS(prez2010_dis_All, file.path(dataPath, "data/prez2010/prez2010_dis_All.rds"))
# saveRDS(prez2010_dis, file.path(dataPath, "data/prez2010/prez2010_dis.rds"))

# constituency code - in case it's possible to make
# a link later on.

# summarise the data by constituency
# prez2010_con <- group_by(prez2010, reg, dis, con) %>% 
#   summarise(ccm_prez10=ifelse(party[which.max(votes)] %in% "CCM", 1, 0),
#             split_prez10=ifelse(length(party) == 1, ifelse(is.na(perc), 100, perc),
#                                abs(perc[party %in% "CCM"] - max(perc[!party %in% "CCM"],
#                                                                 na.rm=TRUE))))