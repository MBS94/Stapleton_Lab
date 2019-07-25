# Loading the packages
library(qtl)
library(vqtl)
library(purrr)
library(readr)
library(dplyr)
library(tidyverse)
library(gdata)

# Michael's Mac Directory
setwd("/Users/mbyrd/Stapleton/Stapleton_Lab/vQTL/Manching_Covariate/Interaction/Simulation")
data <- read.csv(file = "ManchingStressData_Covar.csv")
sub_data <- data[3:6674,]

temp = sub_data[,11:3245]
temp[] <- lapply(sub_data[,11:3245], as.character)
unique(as.character(unlist(temp)))
temp[temp == "?"] = "-" 


p <- boxplot(sub_data$Height~droplevels(sub_data$umc2087, exclude = '-'))


averages <- NULL

for (i in 11:3245){
  a <- tapply(sub_data$Height,sub_data[,i], mean)
  # print(a[(length(a)-1):length(a)])
  t1 <- cbind(i, abs(a[(length(a)-1)] - a[length(a)]))
  averages = rbind(averages, t1)
}

averages_sorted <- averages[order(averages[,2], decreasing = TRUE),]

top10_index <- averages_sorted[1:10,1]

for(item in top10_index){
  print(tapply(sub_data$Height,sub_data[,item], mean))
}
# tapply(sub_data$Height,sub_data[,top10_index], mean)

colnames(sub_data[,top10_index])


# 1. Open jpeg file
jpeg("IDP574_box.jpg", width = 1024, height = 1024)
# 2. Create the plot
boxplot(sub_data$Height~droplevels(sub_data$IDP574, exclude = '-'))
# 3. Close the file
dev.off()

# ------Code for later -----
# fr <-read.cross(file = "ManchingStressData_Covar.csv")
# 
# # Not sure what these two functions do yet.
# fr <- drop.nullmarkers(fr)
# #scan with variance
# fr <- calc.genoprob(fr)
# fr$pheno$Env <- factor(fr$pheno$Env)