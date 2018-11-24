# Methods for DISTRIBUTION class
# 20181028 by JJAV
# # # # # # # # # # # # # # # # # 

# Fields in the DISTRIBUION object are immutable and should not be changed

#' @export
`[[<-.DISTRIBUTION` <- function(..., value){
  stop("Objects of class DISTRIBUTION are immutable")

}

#' @export
`[<-.DISTRIBUTION` <- function(..., value){
  stop("Objects of class DISTRIBUTION are immutable")

}

#' @export
`$<-.DISTRIBUTION` <- function(..., value){
  stop("Objects of class DISTRIBUTION are immutable")
}

#' Metadata for a DISTRIBUTION
#'
#' Shows the distribution and the oval values of a \code{\link{DISTRIBUTION}}
#' object
#'
#' @note The number of columns depends on the dimensions of the distribution.
#' There will be one column \code{distribution} with the name of the distribution
#' and one column for each dimension with the names from the \code{oval} field.
#'
#' @author John J. Aponte
#' @param x  a \code{\link{DISTRIBUTION}} object
#' @return A \code{\link{data.frame}} with the metadata of the distributions
#' @export
metadata <- function(x) {
  UseMethod("metadata",x)
}

#' @describeIn metadata Metadata for DISTRIBUTION objects
#' @importFrom dplyr bind_cols
#' @export
metadata.DISTRIBUTION <- function(x) {
  dplyr::bind_cols(
    data.frame(
      distribution = x$distribution,
      stringsAsFactors = FALSE,
      row.names = NULL
    ),
    data.frame(t(x$oval))
  )
}

#' @describeIn metadata Metadata for other objects
#' @export
metadata.default <- function(x){
  stop("Don't know how to make metadata for an object of class", class(x))
}


#' @export
print.DISTRIBUTION <- function(x, ...){
  print(metadata(x))
  invisible(x)
}


#' cinqnum
#'
#' Make a list with 5 numbers of the distribution (mean_, sd_, lci_, uci_, median_).
#'
#' Uses the stored seed to have the same sequence always and produce the same numbers
#' This is an internal function for the summary function
#' @author John J. Aponte
#' @param x an object of class \code{\link{DISTRIBUTION}}
#' @param ... further parameters
cinqnum <- function(x,...){
  UseMethod("cinqnum",x)
}

#' Generic function for a distribution
#'
#' Generate n random numbers from the distribution, using the seed of the
#' object, so always return the same value. Internal function to be used in the
#' summary
#' @author John J. Aponte
#' @param x an object of  class \code{\link{DISTRIBUTION}}
#' @param n number of drawns
#' @return a list with the  mean, sd, 95%upper and lower centiles and median
#' @import stats
cinqnum.DISTRIBUTION <- function(x,n) {
  if (exists(".Random.seed", .GlobalEnv))
    oldseed <- .GlobalEnv$.Random.seed
  else
    oldseed <- NULL
  set.seed(x$seed)
  draws <- x$rfunc(n)
  if (!is.null(oldseed))
    .GlobalEnv$.Random.seed <- oldseed
  else
    rm(".Random.seed", envir = .GlobalEnv)
  mean_ <- apply(draws, 2, mean)
  sd_ <- apply(draws, 2, sd)
  lci_ <- apply(draws, 2, quantile, 0.025, na.rm = TRUE)
  uci_ <- apply(draws, 2, quantile, 0.975, na.rm = TRUE)
  median_ <- apply(draws, 2, median)
  list(
    mean_ = mean_,
    sd_ = sd_,
    lci_ = lci_,
    uci_ = uci_,
    median_ = median_
  )
}

#' And optimized version for NA distribution
#'
#' @author John J. Aponte
#' @param x an object of  class \code{\link{DISTRIBUTION}}
#' @param n number of drawns
#' @return a list of NA
cinqnum.NA <- function(x,n) {
  list(
    mean_ = x$oval,
    sd_ = x$oval,
    sd_ =  x$oval,
    lci_ =  x$oval,
    uci_ =  x$oval,
    median_ =  x$oval
  )
}

