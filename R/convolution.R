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


#' @describeIn CONVOLUTION Substration for distributions
#' @export
#' @examples 
#' new_SUBSTRATION(list(x1,x2))
new_SUBSTRATION <- function(listdistr, omit_NA = FALSE) {
  new_CONVOLUTION(listdistr, `-`, omit_NA = omit_NA)
}

#' @name CONVOLUTION
#' @export
#' @examples 
#' x1 - x2
`-.DISTRIBUTION` <- function(e1,e2) new_SUBSTRATION(list(e1,e2))

#' @describeIn CONVOLUTION Multiplication for distributions
#' @export
#' @examples 
#' new_MULTIPLICATION(list(x1,x2))
new_MULTIPLICATION <- function(listdistr, omit_NA = FALSE) {
  new_CONVOLUTION(listdistr, `*`, omit_NA = omit_NA)
}

#' @name CONVOLUTION
#' @export
#' @examples 
#' x1 * x2
`*.DISTRIBUTION` <- function(e1,e2) new_MULTIPLICATION(list(e1,e2))

#' @describeIn CONVOLUTION  DIVISION for distributions
#' @export
#' @examples 
#' new_DIVISION(list(x1,x2))
new_DIVISION <- function(listdistr, omit_NA = FALSE) {
  new_CONVOLUTION(listdistr, `/`, omit_NA = omit_NA)
}

#' @name CONVOLUTION
#' @export
#' @examples 
#' x1 / x2
`/.DISTRIBUTION` <- function(e1,e2) new_DIVISION(list(e1,e2))


#' Mixture of \code{\link{DISTRIBUTION}} objects
#' 
#' Produce a new distribution that obtain random drawns of the mixture
#' of the \code{\link{DISTRIBUTION}} objects
#' 
#' @param listdistr a list of \code{\link{DISTRIBUTION}} objects
#' @param mixture a vector of probabilities to mixture the distributions. Must add 1
#' If missing the drawns are obtained from the distributions with the same probability
#' @return an object of class \code{MIXTURE}, \code{\link{DISTRIBUTION}}
#' @export
#' @examples 
#' x1 <- new_NORMAL(0,1)
#' x2 <- new_NORMAL(4,1)
#' x3 <- new_NORMAL(6,1)
#' new_MIXTURE(list(x1,x2,x3))
new_MIXTURE <- function(listdistr, mixture) {
  if (missing(mixture))
    mixture = NA
  stopifnot(length(listdistr) > 0)
  stopifnot(all(sapply(listdistr, inherits, "DISTRIBUTION")))
  stopifnot(same_dimensions(listdistr))
  if (is.na(mixture[1])) {
    mixture = rep(1 / length(listdistr), length(listdistr))
  }
  stopifnot(!any(is.na(mixture)))
  stopifnot(abs(sum(mixture) - 1) < 0.01)
  stopifnot(length(listdistr) == length(mixture))
  .oval <- listdistr[[1]]$oval * mixture[1]
  i = 2
  while (i <= length(listdistr)) {
    .oval = .oval + listdistr[[i]]$oval * mixture[i]
    i = i + 1
  }
  .rfuncs = lapply(listdistr, function(x) {
    x$rfunc
  })
  structure(
    list(
      distribution = "MIXTURE",
      seed = sample(1:2 ^ 15, 1),
      oval = .oval,
      rfunc = restrict_environment(function(n) {
        # We get initial samples where at list 1 drawn is get
        # from the all distributions and a minimun of n*2 drawns are made
        obj_n = ceiling(max(10 ^ (-log10(min(
          mixture
        ))), n * 2))
        subx <- ceiling(mixture * obj_n)
        res <- rfunc[[1]](subx[1])
        i = 2
        while (i <= length(rfunc)) {
          res = rbind(res, rfunc[[i]](subx[i]))
          i = i + 1
        }
        matrix(res[sample(1:nrow(res), n, replace = TRUE),],
               ncol = ncol(res) ,
               dimnames = list(1:n, colnames(res)))
      },
      rfunc = .rfuncs, mixture = mixture)
    ),
    class = c("MIXTURE", "DISTRIBUTION")
  )
}

 
