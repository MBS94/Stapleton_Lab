# Read in Calibration Data
library(pracma)
setwd("/Users/mbyrd/StapletonLab/Stapleton_Lab/splicing_ratio_qPCR_and_vQTL_analysis")
data <- read.csv(file = "Calibrated_Data_Frame_with_Derivatives.csv")
# Format starting quantity as numeric, not in scientific notation
options(scipen=5)
# Reorder columns with starting quantity first, remove unneeded ordering column (how can I better word this...)
data <- data[c(4,2,3,5,6)]

test1 <- vector()
allp <- vector()
datalen <- length(data$starting_quantity)
for (i in len){
  if(strcmp("test1", val)){
    print(val)
  }
  
}
