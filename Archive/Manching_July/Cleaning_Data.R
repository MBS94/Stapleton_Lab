
library(dplyr)
library(purrr)
# setwd("C:/Users/mbyrd/Documents/Stapleton/Stapleton_Lab/Manching_July")

# macOS Path
setwd("/Users/mbyrd/StapletonLab/Stapleton_Lab/Manching_July")

# Observation Data
data <- read.csv(file = "Manching2012PlantHT.csv")

# Markerfile SNP Data
snpData <- read.csv(file = "IBM94markerset raw data.csv")

# List of Marker Names we have
markerNames <- names(snpData)
# Forcing all entries to have lower case
markerNamesLower <- sapply(markerNames, tolower)
# Removing non Marker Names (Heading)
markerNamesRem <- markerNamesLower[-c(1:6)]

count(data$Treatment)

# Copy of the Data
data1 <- data

# Removing the entires that have Marker names that we don't have data on
# Run until data1 has 6792 observations
for (i in 1:length(data1$Line)){
  if(!(trimws(tolower(data1$Line[i])) %in% markerNamesRem)){
    data1 <- data1[-c(i), ]
  }
}

# data2 <- data1 %>% 
#   modify_at("Line", tolower) %>% 
# filter(Line %in% markerNamesRem)

write.csv(data1,file = "Test1.csv", row.names = FALSE)


# Transposting the Marker Data
snpDataT <- as.data.frame(t(snpData))

write.csv(file = "snpDataT.csv", x = snpDataT)

# Cleaning Treatment and making Quantative

levels(data$Treatment)[3] = levels(data$Treatment)[2]
levels(data$Treatment)[10] = levels(data$Treatment)[9]
levels(data$Treatment)[4] = levels(data$Treatment)[8]

levels(data$Treatment) = c("control","ln","lw,ln","lw,p",
                          "ln,p","lw,ln,p","lw","p")

#Setting up quantitative columns using treatment levels
treats = matrix(rep(0,length(data$Treatment) * 3), ncol = 3)
treats = t(sapply(1:length(data$Treatment), function(x){
  if(as.character(data$Treatment[x]) == "control"){
    treats[x,] = c(0,0,0)
  }else if(as.character(data$Treatment[x]) == "ln"){
    treats[x,] = c(0,1,0)
  }else if(as.character(data$Treatment[x]) == "lw,ln"){
    treats[x,] = c(1,1,0)
  }else if(as.character(data$Treatment[x]) == "lw,p"){
    treats[x,] = c(1,0,1)
  }else if(as.character(data$Treatment[x]) == "ln,p"){
    treats[x,] = c(0,1,1)
  }else if(as.character(data$Treatment[x]) == "lw,ln,p"){
    treats[x,] = c(1,1,1)
  }else if(as.character(data$Treatment[x]) == "lw"){
    treats[x,] = c(1,0,0)
  }else if(as.character(data$Treatment[x]) == "p"){
    treats[x,] = c(0,0,1)}
}))
treats = as.data.frame(treats)
colnames(treats) = c("Low Water", "Low Nitrogen", "Pathogen")
#Now combining the new treatment columns into the old data frame
data1 = cbind(treats$`Low Water`, treats$`Low Nitrogen`, treats$Pathogen, data$Line, data$Height_in)
head(data1)
data1 = as.data.frame(data1)
data1[,4] = sapply(data1[,4],function(x){
  x = levels(data$Line)[x]
})
head(dat1)
#give them column names
colnames(dat1) =c("Low Water", "Low Nitrogen", "Pathogen", "Line", "Height")
head(dat1)
#Write the csv
write.csv(data1,file = "C:/Users/Thomas/Documents/GitHub/Stapleton-Lab/Manching BayesNet/ManchingScrubbed.csv",
          row.names = FALSE)
