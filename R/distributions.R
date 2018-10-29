# Functions for distributions
# The DISTRIBUTION class is abstract
# 2018-10-26 by JJAV
# # # # # # # # # # # # # # # # # # #

##### DISTRIBUTION
#' DISTRIBUTION class
#'
#' DISTRIBUTION is an abstract class (or interphase)
#' that the specific constructors should implement.
#'
#'
#' It contains 4 fields
#' \describe{
#'  \item{distribution}{A character with the name of the distribution implemented}
#'  \item{seed}{A numerical that is used for \code{details} to produce
#'  reproducible details of the distribution}
#'  \item{oval}{Observerd value. Is the value expected. It is used as a
#'  number for the mathematical operations of the distributions
#'  as if they were a simple scalar}
#'  \item{rfunc}{A function that generate random numbers from the distribution.
#'  Its only parameter \code{n} is the number of drawns of the distribution.
#'  It returns a matrix with as many rows as n, and as many columns as the
#'  dimensions of the distributions}
#' }
#'The DISTRIBUTION objects could support multidimensional distributions
#'for example  \code{\link{DIRICHLET}}. The names of the dimensions
#'should coincides with the names of the \code{oval} vector.
#'If only one dimension, the default name is \code{rvar}.
#'
#'It is expected that the \code{rfunc} is included in the creation of new
#'distributions by convolution so the enviromnent should be carefully controlled
#'to avoid reference leaking that is possible within the R language. For that
#'reason, \code{rfunc} should be created within a \code{\link{restrict_environment}}
#'function
#'
#'Once the object is instanciated, the fields are immutable and should not be
#'changed.
#'
#' Objects are defined for the following distributions
#' \itemize{
#'  \item \code{\link{UNIFORM}}
#'  \item \code{\link{NORMAL}}
#'  \item \code{\link{BETA}}
#'  \item \code{\link{TRIANGULAR}}
#'  \item \code{\link{POISSON}}
#'  \item \code{\link{EXPONENTIAL}}
#'  \item \code{\link{DISCRETE}}
#'  \item \code{\link{DIRAC}}
#'  \item \code{\link{DIRICHLET}}
#'  \item \code{\link{TRUNCATED}}
#'  \item \code{\link{NA_DISTRIBUTION}}
#' }
#' 
#' @name DISTRIBUTION
NULL

#' Factory for a NORMAL distribution object
#'
#' Returns a NORMAL distribution object that produce random numbers
#' from a normal distribution using the \code{\link{rnorm}} funtion
#' @author John Aponte
#' @param p_mean A numeric that represents the mean value
#' @param p_sd A numeric that represents the standard deviation
#' @return An object of class \code{\link{DISTRIBUTION}}, \code{NORMAL}
#' @importFrom stats rnorm
#' @export
#' @examples
#' myDistr <- new_NORMAL(0,1)
#' myDistr$rfunc(10)
#' @name NORMAL
new_NORMAL <- function(p_mean, p_sd) {
  structure(
    list(
      distribution = "NORMAL",
      seed = sample(1:2 ^ 15, 1),
      oval = c("rvar" = p_mean),
      rfunc = restrict_environment(function(n) {
        matrix(rnorm(n, p_mean, p_sd),
               ncol = 1,
               dimnames = list(1:n, "rvar"))
      },
      p_mean = p_mean, p_sd = p_sd)
    ),
    class = c("NORMAL", "DISTRIBUTION")
  )
}

