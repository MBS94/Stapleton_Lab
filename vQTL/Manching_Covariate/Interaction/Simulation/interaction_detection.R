# Loading the packages
library(qtl)
library(vqtl)
library(tidyverse)
library(gdata)
library(pracma)
library(plyr)

# Michael's Mac Directory
setwd("/Users/mbyrd/Stapleton/Stapleton_Lab/vQTL/Manching_Covariate/Interaction/Simulation")
data <- read.csv(file = "ManchingStressData_Covar.csv")
sub_data <- data[3:6674,]
change_ind <- c()

for(ind in 11:3245){
  A_count = cbind(0,0,0,0,0,0,0,0)
  A_total = cbind(0,0,0,0,0,0,0,0)
  B_count = cbind(0,0,0,0,0,0,0,0)
  B_total = cbind(0,0,0,0,0,0,0,0)
  for(i in 1:nrow(sub_data)){
    j = sub_data[i,10]
    if(strcmp(as.character(sub_data[i,ind]), "A")){
      A_count[j] = A_count[j] + 1
      A_total[j] = A_total[j] + sub_data[i,1]
    }
    if(strcmp(as.character(sub_data[i,ind]), "B")){
      B_count[j] = B_count[j] + 1
      B_total[j] = B_total[j] + sub_data[i,1]
    }
  }
  A_average = as.data.frame(t(A_total/A_count))
  B_average = as.data.frame(t(B_total/B_count))
  diff <- A_average - B_average
  pos_flag = FALSE
  neg_flag = FALSE
  for(j in 1:8){
    if(diff[j,1] < 0){
      neg_flag = TRUE
    }
    if(diff[j,1] > 0){
      pos_flag = TRUE
    }
  }
  if(pos_flag & neg_flag){
    print("CHANGE")
    change_ind <- c(change_ind, ind)
  }
}
change_ind <- as.data.frame(change_ind)
write.csv(change_ind, file = "interaction_index.csv")


chrome_count <- cbind(0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
int_index <- read.csv("interaction_index.csv")

for(i in 1:nrow(int_index)){
  j <- int_index[i,1]
  chrome_num <- as.numeric(as.character(data[1, j]))
  chrome_count[chrome_num] = chrome_count[chrome_num] + 1
}

# A_average$Env = 1:8
# B_average$Env = 1:8
# 
# colnames(A_average) = c("Average","Env")
# colnames(B_average) = c("Average","Env")
# A_average
# B_average