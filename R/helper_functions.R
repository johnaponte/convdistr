# Helper functions not exported
# 20181028 by JJAV
# # # # # # # # # # # # # # # # #


#' Omit \code{NA} distributions from a list of distributions
#'
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
