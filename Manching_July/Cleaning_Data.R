
library(plyr)

setwd("C:/Users/mbyrd/Documents/Stapleton/Stapleton_Lab/Manching_July")

data <- read.csv(file = "Manching2012PlantHT.csv")

data$Treatment

count(data$Treatment)
count(data$Line)