#' And optimized version for DIRAC distributions
#'
#' @author John J. Aponte
#' @param x an object of  class \code{\link{DISTRIBUTION}}
#' @param n number of drawns
#' @return a list of NA
cinqnum.DIRAC <- function(x,n) {
  list(
    mean_ = x$oval,
    sd_ = 0,
    sd_ =  x$oval,
    lci_ =  x$oval,
    uci_ =  x$oval,
    median_ =  x$oval
  )
}

#' Summary of Distributions
#'
#' @author John J. Aponte
#' @param object object of class \code{\link{DISTRIBUTION}}
#' @param n the number of random samples from the distribution
#' @param ... other parameters. Not used
#' @return A \code{\link{data.frame}} with as many rows as dimensions had the
#' distribution and  with the following columns
#' \itemize{
#'   \item distribution name
#'   \item varname name of the dimension
#'   \item oval value
#'   \item nsample number of random samples
#'   \item mean_ mean value of the sample
#'   \item sd_ standard deviation of the sample
#'   \item lci_ lower 95% centile of the sample
#'   \item median_ median value of the sample
#'   \item uci_ upper 95% centile of the sample
#' }
#' @note The sample uses the seed saved in the object those it will
#' provide the same values fir an \code{n} value
#' @export
summary.DISTRIBUTION <- function(object, n = 10000, ...) {
  cinqlist <- cinqnum(object,n)
  data.frame(distribution = object$distribution,
             varname = names(object$oval),
             oval = object$oval,
             nsample = n,
             mean_ = cinqlist[["mean_"]],
             sd_ = cinqlist[["sd_"]],
             lci_ = cinqlist[["lci_"]],
             median_ = cinqlist[["median_"]],
             uci_ = cinqlist[["uci_"]] ,
             stringsAsFactors = FALSE,
             row.names = NULL)

}


#' Generate random numbers from a \code{\link{DISTRIBUTION}} object
#'
#' This is a generic method that calls the \code{rfunc} slot of the object
#'
#' @author John J. Aponte
#' @param x an object
#' @param n the number of random samples
#' @return a matrix with as many rows as \code{n} and as many columns as
#' dimensions have \code{distribution}
#' @export
rfunc <- function(x, n) {
  UseMethod("rfunc",x)
}

#' Generic function for a \code{\link{DISTRIBUTION}} object
#'
#' @author John J. Aponte
#' @param x an object of class \code{\link{DISTRIBUTION}}
#' @param n the number of random samples
#' @export
rfunc.DISTRIBUTION <- function(x,n) {
  x$rfunc(n)
}


#' Default function
#' @author John J. Aponte
#' @param x an object of class different from \code{\link{DISTRIBUTION}}
#' @param n the number of random samples
#' @export
rfunc.default <- function(x,n) {
  stop("Don't know how to obtain random numbers from an object of class ", class(x))
}

#' @export
dimnames.DISTRIBUTION <- function(x) {
  return(names(x$oval))
}


#' Modify a the seed of a Distribution object
#' 
#' This create a new \code{\link{DISTRIBUTION}} object but with the
#' specified seed
#' @author John J. Aponte
#' @param distribution a \code{\link{DISTRIBUTION}} object
#' @param seed the new seed
#' @return a code{\link{DISTRIBUTION}} object of the same class
#' @export
set_seed <- function(distribution, seed){
  stopifnot(inherits(distribution,"DISTRIBUTION"))
  stopifnot(is.numeric(seed))
  stopifnot(!is.na(seed))
  stopifnot(length(seed) == 1)
  prevclass <- class(distribution)
  xtemp <- unclass(distribution)
  xtemp$seed <- seed
  class(xtemp) <- prevclass
  xtemp
}