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

# Creating a table of all possible combinations of 1s and 0s for 10 genes

for (i1 in 0:1){
  for (i2 in 0:1){
    for (i3 in 0:1){
      for (i4 in 0:1){
        for (i5 in 0:1){
          for (i6 in 0:1){
            for (i7 in 0:1){
              for (i8 in 0:1){
                for (i9 in 0:1){
                  for (i10 in 0:1){
                    t <- cbind( (i1), (i2), (i3), (i4), (i5), (i6), (i7), (i8), (i9), (i10))
                    simulated <- rbind(simulated, t)
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

# Create a table of 10 random genes
rand_genes = NULL
for (i in 1:10){
  random_gene <- round(runif(1024))
  rand_genes <- cbind(rand_genes, random_gene)
}

# Concatenate the simulated and random genes
ttable <- cbind(simulated, rand_genes)

simulated = NULL



# Create all possible of environment stress with all combinations of simulated genes
# Should total to be 8 * 2^G where G is the number of genes
# As of 2019_08_01 it is 8 * 2^10 = 8192
for (i in 0:1){
  for (j in 0:1){
    for (k in 0:1){
      env = NULL
      t = cbind(i, j, k)
      for (l in 1:1024){
        env = rbind(env, t)
      }
      sim_step <- cbind(env, ttable)
      simulated <- rbind(simulated, sim_step)
    }
  }
}
# Create colnames for readability
colnames(simulated) <- cbind("LW", "LN", "P", "G1", "G2", "G3", "G4", "G5", "G6", "G7", "G8", "G9", "G10", "R1", "R2", "R3", "R4", "R5", "R6", "R7", "R8", "R9", "R10")
# colnames(rand_genes) <- cbind("R1", "R2", "R3", "R4", "R5", "R6", "R7", "R8", "R9", "R10")


simulated = data.frame(simulated)

# Creating a column for simulated height data
height_data <- NULL

# Coefficients for the genes and environment
intercept <- 70
lw_c <- -3.4
ln_c <- -1.7
p_c  <- -2.6
g1_c <- 2.3
g2_c <- 1.9
g3_c <- 3.5
g4_c <- 60
g5_c <- 2.5
g6_c <- 1.5
g7_c <- 0.7
g8_c <- 2.8
g9_c <- 2.1
g10_c <- 3.2


# Calculating the simulated height
for (i in 1:nrow(simulated)){
  lw <- simulated[i,1]
  ln <- simulated[i,2]
  p  <- simulated[i,3]
  G1 <- simulated[i,4]
  G2 <- simulated[i,5]
  G3 <- simulated[i,6]
  G4 <- simulated[i,7]
  G5 <- simulated[i,8]
  G6 <- simulated[i,9]
  G7 <- simulated[i,10]
  G8 <- simulated[i,11]
  G9 <- simulated[i,12]
  G10 <- simulated[i,13]
  Height <- intercept + lw_c * lw + ln_c * ln + p * p_c + 
    g1_c * G1 + g2_c * G2 + g3_c * G3 + g4_c * G4 + 
    g5_c * G5 + g6_c * G6 + g7_c * G7 + g8_c * G8 + 
    g9_c * G9 + g10_c * G10 + (rnorm(1, mean = 0, sd = .7))
  # print(Height)
  height_data <- rbind(height_data, Height)
}

# Bind the height with environment and genes
simulated_with_height <- cbind(height_data, simulated)

# Changes 0s and 1s to As and Bs
simulated_with_height$G1[simulated_with_height$G1 == 1] <- "A"
simulated_with_height$G2[simulated_with_height$G2 == 1] <- "A"
simulated_with_height$G3[simulated_with_height$G3 == 1] <- "A"
simulated_with_height$G4[simulated_with_height$G4 == 1] <- "A"
simulated_with_height$G5[simulated_with_height$G5 == 1] <- "A"
simulated_with_height$G6[simulated_with_height$G6 == 1] <- "A"
simulated_with_height$G7[simulated_with_height$G7 == 1] <- "A"
simulated_with_height$G8[simulated_with_height$G8 == 1] <- "A"
simulated_with_height$G9[simulated_with_height$G9 == 1] <- "A"
simulated_with_height$G10[simulated_with_height$G10 == 1] <- "A"
simulated_with_height$G1[simulated_with_height$G1 == 0] <- "B"
simulated_with_height$G2[simulated_with_height$G2 == 0] <- "B"
simulated_with_height$G3[simulated_with_height$G3 == 0] <- "B"
simulated_with_height$G4[simulated_with_height$G4 == 0] <- "B"
simulated_with_height$G5[simulated_with_height$G5 == 0] <- "B"
simulated_with_height$G6[simulated_with_height$G6 == 0] <- "B"
simulated_with_height$G7[simulated_with_height$G7 == 0] <- "B"
simulated_with_height$G8[simulated_with_height$G8 == 0] <- "B"
simulated_with_height$G9[simulated_with_height$G9 == 0] <- "B"
simulated_with_height$G10[simulated_with_height$G10 == 0] <- "B"
simulated_with_height$R1[simulated_with_height$R1 == 1] <- "A"
simulated_with_height$R2[simulated_with_height$R2 == 1] <- "A"
simulated_with_height$R3[simulated_with_height$R3 == 1] <- "A"
simulated_with_height$R4[simulated_with_height$R4 == 1] <- "A"
simulated_with_height$R5[simulated_with_height$R5 == 1] <- "A"
simulated_with_height$R6[simulated_with_height$R6 == 1] <- "A"
simulated_with_height$R7[simulated_with_height$R7 == 1] <- "A"
simulated_with_height$R8[simulated_with_height$R8 == 1] <- "A"
simulated_with_height$R9[simulated_with_height$R9 == 1] <- "A"
simulated_with_height$R10[simulated_with_height$R10 == 1] <- "A"
simulated_with_height$R1[simulated_with_height$R1 == 0] <- "B"
simulated_with_height$R2[simulated_with_height$R2 == 0] <- "B"
simulated_with_height$R3[simulated_with_height$R3 == 0] <- "B"
simulated_with_height$R4[simulated_with_height$R4 == 0] <- "B"
simulated_with_height$R5[simulated_with_height$R5 == 0] <- "B"
simulated_with_height$R6[simulated_with_height$R6 == 0] <- "B"
simulated_with_height$R7[simulated_with_height$R7 == 0] <- "B"
simulated_with_height$R8[simulated_with_height$R8 == 0] <- "B"
simulated_with_height$R9[simulated_with_height$R9 == 0] <- "B"
simulated_with_height$R10[simulated_with_height$R10 == 0] <- "B"


write.csv(simulated_with_height, file = "simulated_data_w_random.csv")



sim_cross <- read.cross(file = "simulated_data_w_random_FRAME.csv")
sim_cross <- drop.nullmarkers(sim_cross)
sim_cross <- calc.genoprob(sim_cross)
sim_cross$pheno$LW <- factor(sim_cross$pheno$LW)
sim_cross$pheno$LN <- factor(sim_cross$pheno$LN)
sim_cross$pheno$P <- factor(sim_cross$pheno$P)

sim_sov_add <- scanonevar(cross = sim_cross,
                          mean.formula = height_data ~ LW + LN + P + mean.QTL.add,
                          var.formula = ~ LW + LN + P + var.QTL.add + var.QTL.dom,
                          return.covar.effects = TRUE)
write.csv(sim_sov_add$result, file = "sim_sov_results_add.csv")


randGenes = subset(sim_sov_add$result$mQTL.lod, grepl("R",sim_sov_add$result$loc.name))

simGenes = subset(sim_sov_add$result$mQTL.lod, grepl("G",sim_sov_add$result$loc.name))

Loci = c(1,1,2,2,2,3,3,4,4,4)
randGenes = cbind.data.frame(randGenes,Loci)
simGenes = cbind.data.frame(simGenes,Loci)
colnames(randGenes) = c("LOD","Loci")
colnames(simGenes) = c("LOD","Loci")

ggplot()+geom_point(data=randGenes,aes(x=Loci,y=LOD,color = "Random"), position = position_jitter()) +
  geom_point(data=simGenes,aes(x=Loci,y=LOD,color = "Simulated"), position = position_jitter()) +
  labs(title = "Simulated vs Ramdom") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5))
