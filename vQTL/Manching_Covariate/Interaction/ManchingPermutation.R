# Loading the packages
library(qtl)
library(vqtl)
library(purrr)
library(readr)
library(dplyr)
library(tidyverse)

# Setting working directories
# Comment out whichever one is not being used.

# Stampede2 Directory
setwd("/work/04908/mcb4548/stampede2/GitHub/Stapleton_Lab/vQTL/Manching_Covariate/Interaction")

# Michael's Mac Directory
# setwd("/Users/mbyrd/Stapleton/Stapleton_Lab/vQTL/Manching_Covariate/Interaction")

# Reading in the input file as a 'cross' object

# data <- read.csv(file = "ManchingStressData_Covar.csv")

# Created a random sample
# set.seed(1234)
# subset = data[c(1,2, round(runif(300,1,6674))),]
# write.csv(subset, file = "Manching_Sample.csv")


# Full Data Set, Comment if using Sample
fr <-read.cross(file = "ManchingStressData_Covar.csv")

# Not sure what these two functions do yet.
fr <- drop.nullmarkers(fr)
#scan with variance
fr <- calc.genoprob(fr)

fr$pheno$Env <- factor(fr$pheno$Env)

intOneVar <- read_rds("intOneVar.rds")

print("read worked")

perm <- scanonevar.perm(intOneVar, n.perms = 2, n.cores = 32)

write_rds(perm, "permutation.rds", compress = "xz")

perm <- read_rds("permutation.rds")


write.csv(perm$result, file = "perm_result.csv")
write.csv(perm$perms, file = "perm_perms.csv")
