## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ------------------------------------------------------------------------
library(convdistr)
new_UNIFORM

## ------------------------------------------------------------------------

#' Sample size for proportions, with uncertainty
#' 
#' Create an new DISTRIBUTION object that produce
#' random drawns of the estimated sample size for
#' two proportions
#' @param p0 a DISTRIBUTION object that drawns for proportions in control group
#' @param logrr a DISTRIBUTION object that drawns log(RR) of the intervention
#' @param alpha significant value
#' @param beta  1-power
new_SAMPLE_SIZE <- function(p0,logrr, alpha= 0.05, beta=0.2){
  #checkings
  stopifnot(inherits(p0,"DISTRIBUTION"))
  stopifnot(inherits(logrr,"DISTRIBUTION"))
  stopifnot(0 < alpha & alpha < 1)
  stopifnot(0 < beta & beta < 1)

 # function of alpha and beta
  f_alpha_beta <- (qnorm(alpha/2,lower.tail = F) + qnorm(beta, lower.tail = F)) ^ 2 
  
  # The expected value of the distribution with default name for the dimension
  # based on the oval value of the individual distributions  
  v0 <- p0$oval
  v1 <- p0$oval*exp(logrr$oval)
  
  # expected value of the distribution
  .oval <- f_alpha_beta * (v0 * (1 - v0) + v1 * (1 - v1)) / (v0 - v1) ^ 2
  names(.oval) <- "rvar"
    
  #random function within a restricted environment where only
  #the specified variables can be accesed within the function
  .rfunc <- restrict_environment(
     function(n) {
       d_p0 = rfunc_p0(n)
       d_p1 = d_p0 * exp(rfunc_logrr(n))
       fab * (d_p0 * (1 - d_p0) + d_p1 * (1 - d_p1)) / (d_p0 - d_p1) ^ 2
     },
     rfunc_p0 = p0$rfunc,
     rfunc_logrr = logrr$rfunc,
     fab = f_alpha_beta
  )
  # Create the object with 4 slots
  structure(
    list(
      distribution = "SAMPLE_SIZE",
      seed = sample(1:2 ^ 15, 1),
      oval = .oval,
      rfunc = .rfunc
    ), 
    class = c("SAMPLE_SIZE","DISTRIBUTION")
  )
  
}

## ------------------------------------------------------------------------
d_p0 = new_BETA_lci(0.35,0.30,0.40)

## ------------------------------------------------------------------------
rr = log(1 - 50/100)
sd = (log((1 - 8 / 100)) - log((1 - 73 / 100))) / 4
d_logrr = new_NORMAL(rr,sd)

## ---- results='asis', echo = F-------------------------------------------
knitr::kable(rbind(summary(d_p0),summary(d_logrr)), digits = 2)

## ------------------------------------------------------------------------
d_sample <- new_SAMPLE_SIZE(d_p0, d_logrr)

## ----echo=FALSE, results='asis'------------------------------------------
knitr::kable(summary(d_sample), digits = 0)

## ----fig.width=7, fig.height=5, echo = F, warning=FALSE, message=FALSE----
library(ggplot2)
ggDISTRIBUTION(d_sample) + scale_x_log10(breaks = c(40,80,160,320,640,1280), limits = c(-Inf, 1500))

## ------------------------------------------------------------------------
rdrawn <- rfunc(d_sample, 10000)
f_ecdf <- ecdf(rdrawn)
n_80 = trunc(uniroot(function(x){f_ecdf(x) - 0.8}, interval = c(10,10000))$root)

## ----fig.width=7, fig.height=5, echo = F, warning=FALSE, message=FALSE----
df <- data.frame(n = 20:1280, y = f_ecdf(20:1280))
ggplot(df, aes(x = n , y = y)) +
  geom_line() +
  scale_x_log10("n", breaks = c(40,80,160,320,640,1280)) +
  scale_y_continuous("Empirical cumulative distribution") +
  geom_segment(aes(x = 0, y = 0.8, xend = n_80, yend = 0.80), linetype = 2, color = "red") +
  geom_segment(aes(x = n_80, y = 0, xend = n_80, yend = 0.80), linetype = 2, color = "red")

## ------------------------------------------------------------------------
#' Sample size for proportions, with uncertainty (V2)
#' 
#' Create an new DISTRIBUTION object that produce
#' random drawns of the estimated sample size for
#' two proportions as well as the samples from the parameters
#' @param p0 a DISTRIBUTION object that drawns for proportions in control group
#' @param logrr a DISTRIBUTION object that drawns log(RR) of the intervention
#' @param alpha significant value
#' @param beta  1-power
new_SAMPLE_SIZE2 <- function(p0,logrr, alpha= 0.05, beta=0.2){
  #checkings
  stopifnot(inherits(p0,"DISTRIBUTION"))
  stopifnot(inherits(logrr,"DISTRIBUTION"))
  stopifnot(0 < alpha & alpha < 1)
  stopifnot(0 < beta & beta < 1)

 # function of alpha and beta
  f_alpha_beta <- (qnorm(alpha/2,lower.tail = F) + qnorm(beta, lower.tail = F)) ^ 2 
  
  # The expected value of the distribution with default name for the dimension
  # based on the oval value of the individual distributions  
  v0 <- p0$oval
  v1 <- p0$oval*exp(logrr$oval)
  
  # expected value of the distribution
  ss <- f_alpha_beta * (v0 * (1 - v0) + v1 * (1 - v1)) / (v0 - v1) ^ 2
  .oval = c(p0$oval, exp(logrr$oval), ss)
  names(.oval) <- c('prevalence', 'rr', 'sample_size')
    
  #random function within a restricted environment where only
  #the specified variables can be accesed within the function
  .rfunc <- restrict_environment(
     function(n) {
       d_p0 = rfunc_p0(n)
       d_rr = exp(rfunc_logrr(n))
       d_p1 = d_p0 * d_rr
       d_ss = fab * (d_p0 * (1 - d_p0) + d_p1 * (1 - d_p1)) / (d_p0 - d_p1) ^ 2
       matrix(
         c(d_p0, d_rr, d_ss), 
         ncol = 3, 
         dimnames = list(1:n, c('prevalence','rr','sample_size')))
     },
     rfunc_p0 = p0$rfunc,
     rfunc_logrr = logrr$rfunc,
     fab = f_alpha_beta
  )
  # Create the object with 4 slots
  structure(
    list(
      distribution = "SAMPLE_SIZE2",
      seed = sample(1:2 ^ 15, 1),
      oval = .oval,
      rfunc = .rfunc
    ), 
    class = c("SAMPLE_SIZE2","DISTRIBUTION")
  )
  
}

## ------------------------------------------------------------------------
d_sample2 <- new_SAMPLE_SIZE2(d_p0, d_logrr)

## ----echo=FALSE, results='asis'------------------------------------------
knitr::kable(summary(d_sample2), digits = 2)

## ------------------------------------------------------------------------
ss <- rfunc(d_sample2, 10000)
df <- data.frame(ss)
df$category = cut(df$sample_size, c(0,150,Inf),include.lowest = T, ordered_result = T)
head(df)

## ----fig.width=7, fig.height=5, echo = F, warning=FALSE, message=FALSE----
 ggplot(df, aes(x = prevalence, y = rr, color = category)) + geom_point(size = 1)

