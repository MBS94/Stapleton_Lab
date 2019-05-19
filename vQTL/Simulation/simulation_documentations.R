library(qtl)
library(vqtl)
#> 
#> Attaching package: 'vqtl'
#> The following object is masked from 'package:qtl':
#> 
#>     scanonevar

set.seed(27599)

test.cross <- qtl::sim.cross(map = qtl::sim.map(len = rep(20, 5), eq.spacing = FALSE))

test.cross[['pheno']][['sex']] <- sample(x = c(0, 1),
                                         size = qtl::nind(test.cross),
                                         replace = TRUE)
test.cross[['pheno']][['sire']] <- factor(x = sample(x = 1:5,
                                                     size = qtl::nind(test.cross),
                                                     replace = TRUE))
test.cross <- qtl::calc.genoprob(cross = test.cross, step = 2)

sov <- scanonevar(cross = test.cross,
                  mean.formula = phenotype ~ sex + D1M2 + mean.QTL.add + mean.QTL.dom,
                  var.formula = ~ sire + D2M3 + var.QTL.add + var.QTL.dom)