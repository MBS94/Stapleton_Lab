#install.packages("vqtl")
#install.packages("qtl")
library(qtl)
library(vqtl)
setwd("/work/04908/mcb4548/stampede2/GitHub/Stapleton_Lab/vQTL/Manching_Covariate/Interaction")
# Mac Path
#setwd("/Users/mbyrd/Stapleton/Stapleton_Lab/vQTL/Manching_Covariate/Interaction")
fr <-read.cross(file = "ManchingStressData_Covar.csv")
fr <- drop.nullmarkers(fr)
#scan with variance
fr <- calc.genoprob(fr)

outv <- scanonevar(cross = fr,
                   mean.formula = Height ~ Env + mean.QTL.add + mean.QTL.dom,
                   var.formula = ~ Env + var.QTL.add + var.QTL.dom,
                   return.covar.effects = TRUE)

write_rds(outv, "2019_06_outv.rds", compress = "xz")