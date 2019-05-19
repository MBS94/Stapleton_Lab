# qPCR Adjustment Model

library(tidyr)
library(pracma)
library(stringr)
library(tidyverse)

# Mac Directory
setwd("/Users/mbyrd/StapletonLab/Stapleton_Lab/splicing_ratio_qPCR_and_vQTL_analysis/2018_11")
#setwd("~/Stapleton_Lab/Stapleton_Lab/Stress_Splicing/2018_(MONTH)")

# PC Directory
#setwd()

#In the case of having two separate CSV files of calculated derivatives,
#use this code to combine, prior to the following transpositions:

deriv.1<-read.csv(file = "2018_11_1_plate_qPCR_output.csv", header=FALSE)
deriv.2<-read.csv(file = "2018_11_2_plate_qPCR_output.csv", header=FALSE)
deriv=cbind(deriv.1, deriv.2)

#In the case of having one CSV containing calculated derivatives, use this code:
#deriv=read.csv(file = "(YEAR_MONTH_PLATE_qPCR_output.csv", header=FALSE)

#Remove extra labels row, 
deriv = deriv[-1,]
#Transpose derivatives to be in equivalent format as raw plate data
deriv = as.data.frame(t(deriv), header=TRUE)
#Remove extra labels row
deriv=deriv[-1,]
#Rename columns
colnames(deriv)=c("reaction_type", "sampleID", "starting_quantity", "cpD1", "cpD2")
#Remove extra labels row
deriv=deriv[-1,]
write.csv(deriv, file="2018_11_qPCR_output_withHeaders.csv")
#Create new transposed data set
deriv2=read.csv(file="2018_11_qPCR_output_withHeaders.csv", header=TRUE) 
#Remove unneeded labeling column
deriv2=deriv2[,-1]
#Indicate if sample is NTC (negative control)
deriv2['sampleID_NTC'] = grepl('NTC', deriv2$sampleID)
#Remove NTC samples, indicator (T/F) column, and cpD2 values
ntc = which(deriv2$sampleID_NTC)
deriv2 = deriv2[-ntc,]
deriv2 = deriv2[,-c(5,6)]
# Indicate if sample is 'Plus' or 'Minus'
deriv2['sampleID_Minus'] = grepl('minus', deriv2$sampleID)
#Remove 'Minus' values (include only gblock+ values), and indicator (T/F) column
minus = which(deriv2$sampleID_Minus)
deriv2 = deriv2[-minus,]
deriv2 = deriv2[,-c(5)]
#Write CSV file 
write.csv(deriv2, file="2018_11_qPCR_output_New.csv")
#Re-read in CSV values --> this allows for-loop to work properly
deriv2=read.csv(file="2018_11_qPCR_output_New.csv", header=TRUE) 
#Remove labels column
deriv2=deriv2[,-1]


###CALIBRATED DATA FRAME###
#Create/Write data frame for Calibrated values
calib_df = deriv2 %>% filter(str_detect(sampleID, "g"))
#Sort by starting quantity
calib_df = calib_df[order(calib_df$starting_quantity),]
write.csv(calib_df, file="2018_11_Calibrated_Data_Frame.csv")
#Create new transposed data set
calib_data=read.csv(file="2018_11_Calibrated_Data_Frame.csv", header=TRUE) 
# Create empty vectors for for-loop to input cpD1 values
test1 = c()
allP = c()
startq = c()
# For loop -- iterating thru starting quantity and reaction type to return cpD1 values 
for(i in 1:length(calib_data$starting_quantity)){
  sq <- calib_data$starting_quantity[i]
  if(i %% 6 == 1){
    startq = c(startq,sq,sq,sq)
  }
  val <- toString(calib_data$reaction_type[i])
  if(strcmp(val, "test1")){
    test1 = c(test1, calib_data$cpD1[i])
  }
  if(strcmp(val, "all_products")){
    allP = c(allP, calib_data$cpD1[i])
  }
}
#Bind test1 and allProd cpD1 values by starting quantity
calib_data = cbind(startq, test1, allP)
#Format starting quantity values as decimals, not scientific notation
calib_data[,1]=format(calib_data[,1], scientific=FALSE)
write.csv(calib_data, file="2018_11_Calibrated_Data_Frame.csv")
###COMPLETED CALIBRATED DATA FRAME###


###ADJUSTMENT MODEL### 
data=read.csv(file="2018_11_Calibrated_Data_Frame.csv", header=TRUE) 

adj_val = c()
allP = c()
startq = c()
ratio = data$allP/data$test1

# Itterating through each set of (3) observations performing U-Stats on each set of inputs
for (i in 1:(nrow(data)/3)){
  t_x <- c(data$allP[3*i - 2], data$allP[3*i - 1], data$allP[3*i])
  t_y <- c(data$test1[3*i - 2], data$test1[3*i - 1], data$test1[3*i])
  adj <- mean(outer(t_x, t_y, "-"))
  adj_val <- c(adj_val, adj, adj, adj)
}

adjusted_test1 <- test1 + adj_val

# Creating the adjustment model lm(y-axis~x-axis)
# Changed adj_val^2 to adj_val to try to make the model better
adj_model <- lm(adj_val~ratio) #Adjusted/avg slopes model --> to get JC VQTL vals 
summary(adj_model)

par(mfrow = c(2,2))
plot(adj_model)

# Using the adjustment model on the expiremental data
new = data.frame(ratio = exp_data$all_productsPrimers_Cp1/exp_data$test1_Cp1)
predict(adj_model, new , interval = "confidence")


# This Data doesnt have 50/50

# # 50/50
# 
# test1_50_50 <- data$test1Cp150_50
# all_p_50_50 <- data$allproductsCp1_50_50
# 
# # The ratio of the cp values
# ratio_50 <- all_p_50_50/test1_50_50
# # Appending to the Calibration data
# cbind(data, ratio_50)
# 
# adj_val_50_50 = vector()
# 
# # Itterating through each set of (3) observations performing U-Stats on each set of inputs
# for (i in 1:(nrow(data)/3)){
#   t_x <- c(data$allproductsCp1_50_50[3*i - 2], data$allproductsCp1_50_50[3*i - 1], data$allproductsCp1_50_50[3*i])
#   t_y <- c(data$test1Cp150_50[3*i - 2], data$test1Cp150_50[3*i - 1], data$test1Cp150_50[3*i])
#   adj <- mean(outer(t_x, t_y, "-"))
#   adj_val_50_50 <- c(adj_val_50_50, adj, adj, adj)
# }
# 
# # Creating the adjustment model lm(y-axis~x-axis)
# adj_model_50 <- lm(adj_val_50_50^2~ratio_50) #50:50 shift - another type of calibration method   
# #Run adjustment model on experimental data to get 
# summary(adj_model_50)
# plot(adj_model_50)