# scraper for getting legislative body election data on Tanzania

# function for scraping data from webpage
get_leg_data <- function(url, CSS){

  require(rvest)
  require(dplyr)

  leg <- url %>%
    html %>%
    html_nodes(CSS) %>%
    html_table(header=T) %>%
    data.frame %>%
    filter(!Region %in% "Region") %>%
    select(-Region, -District, -Const)

  return(leg)

}


# urls for the legislative data, spread over three pages for 2005
url05_1 <- "https://support.toyotatz.com/nec2/index.php?modules=election_results&sub=&etype=2&year=10&region=&district=&const=&ward=&button2=Submit"
url05_2 <- "https://support.toyotatz.com/nec2/index.php?page=1&modules=election_results&sub=&etype=2&year=10&region=&district=&const=&ward=&button2=Submit"
url05_3 <- "https://support.toyotatz.com/nec2/index.php?page=2&modules=election_results&sub=&etype=2&year=10&region=&district=&const=&ward=&button2=Submit"

# urls for the legislative data, spread over three pages for 2010
url10_1 <- "https://support.toyotatz.com/nec2/index.php?modules=election_results_2010&sub=&etype=2&region=&button2=Submit"
url10_2 <- "https://support.toyotatz.com/nec2/index.php?page=1&modules=election_results_2010&sub=&etype=2&region=&button2=Submit"
url10_3 <- "https://support.toyotatz.com/nec2/index.php?page=2&modules=election_results_2010&sub=&etype=2&region=&button2=Submit"

# CSS paths for 2005 and 2010 are the same
CSS <- "#print > table"

# grab all the data for 2005
leg05_1 <- get_leg_data(url05_1, CSS)
leg05_2 <- get_leg_data(url05_2, CSS)
leg05_3 <- get_leg_data(url05_3, CSS)

# grab all the data for 2010
leg10_1 <- get_leg_data(url10_1, CSS)
leg10_2 <- get_leg_data(url10_2, CSS)
leg10_3 <- get_leg_data(url10_3, CSS)

# combine data into two dataframes - One for each year
leg05 <- rbind(leg05_1, leg05_2, leg05_3)
leg10 <- rbind(leg10_1, leg10_2, leg10_3)

# looks like there were a few fewer constituencies in 2005 compared to 2010
length(unique(leg05$ConstID))
length(unique(leg10$ConstID))

# check if region and district names were the same across the two years
all(unique(leg05$RegionID)==unique(leg10$RegionID))
table(unique(leg05$DistrictID) %in% unique(leg10$DistrictID))
table(unique(leg05$ConstID) %in% unique(leg10$ConstID))

rm(list=ls()[!ls() %in% c("leg05", "leg10")])

# rename variables. Notice that the 2005 data has the sex of the candidate but
# the 2010 data does not
leg05 <- rename(leg05, region=RegionID, district=DistrictID, const=ConstID, candidate=Candidate,
                party=Party, sex=Sex, votes=Valid.Votes, spltvotes=Spoilt.Votes, perc=X.)
leg10 <- rename(leg10, region=RegionID, district=DistrictID, const=ConstID, candidate=Candidates,
                party=Political.Party, votes=Total.Votes, spltvotes=Spoiltvotes, perc=Percentage.Votes)

# Make a few changes to the data to make it more suitable for working with later
# get rid of any commas and make numerics
leg05$votes <- gsub(",", "", leg05$votes) %>% as.numeric
leg05$spltvotes <- gsub(",", "", leg05$spltvotes) %>% as.numeric

leg10$votes <- gsub(",", "", leg10$votes) %>% as.numeric
leg10$spltvotes <- gsub(",", "", leg10$spltvotes) %>% as.numeric

leg05$perc <- leg05$perc %>% as.numeric
leg10$perc <- leg10$perc %>% as.numeric

leg05$party <- leg05$party %>% as.factor
leg10$party <- leg10$party %>% as.factor

leg05$sex <- leg05$sex %>% as.factor

write.table(leg05, "C:/Users/Tomas/Documents/leg05.txt", row.names=FALSE)
write.table(leg10, "C:/Users/Tomas/Documents/leg10.txt", row.names=FALSE)



