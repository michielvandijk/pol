
# Political Economy Analysis - endogeneity

Data and code for linking wards in Tanzania to their respective constituencies. 

 - the maps used for joining data come from GADM. Important to note that because the political information is from 2010, the map used is from before the boundary changes in Tanzania. As a result the match will not be the same as if the maps that accompany the 2012 census were used.
 - all political data harvested from the Tanzanian National Electoral Comission
 
## Code (6 files)
 
 - two code files, one each for scraping the 2005 and 2010 political data
 - two code files, one each for cleaning the 2005 and 2010 presidential results. Not scraped, data download directly as .xls from the nec website.
 - one file for linking only the 2010 presidential and legislative results to the survey data via the households ward, disrict and region and the GADM map of tanzania.
 
## Data 
 
 - prez2010 and prez2005 directories contain the 2010 and 2005 raw presidential results for those years, along with the final cleaned presidential results called prez2010.csv and prez2005.csv
 
 - The ward_con_link2010.csv file is crucial for joining up the data. This was made by using the GADM map to find the region, district and ward of every household in the 2010 and 2012 surveys. 

- note that no vouchers were received by dar-es-salaam, hence missing values for total vouchers distributed per region

- for some reason in the 2012-13 total vouchers to region Nijombe is entered twice. This is the case in the source document. Also for 2012-13 there are new regions

- Geita was made from Shinyanga, Mwanza, and Kagera
- Njombe was also only made in 2012 - but there is no other information so may need to use the 2012 ward and region maps from the NBS
- Katavi was also made in 2012