#' Factory for a UNIFORM distribution object
#'
#' Returns an UNIFORM distribution object that produce random numbers
#' from a  uniform distribution using the \code{\link{runif}} funtion
#' @author John Aponte
#' @param p_min A numeric that represents the lower limit
#' @param p_max A numeric that represents the upper limit
#' @return An object of class \code{DISTRIBUTION}, \code{UNIFORM}
#' @importFrom stats runif
#' @export
#' @examples
#' myDistr <- new_UNIFORM(0,1)
#' myDistr$rfunc(10)
#' @name UNIFORM
new_UNIFORM <- function(p_min, p_max) {
  stopifnot(p_min <= p_max)
  structure(
    list(
      distribution = "UNIFORM",
      seed = sample(1:2 ^ 15, 1),
      oval = c("rvar" = (p_max - p_min) / 2 + p_min),
      rfunc = restrict_environment(function(n) {
        matrix(runif(n, p_min, p_max),
               ncol = 1,
               dimnames = list(1:n, "rvar"))
      },
      p_min = p_min, p_max = p_max)
    ),
    class = c("UNIFORM", "DISTRIBUTION")
  )
}


#' Factory for a BETA distribution object
#'
#' Returns an BETA distribution object that produce random numbers
#' from a  beta distribution using the \code{\link{rbeta}} function
#' @author John Aponte
#' @param p_shape1 parameters of the beta distribution
#' @param p_shape2 parameters of the beta distribution
#' @return An object of class \code{DISTRIBUTION}, \code{BETA}
#' @importFrom stats rbeta
#' @export
#' @examples
#' myDistr <- new_BETA(1,1)
#' myDistr$rfunc(10)
#' @name BETA
new_BETA <- function(p_shape1, p_shape2) {
  structure(
    list(
      distribution = "BETA",
      seed = sample(1:2 ^ 15, 1),
      oval = c("rvar" = p_shape1 / (p_shape1 + p_shape2)),
      rfunc = restrict_environment(function(n) {
        matrix(rbeta(n, p_shape1, p_shape2),
               ncol = 1,
               dimnames = list(1:n, "rvar"))
      },
      p_shape1 = p_shape1, p_shape2 = p_shape2)
    ),
    class = c("BETA", "DISTRIBUTION", "list")
  )
}

#' @note
#' When using confidence intervals, the shape parameters are obtained
#' using the following formula:
#'
#' \eqn{varp = (p_uci-p_lci)/4^2}
#'
#' \eqn{shape1 = p_mean * (p_mean * (1 - p_mean) / varp - 1)}
#'
#' \eqn{shape2 =(1 - p_mean) * (p_mean * (1 - p_mean) / varp - 1) }
#'
#' @param p_mean A numeric that represents the expected value of the proportion
#' @param p_lci A numeric for the lower 95\% confidence interval
#' @param p_uci A numeric for the upper 95\% confidence interval
#' @importFrom stats rbeta
#' @export
#' @examples
#' myDistr <- new_BETA_lci(0.30,0.25,0.35)
#' myDistr$rfunc(10)
#' @describeIn BETA Constructor based on confidence intervals
new_BETA_lci <- function(p_mean, p_lci, p_uci) {
  stopifnot(p_lci < p_uci)
  stopifnot(p_lci < p_mean & p_mean < p_uci)
  stopifnot(0 < p_mean & p_mean < 1)
  stopifnot(0 <= p_lci & p_lci < 1)
  stopifnot(0 < p_uci & p_uci <= 1)
  varp <- abs(((p_uci - p_lci)) / 4) ^ 2
  p_shape1 <- p_mean * (p_mean * (1 - p_mean) / varp - 1)
  p_shape2 <- (1 - p_mean) * (p_mean * (1 - p_mean) / varp - 1)
  new_BETA(p_shape1,p_shape2)
}

