% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/convolution_comb.R
\name{CONVOLUTION_comb}
\alias{CONVOLUTION_comb}
\alias{new_CONVOLUTION_comb}
\alias{new_SUM_comb}
\alias{new_SUBTRACTION_comb}
\alias{new_MULTIPLICATION_comb}
\alias{new_DIVISION_comb}
\title{Convolution with combination of dimensions}
\usage{
new_CONVOLUTION_comb(dist1, dist2, op, p_dimnames)

new_SUM_comb(dist1, dist2)

new_SUBTRACTION_comb(dist1, dist2)

new_MULTIPLICATION_comb(dist1, dist2)

new_DIVISION_comb(dist1, dist2)
}
\arguments{
\item{dist1}{an object of class \code{\link{DISTRIBUTION}}}

\item{dist2}{and object of class \code{\link{DISTRIBUTION}}}

\item{op}{one of `+`,`-`,`*`,`/`}

\item{p_dimnames}{a character vector with the name of the dimensions.
If missing the combination of the individual dimensions will be used}
}
\value{
an object of class \code{\link{DISTRIBUTION}}
}
\description{
In case of different dimensions of the distribution
this function perform the operation on the combination of the distributions
of both distribution.
}
\details{
If distribution A have dimensions a and b and distribution B have dimensions
b and c, the A + B would produce a distribution with dimensions
a_b,a_c,b_b, b_c
}
\section{Functions}{
\itemize{
\item \code{new_SUM_comb()}: Sum of distributions

\item \code{new_SUBTRACTION_comb()}: Subtraction of distributions

\item \code{new_MULTIPLICATION_comb()}: Multiplication of distributions

\item \code{new_DIVISION_comb()}: Division of distributions

}}
\note{
In case of the same dimensions, only the first combination is taken
}
\examples{
x1 <- new_MULTINORMAL(c(0,1), matrix(c(1,0.5,0.5,1),ncol=2), p_dimnames = c("A","B"))
x2 <- new_MULTINORMAL(c(10,1), matrix(c(1,0.4,0.4,1),ncol=2), p_dimnames = c("B","C"))
new_CONVOLUTION_comb(x1,x2, `+`)
new_SUM_comb(x1,x2)
new_SUBTRACTION_comb(x1,x2)
new_MULTIPLICATION_comb(x1,x2)
new_DIVISION_comb(x1,x2)
}
\author{
John J. Aponte
}
