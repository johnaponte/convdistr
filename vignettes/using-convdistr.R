## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- fig.width=7--------------------------------------------------------
library(convdistr)
library(ggplot2)

a <- new_NORMAL(1,0.5)
b <- new_POISSON(5)
c <- new_BETA(10,20)
res <- a + b * c

metadata(res)
t(summary(res))
ggDISTRIBUTION(res) + ggtitle("a + b * c")

## ----echo=FALSE, results='hide'------------------------------------------
sum_res <- summary(res)
r_oval <- format(sum_res$oval,  digits = 3)
r_mean <- format(sum_res$mean_, digits = 3)
r_median <- format(sum_res$median_, digits = 3)
r_lci <- format(sum_res$lci_, digits = 2)
r_uci <- format(sum_res$uci_, digits = 3)

## ------------------------------------------------------------------------
myDistr <- new_NORMAL(0,1)

metadata(myDistr)

t(summary(myDistr))

rfunc(myDistr, 10)


## ---- fig.width=5, fig.cap = "Figure with R plot"------------------------
plot(myDistr)

## ---- fig.width=5, fig.cap = "Figure with ggplot2"-----------------------
ggDISTRIBUTION(myDistr)

## ---- fig.width = 5------------------------------------------------------
d1 <- new_NORMAL(1,1)
d2 <- new_UNIFORM(2,8)
d3 <- new_POISSON(5)
dsum <- new_SUM(list(d1,d2,d3))
t(summary(dsum))
t(summary(d1 + d2 + d3))
ggDISTRIBUTION(dsum)


## ---- fig.width = 7------------------------------------------------------
d1 <- new_NORMAL(1,0.5)
d2 <- new_NORMAL(5,0.5)
d3 <- new_NORMAL(10,0.5)
dmix <- new_MIXTURE(list(d1,d2,d3))
t(summary(dmix))
ggDISTRIBUTION(dmix)

