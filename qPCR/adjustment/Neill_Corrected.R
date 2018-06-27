setwd("/Users/mbyrd/StapletonLab/Stapleton_Lab/qPCR/adjustment")

data <- read.csv("corrected17June_Neill Thesis RNA samples.csv")

str(data)

plot(c(1:46),data[,8])
