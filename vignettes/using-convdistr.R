## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
summary.DISTRIBUTION <- function(object,...) {
  knitr::kable(convdistr:::summary.DISTRIBUTION(object,...), digits = 2)
}

## ---- fig.width=7--------------------------------------------------------
library(convdistr)
library(ggplot2)

a <- new_NORMAL(1,0.5)
b <- new_POISSON(5)
c <- new_BETA(10,20)
res <- a + b * c

metadata(res) 
summary(res)
ggDISTRIBUTION(res) + ggtitle("a + b * c")

## ----echo=FALSE, results='hide'------------------------------------------
sum_res <- convdistr:::summary.DISTRIBUTION(res)
r_oval <- format(sum_res$oval,  digits = 3)
r_mean <- format(sum_res$mean_, digits = 3)
r_median <- format(sum_res$median_, digits = 3)
r_lci <- format(sum_res$lci_, digits = 2)
r_uci <- format(sum_res$uci_, digits = 3)

## ------------------------------------------------------------------------
myDistr <- new_NORMAL(0,1)
metadata(myDistr)
rfunc(myDistr, 10)
summary(myDistr)

## ---- fig.width=5, fig.cap = "Figure with R plot"------------------------
plot(myDistr)

## ---- fig.width=5, fig.cap = "Figure with ggplot2"-----------------------
ggDISTRIBUTION(myDistr)

## ---- fig.width = 5------------------------------------------------------
d1 <- new_NORMAL(1,1)
d2 <- new_UNIFORM(2,8)
d3 <- new_POISSON(5)
dsum <- new_SUM(list(d1,d2,d3))
dsum
d1 + d2 + d3
summary(dsum)
ggDISTRIBUTION(dsum)


## ---- fig.width = 7------------------------------------------------------
d1 <- new_NORMAL(1,0.5)
d2 <- new_NORMAL(5,0.5)
d3 <- new_NORMAL(10,0.5)
dmix <- new_MIXTURE(list(d1,d2,d3))
summary(dmix)
ggDISTRIBUTION(dmix)

## ---- fig.with = 7-------------------------------------------------------
d1 <- new_MULTINORMAL(c(0,1), matrix(c(1,0.3,0.3,1), ncol = 2), p_dimnames = c("A","B"))
d2 <- new_MULTINORMAL(c(3,4), matrix(c(1,0.3,0.3,1), ncol = 2), p_dimnames = c("B","C"))
summary(d1)
summary(d2)
summary(new_SUM_assoc(d1,d2))
summary(new_SUM_comb(d1,d2))

