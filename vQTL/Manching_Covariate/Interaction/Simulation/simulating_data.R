# Loading the packages
library(qtl)
library(vqtl)
library(purrr)
library(readr)
library(dplyr)
library(tidyverse)
library(gdata)

simulated = NULL

for (i in 1:2){
  for (j in 1:2){
    t <- cbind( (i-1), (j-1) )
    simulated <- rbind(simulated, t)
  }
}

ttable <- simulated



simulated = NULL

for (i in 1:8){
  env = NULL
  for (j in 1:4){
    env <- rbind(env, i)
  }
  temp <- cbind(env, ttable)
  simulated <- rbind(simulated, temp)
}

simulated = data.frame(simulated)

height_data <- NULL

intercept <- 70
env_coef <- -2.2
g1_coef <- 2
g2_coef <- 3

for (i in 1:nrow(simulated)){
  ENV <- simulated[i,1]
  G1 <- simulated[i,2]
  G2 <- simulated[i,3]
  Height <- intercept + env_coef * ENV + g1_coef * G1 + g2_coef * G2 + (rnorm(1, mean = 0, sd = .7))
  height_data <- rbind(height_data, Height)
}

simulated <- cbind(height_data, simulated)

write.csv()

