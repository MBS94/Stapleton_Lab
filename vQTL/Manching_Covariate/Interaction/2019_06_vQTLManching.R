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
#setwd("/Users/mbyrd/Stapleton/Stapleton_Lab/vQTL/Manching_Covariate/Interaction")

# Reading in the input file as a 'cross' object
fr <-read.cross(file = "ManchingStressData_Covar.csv")

# Not sure what these two functions do yet.
fr <- drop.nullmarkers(fr)
#scan with variance
fr <- calc.genoprob(fr)

# Additive scanonevar function
addOneVar <- scanonevar(cross = fr,
                   mean.formula = Height ~ Env + mean.QTL.add + mean.QTL.dom,
                   var.formula = ~ Env + var.QTL.add + var.QTL.dom,
                   return.covar.effects = TRUE)

# Writing the result of the additive scanonevar for later use
write_rds(outv, "addOneVar.rds", compress = "xz")


# Interactive scanonevar function
intOneVar <- scanonevar(cross = sample,
                   mean.formula = Height ~ Env * (mean.QTL.add + mean.QTL.dom),
                   var.formula = ~ Env * (var.QTL.add + var.QTL.dom),
                   return.covar.effects = TRUE)

# Writing the result of the interactive scanonevar for later use
write_rds(outv, "intOneVar.rds", compress = "xz")


# Writing out the results of the two 
write.csv(addOneVar$result, file = "Manching_additive_model.csv")
write.csv(intOneVar$result, file = "Manching_interactive_model.csv")
