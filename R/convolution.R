# Here the file to make the convolution
# 20181029 by JJAV
# # #  # # # # # # # # # # # # # # # #

#' Make the convolution of two or more \code{\link{DISTRIBUTION}} objects
#'
#' The convolution of the simple algebraic operations is made by the operation of individual drawns of
#' the distributions. The \code{\link{DISTRIBUTION}} objects must have the
#' same dimensions.
#'
#' If any of the distributions is of class \code{NA} (\code{\link{NA_DISTRIBUTION}})
#' the result will be a new distribution of class \code{NA} unless the
#'  \code{omit_NA} option is set to \code{TRUE}
#' @param listdistr a list of \code{\link{DISTRIBUTION}} objects
#' @param omit_NA if TRUE, \code{NA} distributions will be omitted
#' @param op a function to convolute `+`, `-`, `*`, `\`
#' @return and object of class \code{CONVOLUTION}, \code{\link{DISTRIBUTION}}
#' @export
#' @examples 
#' x1 <- new_NORMAL(0,1)
#' x2 <- new_UNIFORM(1,2)
#' new_CONVOLUTION(list(x1,x2), `+`)
#' @name CONVOLUTION
new_CONVOLUTION <- function(listdistr, op, omit_NA = FALSE){
  stopifnot(all(sapply(listdistr,inherits,"DISTRIBUTION")))
  stopifnot(same_dimensions(listdistr))
  if (omit_NA) {
    listdistr <- omit_NA(listdistr)
  }
  if (any(sapply(listdistr,inherits,"NA"))) {
    return(new_NA(p_dimnames = names(listdistr[[1]]$oval)))
  }
  .oval <- listdistr[[1]]$oval
  i = 2
  while (i <= length(listdistr)) {
    .oval = op(.oval, listdistr[[i]]$oval)
    i = i + 1
  }
  .rfunc = restrict_environment(function(n){
    drawns <- lapply(rfuncs,function(y){y(n)})
    res <- drawns[[1]]
    i = 2
    while (i <= length(drawns)) {
      res = op(res, drawns[[i]])
      i = i + 1
    }
    res
  }, rfuncs =  lapply(listdistr, `[[`, "rfunc"), op = op)
  structure(
    list(
      distribution = "CONVOLUTION",
      seed = sample(1:2^15,1),
      oval = .oval,
      rfunc = .rfunc),
    class = c("CONVOLUTION","DISTRIBUTION"))      
}

#' @describeIn CONVOLUTION Sum of distributions
#' @export
#' @examples 
#' new_SUM(list(x1,x2))
new_SUM <- function(listdistr, omit_NA = FALSE) {
  new_CONVOLUTION(listdistr, `+`, omit_NA = omit_NA)
}

#' @name CONVOLUTION
#' @param e1 object of class \code{\link{DISTRIBUTION}}
#' @param e2 object of class \code{\link{DISTRIBUTION}}
#' @export
#' @examples 
#' x1 + x2
`+.DISTRIBUTION` <- function(e1,e2) new_SUM(list(e1,e2))


