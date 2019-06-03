#install.packages("vqtl")
#install.packages("qtl")
library(qtl)
library(vqtl)
library(purrr)
library(readr)
library(dplyr)
library(tidyverse)
setwd("/work/04908/mcb4548/stampede2/GitHub/Stapleton_Lab/vQTL/Manching_Covariate/Interaction")
# Mac Path
#setwd("/Users/mbyrd/Stapleton/Stapleton_Lab/vQTL/Manching_Covariate/Interaction")
fr <-read.cross(file = "ManchingStressData_Covar.csv")
fr <- drop.nullmarkers(fr)
#scan with variance
fr <- calc.genoprob(fr)

addOneVar <- scanonevar(cross = fr,
                   mean.formula = Height ~ Env + mean.QTL.add + mean.QTL.dom,
                   var.formula = ~ Env + var.QTL.add + var.QTL.dom,
                   return.covar.effects = TRUE)

write_rds(outv, "addOneVar.rds", compress = "xz")

intOneVar <- scanonevar(cross = sample,
                   mean.formula = Height ~ Env * (mean.QTL.add + mean.QTL.dom),
                   var.formula = ~ Env * (var.QTL.add + var.QTL.dom),
                   return.covar.effects = TRUE)

write_rds(outv, "intOneVar.rds", compress = "xz")

write.csv(outv$result, file = "Manching_additive_model.csv")
write.csv(outv$result, file = "Manching_interactive_model.csv")