#' Factory for a TRIANGULAR distribution object
#'
#' Returns an TRIANGULAR distribution object that produce random numbers
#' from a  triangular distribution using the \code{\link[extraDistr]{rtriang}}
#' function
#' @author John Aponte
#' @param p_min A numeric that represents the lower limit
#' @param p_max A numeric that represents the upper limit
#' @param p_mode A numeric that represents the mode
#' @return An object of class \code{DISTRIBUTION}, \code{TRIANGULAR}
#' @importFrom extraDistr rtriang
#' @export
#' @examples
#' myDistr <- new_TRIANGULAR(-1,1,0)
#' myDistr$rfunc(10)
#' @name TRIANGULAR
new_TRIANGULAR <- function(p_min, p_max, p_mode) {
  stopifnot(p_min < p_max)
  stopifnot(p_min <= p_mode & p_mode <= p_max)
  structure(
    list(
      distribution = "TRIANGULAR",
      seed = sample(1:2 ^ 15, 1),
      oval = c("rvar" = (p_min + p_max + p_mode) / 3),
      rfunc = restrict_environment(
        function(n) {
          matrix(rtriang(n, a, b, c),
                 ncol = 1,
                 dimnames = list(1:n, "rvar"))
        },
        a = p_min,
        b = p_max,
        c = p_mode
      )
    ),
    class = c("TRIANGULAR", "DISTRIBUTION")
  )
}


#' Factory for a POISSON distribution using confidence intervals
#'
#' Returns an POISSON distribution object that produce random numbers
#' from a Poisson distribution using the \code{\link{rpois}} function
#' @author John Aponte
#' @param p_lambda A numeric that represents the expected number of events
#' @return An object of class \code{DISTRIBUTION}, \code{POISSON}
#' @importFrom stats rpois
#' @export
#' @examples
#' myDistr <- new_POISSON(5)
#' myDistr$rfunc(10)
#' @name POISSON
new_POISSON <- function(p_lambda) {
  stopifnot(p_lambda > 0)
  structure(
    list(
      distribution = "POISSON",
      seed = sample(1:2 ^ 15, 1),
      oval = p_lambda,
      rfunc = restrict_environment(function(n) {
        matrix(rpois(n, p_lambda),
               ncol = 1,
               dimnames = list(1:n, "rvar"))
      },
      p_lambda = p_lambda)
    ),
    class = c("POISSON", "DISTRIBUTION")
  )
}


#' Factory for a EXPONENTIAL distribution using confidence intervals
#'
#' Returns an EXPONENTIAL distribution object that produce random numbers
#' from an exponential distribution using the \code{\link{rexp}} function
#' @author John Aponte
#' @param p_rate A numeric that represents the rate of events
#' @return An object of class \code{DISTRIBUTION}, \code{EXPONENTIAL}
#' @importFrom stats rexp
#' @export
#' @examples
#' myDistr <- new_EXPONENTIAL(5)
#' myDistr$rfunc(10)
#' @name EXPONENTIAL
new_EXPONENTIAL <- function(p_rate) {
  stopifnot(p_rate >= 0)
  structure(
    list(
      distribution = "EXPONENTIAL",
      seed = sample(1:2 ^ 15, 1),
      oval = c("rvar" = 1 / p_rate),
      rfunc = restrict_environment(function(n) {
        matrix(rexp(n, p_rate),
               ncol = 1,
               dimnames = list(1:n, "rvar"))
      },
      p_rate = p_rate)
    ),
    class = c("EXPONENTIAL", "DISTRIBUTION")
  )
}


