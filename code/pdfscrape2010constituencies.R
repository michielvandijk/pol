# -------------------------------------
# pdf scrape 2010
# -------------------------------------

setwd("C:/Users/Tomas/Documents/LEI/pol/data")

# use regex to order the information the way
# that you want
x <- readLines("jimboKata2010Altered.txt")
x2 <- gsub("(?<=[a-zA-Z])(\\s|\\s{2})(?=[a-zA-Z])", "-", x, perl=TRUE)
x3 <- gsub("(?<=\\d)(\\s{0,})(?!\\w)", "", x2, perl=TRUE)
x4 <- gsub("(\\s)(?!\\w)", "", x3, perl=TRUE)
x5 <- gsub("(?<!\\w)(\\s)", "", x4, perl = TRUE)

# select on length of resulting strings
list <- lapply(x5, function(elt) strsplit(elt, " "))
s <- sapply(list, function(elt) length(elt[[1]]))

bad <- s %in% 0 | s %in% 1 | s %in% 3
x6 <- x5[!bad]

# function for filling gaps with NA values
extender <- function(x){
  if(length(x) == 4){
    x <- c(NA, NA, NA, x)
  } else if (length(x)==5){
    x <- c(NA, NA, x)
  } else if (length(x)==6){
    x <- c(NA, x)
  }
  return(x)
}

# split on whitespace and create a new dataframe
x7 <- strsplit(x6, " ")
x8 <- lapply(x7, function(elt) extender(elt))

# create new dataframe for holdig this information
conLink2010 <- data.frame(
  reg=sapply(x8, function(elt) return(elt[1])),
  dis=sapply(x8, function(elt) return(elt[2])),
  con=sapply(x8, function(elt) return(elt[3])),
  ward=sapply(x8, function(elt) return(elt[4])),
  voters=sapply(x8, function(elt) return(elt[5])),
  male=sapply(x8, function(elt) return(elt[6])),
  female=sapply(x8, function(elt) return(elt[7]))
)

# read in filler functions and back fill
# all the values that are NA
source("C:/Users/Tomas/Documents/LEI/Afripol/TZA/code/filler.R")

conLink2010$reg <- backer(conLink2010$reg)
conLink2010$dis <- backer(conLink2010$dis)
conLink2010$con <- backer(conLink2010$con)

# put hyphenated values back to normal
conLink2010$reg <- gsub("-", " ", conLink2010$reg)
conLink2010$dis <- gsub("-", " ", conLink2010$dis)
conLink2010$con <- gsub("-", " ", conLink2010$con)
conLink2010$ward <- gsub("-", " ", conLink2010$ward)

# get rid of commas and replace with
# and make integers of variables
conLink2010$voters <- gsub(",", "", conLink2010$voters)
conLink2010$male <- gsub(",", "", conLink2010$male)
conLink2010$female <- gsub(",", "", conLink2010$female)

conLink2010$voters <- as.integer(conLink2010$voters)
conLink2010$male <- as.integer(conLink2010$male)
conLink2010$female <- as.integer(conLink2010$female)

rm(list=ls()[!ls() %in% "conLink2010"])

save(conLink2010, file=paste(getwd(), "conLink2010.RData", sep="/"))
