# Helper functions not exported
# 20181028 by JJAV
# # # # # # # # # # # # # # # # #


#' Omit \code{NA} distributions from a list of distributions
#'
#' @author John J. Aponte
#' @param listdistr a list of \code{\link{DISTRIBUTION}} objects
#' @return the list without the \code{\link{NA_DISTRIBUTION}}
omit_NA <- function(listdistr) {
  stopifnot(all(sapply(listdistr, inherits, "DISTRIBUTION")))
  listdistr[!sapply(listdistr, inherits, "NA")]
}

#' Check the dimensions of a list of distributions
#'
#' @param listdistr a list of \code{\link{DISTRIBUTION}} objects
#' @return return \code{TRUE} if all the dimensions are the same
same_dimensions <- function(listdistr) {
  stopifnot(all(sapply(listdistr, inherits, "DISTRIBUTION")))
  sum(duplicated(lapply(listdistr, function(x) {
    names(x$oval)
  }))) == length(listdistr) - 1L
}


#' Fits a beta distribution based on quantiles
#'
#' @author John J. Aponte
#' @param point Point estimates corresponding to the median
#' @param lci Lower limit (quantile 0.025)
#' @param uci Upper limit (quantile 0.975)
#' @return parameters shape1 and shape2 of a beta distribution
#' @examples 
#' fitbeta_ml(0.45,0.40,0.50)
#' fitbeta(0.45,0.40,0.50)
#' @name fitbeta
NULL

#' @note
#' This is a wrap of the \code{\link[SHELF]{fitdist}} to obtain
#' the best parameters for a beta distribution based
#' on quantiles. 
#'
#' @importFrom SHELF fitdist
#' @describeIn fitbeta using ML to estimate parameters
#' @seealso \code{\link[SHELF]{fitdist}}
#' @export
fitbeta_ml <- function(point,lci,uci) {
  p1 <- c(0.025,0.50,0.975)
  vals <- c(lci,point,uci)
  #print(vals)
  if (all(vals == 1)) {
    return(c(shape1 = 1, shape2 = 0))
  }
  if (all(vals == 0)) {
    return(c(shape1 = 0, shape2 = 1))
  }
  fit <- SHELF::fitdist(vals,p1,lower = 0,upper = 1)
  unlist(fit$Beta)
}

#' @note
#' When using confidence intervals (not ML), the shape parameters are obtained
#' using the following formula:
#'
#' \eqn{varp = (p_uci-p_lci)/4^2}
#'
#' \eqn{shape1 = p_mean * (p_mean * (1 - p_mean) / varp - 1)}
#'
#' \eqn{shape2 =(1 - p_mean) * (p_mean * (1 - p_mean) / varp - 1) }
#' @describeIn fitbeta preserve the expected value
#' @export
fitbeta <- function(point, lci, uci) {
  vals <- c(lci,point,uci)
  #print(vals)
  if (all(vals == 1)) {
    return(c(shape1 = 1, shape2 = 0))
  }
  if (all(vals == 0)) {
    return(c(shape1 = 0, shape2 = 1))
  }
  varp <- abs(((uci - lci)) / 4) ^ 2
  p_shape1 <- point * (point * (1 - point) / varp - 1)
  p_shape2 <- (1 - point) * (point * (1 - point) / varp - 1)
  return(c(shape1 = p_shape1, shape2 = p_shape2))
}


#' Fits a Dirichlet distribution, 
#' 
#' Fits a Dirichlet distribution based on the parameters of Beta distributions
#'
#' Each one of the arguments is a named vector with values for shape1, shape2.
#' Values from \code{\link{fitbeta}} are suitable for this. 
#' This is a wrap of \code{\link[SHELF]{fitDirichlet}}
#'
#' @author John J. Aponte
#' @param ... named vectors with the distribution parameters shape1, shape2
#' @param plotBeta if TRUE a ggplot of the densities are plotted
#' @param n.fitted Method to fit the values
#' @return a vector with the parameters for a Dirichlet distribution
#' @importFrom SHELF fitDirichlet
#' @importFrom utils capture.output
#' @examples
#' a <- fitbeta(0.3, 0.2, 0.4)
#' c <- fitbeta(0.2, 0.1, 0.3)
#' b <- fitbeta(0.5, 0.4, 0.6)
#' fitdirichlet(cat1=a,cat2=b,cat3=c)
#' @export
#' @seealso \code{\link[SHELF]{fitDirichlet}}
fitdirichlet <- function(..., plotBeta=FALSE, n.fitted="opt") {
  categories <- names(list(...))
  if (is.null(categories)) {
    categories <- LETTERS[1:(length(list(...)))]
  }
  dist <- lapply(list(...),function(x){list(Beta = x)})
  thearg <- list(dist, categories = categories, plotBeta = plotBeta, n.fitted = n.fitted)
  capture.output(
  res <- do.call(SHELF::fitDirichlet,thearg)
  )
  res
}