#' Factory for a DISCRETE distribution object
#'
#' Returns an DISCRETE distribution object that sample from the vector \code{p_supp} of
#' options with probability the vector of probabilities \code{p_prob}.
#'
#' @note If the second argument is missing, all options will be sample with
#'  equal probability. If provided, the second argument would add to 1 and must
#'  be the same length that the first argument
#' @author John Aponte
#' @param p_supp A numeric vector of options
#' @param p_prob A numeric vector of probabilities.
#' @return An object of class \code{DISTRIBUTION}, \code{DISCRETE}
#' @export
#' @examples
#' myDistr <- new_DISCRETE(p_supp=c(1,2,3,4), p_prob=c(0.40,0.30,0.20,0.10))
#' myDistr$rfunc(10)
#' @name DISCRETE
new_DISCRETE <- function(p_supp, p_prob = NA) {
  stopifnot(missing(p_prob) ||
              is.na(p_prob) || length(p_supp) == length(p_prob))
  if (missing(p_prob) || is.na(p_prob)) {
    p_prob = rep(1 / length(p_supp), length(p_supp))
  }
  stopifnot(abs(1 - sum(p_prob)) < 1 ^ 0.4)
  structure(
    list(
      distribution = "DISCRETE",
      seed = sample(1:2 ^ 15, 1),
      oval = c("rvar" = sum(p_supp * p_prob)),
      rfunc = restrict_environment(function(n) {
        matrix(
          sample(p_supp, n, replace = TRUE, prob = p_prob),
          ncol = 1,
          dimnames = list(1:n, "rvar")
        )
      },
      p_supp = p_supp, p_prob = p_prob)
    ),
    class = c("DISCRETE", "DISTRIBUTION")
  )
}

#' Factory for a NA distribution object
#'
#' Returns an NA distribution object that always return \code{NA_real_}
#' This is usefull to handle \code{NA}.
#' By default only one dimension \code{rvar} is produced, but if several
#' names are provided more columns will be added to the return matrix
#' @author John Aponte
#' @param p_dimnames A character that represents the the names of the
#'  dimensions. By default only one dimension with name \code{rvar}
#' @return An object of class \code{DISTRIBUTION}, \code{NA}
#' @export
#' @examples
#' myDistr <- new_NA(p_dimnames = "rvar")
#' myDistr$rfunc(10)
#' @name NA_DISTRIBUTION
new_NA <- function(p_dimnames = "rvar") {
  .oval = rep(NA_real_, length(p_dimnames))
  names(.oval) <- p_dimnames
  structure(
    list(
      distribution = "NA",
      seed = sample(1:2 ^ 15, 1),
      oval = .oval,
      rfunc = restrict_environment(function(n) {
        matrix(
          rep(NA_real_, n * length(p_dimnames)),
          ncol = length(p_dimnames),
          dimnames = list(1:n, p_dimnames)
        )
      },
      p_dimnames = p_dimnames)
    ),
    class = c("NA", "DISTRIBUTION")
  )
}

#' Factory for a DIRAC distribution object
#'
#' Returns an DIRAC distribution object that always return the same number.
#'
#' @author John Aponte
#' @param p_value A numeric that set the value for the distribution
#' @return An object of class \code{DISTRIBUTION}, \code{DIRAC}
#' @export
#' @examples
#' myDistr <- new_DIRAC(p_value = 1)
#' myDistr$rfunc(10)
#' @name DIRAC
new_DIRAC <- function(p_value) {
  structure(
    list(
      distribution = "DIRAC",
      seed = sample(1:2 ^ 15, 1),
      oval = c("rvar" = p_value),
      rfunc = restrict_environment(function(n) {
        matrix(rep(p_value, n),
               ncol = 1,
               dimnames = list(1:n, "rvar"))
      },
      p_value = p_value)
    ),
    class =  c("DIRAC", "DISTRIBUTION")
  )
}


