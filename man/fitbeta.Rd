% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/helper_functions.R
\name{fitbeta}
\alias{fitbeta}
\alias{fitbeta_ml}
\title{Fits a beta distribution based on quantiles}
\usage{
fitbeta_ml(point, lci, uci)

fitbeta(point, lci, uci)
}
\arguments{
\item{point}{Point estimates corresponding to the median}

\item{lci}{Lower limit (quantile 0.025)}

\item{uci}{Upper limit (quantile 0.975)}
}
\value{
parameters shape1 and shape2 of a beta distribution
}
\description{
Fits a beta distribution based on quantiles
}
\section{Functions}{
\itemize{
\item \code{fitbeta_ml()}: using ML to estimate parameters

\item \code{fitbeta()}: preserve the expected value

}}
\note{
This is a wrap of the \code{\link[SHELF]{fitdist}} to obtain
the best parameters for a beta distribution based
on quantiles.

When using confidence intervals (not ML), the shape parameters are obtained
using the following formula:

\eqn{varp = (p_uci-p_lci)/4^2}

\eqn{shape1 = p_mean * (p_mean * (1 - p_mean) / varp - 1)}

\eqn{shape2 =(1 - p_mean) * (p_mean * (1 - p_mean) / varp - 1) }
}
\examples{
fitbeta_ml(0.45,0.40,0.50)
fitbeta(0.45,0.40,0.50)
}
\seealso{
\code{\link[SHELF]{fitdist}}
}
\author{
John J. Aponte
}
