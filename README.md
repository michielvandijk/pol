# pol
Political Economy Analysis

Data and code for linking wards in Tanzania to their respective constituencies. 

 - the maps used for joining data come from GADM
 - all political data harvested from the Tanzanian National Electoral Comission
 
 Code (6 files)
 
 - two code files, one each for scraping the 2005 and 2010 political data
 - two code files, one each for cleaning the 2005 and 2010 presidential results. Not scraped, data download directly as .xls from the nec website.
 - one file for linking only the 2010 presidential and legislative results to the survey data via the households ward, disrict and region and the GADM map of tanzania.
 
 Data ()
 
 - prez2010 and prez2005 directories contain the 2010 and 2005 raw presidential results for those years, along with the final cleaned presidential results called prez2010.csv and prez2005.csv
 
 - The ward_con_link2010.csv file is crucial for joining up the data. This was made by using the GADM map to find the region, district and ward of every household in the 2010 and 2012 surveys. This was then used in conjunction with the