#' Factory for a TRUNCATED distribution object
#'
#' Returns an TRUNCATED distribution object that limits the values that are
#' generated by the distribution to be in the limits \code{p_min, p_max}
#'
#' @note The expected value of a truncated distribution could be very
#' different from the expected value of the unrestricted distribution. Be
#' carefull as the \code{oval} field is not changed and may not represent
#' anymore the expected value of the distribution.
#'
#' If the distribution is multidimensional, the limits will apply to all dimensions.
#' @author John Aponte
#' @param p_distribution An object of class DISTRIBUTION to truncate
#' @param p_min A numeric that set the lower limit of the distribution
#' @param p_max A numeric that set the upper limit of the distribution
#' @return An object of class \code{DISTRIBUTION},
#'  \code{p_distribution$distribution}, \code{TRUNCATED}
#' @export
#' @examples
#' myDistr <- new_TRUNCATED(p_distribution = new_NORMAL(0,1), p_min = -1, p_max = 1)
#' myDistr$rfunc(10)
#' @name TRUNCATED
new_TRUNCATED <-
  function(p_distribution,
           p_min = -Inf,
           p_max = Inf) {
    stopifnot(inherits(p_distribution, "DISTRIBUTION"))
    structure(
      list(
        distribution = "TRUNCATED",
        seed = sample(1:2 ^ 15, 1),
        oval = p_distribution$oval,
        rfunc = restrict_environment(
          function(n) {
            res <- p_function(n)
            res[res < p_min] <- p_min
            res[res > p_max] <- p_max
            res
          },
          p_function = p_distribution$rfunc,
          p_min = p_min,
          p_max = p_max
        )
      ),
      class = c("TRUNCATED", class(p_distribution))
    )
  }


#' Factory for a DIRICHLET distribution object
#'
#' Returns an DIRCHLET distribution object that limits the values that are
#' generated by the function \code{\link[extraDistr]{rdirichlet}}
#'
#'A name can be provided for the dimensions. Otherwise \code{rvar1},
#'\code{rvar2}, ..., \code{rvark} will be assigned
#'
#' @author John Aponte
#' @param p_alpha k-value vector for concentration parameter. Must be positive
#' @param p_dimnames A vector of characters for the names of the k-dimensions
#' @return An object of class \code{DISTRIBUTION},
#'  \code{p_distribution$distribution}, \code{TRUNCATED}
#'@importFrom extraDistr rdirichlet
#' @export
#' @examples
#' myDistr <- new_DIRICHLET(c(0.3,0.2,0.5), c("a","b","c"))
#' myDistr$rfunc(10)
#' @name DIRICHLET
new_DIRICHLET <- function(p_alpha, p_dimnames) {
  .sum_alpha = sum(p_alpha)
  .oval = p_alpha / .sum_alpha
  if (missing(p_dimnames)) {
    p_dimnames = paste("rvar", seq(1:length(p_alpha)), sep = "")
  }
  names(.oval) <- p_dimnames
  structure(
    list(
      distribution = "DIRICHLET",
      seed = sample(1:2 ^ 15, 1),
      oval = .oval,
      rfunc = restrict_environment(function(n) {
        res <- rdirichlet(n, p_alpha)
        colnames(res) <- p_dimnames
        res
      },
      p_alpha = p_alpha,
      p_dimnames = p_dimnames)
    ),
    class = c("DIRICHLET", "DISTRIBUTION")
  )
}


#' Factory for a LOGNORMAL distribution object
#'
#' Returns a LOGNORMAL distribution object that produce random numbers
#' from a log normal distribution using the \code{\link{rlnorm}} funtion
#' @author John Aponte
#' @param p_meanlog mean of the distribution on th elog scale
#' @param p_sdlog A numeric that represents the standard deviation on the log scale
#' @return An object of class \code{\link{DISTRIBUTION}}, \code{LOGNORMAL}
#' @importFrom stats rnorm
#' @export
#' @examples
#' myDistr <- new_LOGNORMAL(0,1)
#' myDistr$rfunc(10)
#' @name LOGNORMAL
new_LOGNORMAL <- function(p_meanlog, p_sdlog) {
  structure(
    list(
      distribution = "LOGNORMAL",
      seed = sample(1:2 ^ 15, 1),
      oval = c("rvar" = p_meanlog),
      rfunc = restrict_environment(function(n) {
        matrix(rlnorm(n, p_meanlog, p_sdlog),
               ncol = 1,
               dimnames = list(1:n, "rvar"))
      },
      p_meanlog = p_meanlog, p_sdlog = p_sdlog)
    ),
    class = c("LOGNORMAL", "DISTRIBUTION")
  )
}
