% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/helper_functions.R
\name{fitdirichlet}
\alias{fitdirichlet}
\title{Fits a Dirichlet distribution,}
\usage{
fitdirichlet(..., plotBeta = FALSE, n.fitted = "opt")
}
\arguments{
\item{...}{named vectors with the distribution parameters shape1, shape2}

\item{plotBeta}{if TRUE a ggplot of the densities are plotted}

\item{n.fitted}{Method to fit the values}
}
\value{
a vector with the parameters for a Dirichlet distribution
}
\description{
Fits a Dirichlet distribution based on the parameters of Beta distributions
}
\details{
Each one of the arguments is a named vector with values for shape1, shape2.
Values from \code{\link{fitbeta}} are suitable for this. 
This is a wrap of \code{\link[SHELF]{fitDirichlet}}
}
\examples{
a <- fitbeta(0.3, 0.2, 0.4)
c <- fitbeta(0.2, 0.1, 0.3)
b <- fitbeta(0.5, 0.4, 0.6)
fitdirichlet(cat1=a,cat2=b,cat3=c)
}
\seealso{
\code{\link[SHELF]{fitDirichlet}}
}
\author{
John J. Aponte
}
