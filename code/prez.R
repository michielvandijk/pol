setwd("c:/users/tomas/documents/lei/pol/data")

colName <- c("RegionID", "Region", "DistrictID",
             "District", "ConstID", "Const", "Candidates",
             "Party", "Votes", "Spoiltvotes", "Percentage")
# 1.
prez1 <- read.csv("prez1_2010.csv")
names(prez1) <- colName
prez1 <- prez1[!prez1$RegionID %in% "RegionID", ]
bad <- as.character(as.character(prez1$RegionID)) %in% ""
prez1 <- prez1[!bad, ]

# 2.
prez2 <- read.csv("prez2_2010.csv")
names(prez2) <- colName
prez2 <- prez2[!prez2$RegionID %in% "RegionID", ]
bad <- as.character(as.character(prez2$RegionID)) %in% ""
prez2 <- prez2[!bad, ]

# 3.
prez3 <- read.csv("prez3_2010.csv")
names(prez3) <- colName
prez3 <- prez3[!prez3$RegionID %in% "RegionID", ]
bad <- as.character(as.character(prez3$RegionID)) %in% ""
prez3 <- prez3[!bad, ]

# 4.
prez4 <- read.csv("prez4_2010.csv")
names(prez4) <- colName
prez4 <- prez4[!prez4$RegionID %in% "RegionID", ]
bad <- as.character(as.character(prez4$RegionID)) %in% ""
prez4 <- prez4[!bad, ]

# 5.
prez5 <- read.csv("prez5_2010.csv")
names(prez5) <- colName
prez5 <- prez5[!prez5$RegionID %in% "RegionID", ]
bad <- as.character(as.character(prez5$RegionID)) %in% ""
prez5 <- prez5[!bad, ]

# 6.
prez6 <- read.csv("prez6_2010.csv")
names(prez6) <- colName
prez6 <- prez6[!prez6$RegionID %in% "RegionID", ]
bad <- as.character(as.character(prez6$RegionID)) %in% ""
prez6 <- prez6[!bad, ]

# 7.
prez7 <- read.csv("prez7_2010.csv")
names(prez7) <- colName
prez7 <- prez7[!prez7$RegionID %in% "RegionID", ]
bad <- as.character(as.character(prez7$RegionID)) %in% ""
prez7 <- prez7[!bad, ]

# 8.
prez8 <- read.csv("prez8_2010.csv")
names(prez8) <- colName
prez8 <- prez8[!prez8$RegionID %in% "RegionID", ]
bad <- as.character(as.character(prez8$RegionID)) %in% ""
prez8 <- prez8[!bad, ]

# 9.
prez9 <- read.csv("prez9_2010.csv")
names(prez9) <- colName
prez9 <- prez9[!prez9$RegionID %in% "RegionID", ]
bad <- as.character(as.character(prez9$RegionID)) %in% ""
prez9 <- prez9[!bad, ]

# 10.
prez10 <- read.csv("prez10_2010.csv")
names(prez10) <- colName
prez10 <- prez10[!prez10$RegionID %in% "RegionID", ]
bad <- as.character(as.character(prez10$RegionID)) %in% ""
prez10 <- prez10[!bad, ]

