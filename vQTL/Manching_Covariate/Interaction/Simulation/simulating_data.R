# Loading the packages
library(qtl)
library(vqtl)
library(purrr)
library(readr)
library(dplyr)
library(tidyverse)
library(gdata)

setwd("/Users/mbyrd/Stapleton/Stapleton_Lab/vQTL/Manching_Covariate/Interaction/Simulation")

simulated = NULL

for (i in 0:1){
  for (j in 0:1){
    t <- cbind( (i), (j) )
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

# write.csv(simulated, file = "simulated_data.csv")


sim_cross <- read.cross(file = "simulated_cross.csv")
sim_cross <- drop.nullmarkers(sim_cross)
sim_cross <- calc.genoprob(sim_cross)
sim_cross$pheno$Env <- factor(sim_cross$pheno$Env)

sim_sov_add <- scanonevar(cross = sim_cross,
                   mean.formula = Height ~ Env + mean.QTL.add + mean.QTL.dom,
                   var.formula = ~ Env + var.QTL.add + var.QTL.dom,
                   return.covar.effects = FALSE)
write.csv(sim_sov_add$result, file = "sim_sov_results_add.csv")
