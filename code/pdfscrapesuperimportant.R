# -------------------------------------
# read in ward and constituency link
# table from the NBS 2015

setwd("C:/Users/Tomas/Documents/LEI/pol/data")


# use regex to order the information the way
# that you want
x <- readLines("MAJIMBO NA KATA 2015 FINAL.txt")

x2 <- gsub("(?<=[a-zA-Z])(\\s|\\s{2})(?=[a-zA-Z])", "-", x, perl=TRUE)
x3 <- gsub("(?<=\\d)(\\s{0,})(?!\\w)", "", x2, perl=TRUE)
x4 <- gsub("(\\s)(?!\\w)", "", x3, perl=TRUE)
x5 <- gsub("(?<!\\w)(\\s)", "", x4, perl = TRUE)

# select on length of resulting strings
list <- lapply(x5, function(elt) strsplit(elt, " "))
s <- sapply(list, function(elt) length(elt[[1]]))

bad <- s %in% 0 | s %in% 1 
x6 <- x5[!bad]

# function for filling gaps with NA values
# need to change this for new data
extender <- function(x){
  if(length(x) == 3){
    x <- c(NA, NA, NA, x)
  } else if (length(x)==4){
    x <- c(NA, NA, x)
  } else if (length(x)==5){
    x <- c(NA, x)
  }
  return(x)
}

# split on whitespace and create a new dataframe
x7 <- strsplit(x6, " ")
x8 <- lapply(x7, function(elt) extender(elt))

# create new dataframe for holdig this information
df <- data.frame(
  reg=sapply(x8, function(elt) return(elt[1])),
  dis=sapply(x8, function(elt) return(elt[2])),
  con=sapply(x8, function(elt) return(elt[3])),
  N1=sapply(x8, function(elt) return(elt[4])),
  ward=sapply(x8, function(elt) return(elt[5])),
  N2=sapply(x8, function(elt) return(elt[6]))
)

# read in filler functions and back fill
# all the values that are NA
source("C:/Users/Tomas/Documents/LEI/Afripol/TZA/code/filler.R")

df$reg <- backer(df$reg)
df$dis <- backer(df$dis)
df$con <- backer(df$con)

# put hyphenated values back to normal
df$reg <- gsub("-", " ", df$reg)
df$dis <- gsub("-", " ", df$dis)
df$con <- gsub("-", " ", df$con)
df$ward <- gsub("-", " ", df$ward)

# get rid of commas and make integers of variables
df$N2 <- gsub(",", "", df$N2)
df$N2 <- as.integer(df$N2)

rm(list=ls()[!ls() %in% "df"])
