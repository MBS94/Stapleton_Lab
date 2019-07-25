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

significant_index <- c(123,490, 2359, 2860, 2315, 2354, 2358, 1436, 2355, 2353) 

for(k in 1:length(significant_index)){
  ind <- significant_index[k]
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
  
  A_average$Env = 1:8
  B_average$Env = 1:8
  
  colnames(A_average) = c("Average","Env")
  colnames(B_average) = c("Average","Env")
  
  jpeg(paste0(colnames(sub_data[ind]),".jpeg"), width = 600, height = 600)
  p <- ggplot() + geom_line(data = B_average, aes(x = Env, y = Average),color="blue") + 
    geom_line(data = A_average, aes(x = Env, y = Average),color="red") +
    #guides(fill = guide_legend(title = "Gene Letters")) +
    scale_x_discrete(limits = c("1","2","3","4","5","6","7","8")) +
    #scale_fill_discrete(name = "Gene\nLetters", labels = c("A","B")) +
    labs(title = paste0(colnames(sub_data[ind])), x = "Environmental Stressors", y = "Average Height") +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5))
  ggsave(p,file = paste0(colnames(sub_data[ind]),".png"))
}  
dev.off()
  
p <- ggplot(sub_data, aes(x = as.factor(Env), y = Height)) + geom_boxplot()

subset(sub_data, sub_data[,123] != "-")

temp <- data.frame(sub_data[,c(1,10,123)])
temp <- subset(temp, IDP3914 != "-")

ggplot(temp, aes(x = as.factor(Env), y = Height)) + geom_boxplot(aes(fill = temp[,3]))


geneA = c()
geneB = c()
ind = 11
for(i in 1:nrow(sub_data)){
  if(strcmp(as.character(sub_data[i,ind]), "A")){
    t <- cbind(sub_data[i,1], sub_data[i,10])
    geneA <- rbind(geneA, t)
  }
  if(strcmp(as.character(sub_data[i,ind]), "B")){
    t <- cbind(sub_data[i,1], sub_data[i,10])
    geneB <- rbind(geneB, t)
  }
}

geneA <- as.data.frame(geneA)
geneB <- as.data.frame(geneB)

colnames(geneA) <- cbind("Height", "Env")
colnames(geneB) <- cbind("Height", "Env")
p <- ggplot(geneA, aes(x = as.factor(Env), y = Height)) +
     geom_boxplot() 

p

# print(A_total)

  

# A_devia = cbind(0,0,0,0,0,0,0,0)
# B_devia = cbind(0,0,0,0,0,0,0,0)

# for(i in 1:nrow(sub_data)){
#   j = sub_data[i,10]
#   if(strcmp(as.character(sub_data[i,ind]), "A")){
#     A_devia[j] = A_devia[j] + (sub_data[i,1] - A_average[j,1])^2
#   }
#   if(strcmp(as.character(sub_data[i,ind]), "B")){
#     B_devia[j] = B_devia[j] + (sub_data[i,1] - B_average[j,1])^2
#   }
# }

# A_devia <- (A_devia/(A_count-1))^(1/2)
# B_devia <- (B_devia/(B_count-1))^(1/2)

# 1. Open jpeg file


# 2. Create the plot

# 3. Close the file

# tapply(sub_data$Height, as.factor(sub_data$Env), mean)

                                                                   