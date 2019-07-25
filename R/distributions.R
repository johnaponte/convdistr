# Functions for distributions
# The DISTRIBUTION class is abstract
# 2018-10-26 by JJAV
# # # # # # # # # # # # # # # # # # #

##### DISTRIBUTION
#' DISTRIBUTION class
#'
#' DISTRIBUTION is a kind of abstract class (or interface)
#' that the specific constructors should implement.
#'
#'
#' It contains 4 fields
#' \describe{
#'  \item{distribution}{A character with the name of the distribution implemented}
#'  \item{seed}{A numerical that is used for \code{details} to produce
#'  reproducible details of the distribution}
#'  \item{oval}{Observed value. Is the value expected. It is used as a
#'  number for the mathematical operations of the distributions
#'  as if they were a simple scalar}
#'  \item{rfunc}{A function that generate random numbers from the distribution.
#'  Its only parameter \code{n} is the number of draws of the distribution.
#'  It returns a matrix with as many rows as n, and as many columns as the
#'  dimensions of the distributions}
#' }
#'The DISTRIBUTION objects could support multidimensional distributions
#'for example  \code{\link{DIRICHLET}}. The names of the dimensions
#'should coincides with the names of the \code{oval} vector.
#'If only one dimension, the default name is \code{rvar}.
#'
#'It is expected that the \code{rfunc} is included in the creation of new
#'distributions by convolution so the environment should be carefully controlled
#'to avoid reference leaking that is possible within the R language. For that
#'reason, \code{rfunc} should be created within a \code{\link{restrict_environment}}
#'function
#'
#'Once the object is instanced, the fields are immutable and should not be
#'changed. If the seed needs to be modified, a new object can be created using
#'the \code{\link{set_seed}} function
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
#' @author John J. Aponte
#' @name DISTRIBUTION
NULL



#' A factory of \code{\link{DISTRIBUTION}} classes
#'
#' Generate a function that creates \code{\link{DISTRIBUTION}} objects
#'
#' @return  A function that is able to create \code{\link{DISTRIBUTION}} objects.
#' @param distname name of the distribution. By convention they are upper case
#' @param rfunction a function to generate random numbers from the distribution
#' @param ovalfunc a function that calculate the oval value, should used only
#' the same arguments that the \code{rfunction}
#' @examples
#' new_MYDISTR <- DISTRIBUTION_factory("MYDISTR", rnorm, function(){mean})
#' d1 <- new_MYDISTR(0,1)
#' summary(d1)
#' require(extraDistr)
#' new_MyDIRICHLET <- DISTRIBUTION_factory('rdirichlet',
#'                        rdirichlet,
#'                        function() {
#'                          salpha = sum(alpha)
#'                          alpha / salpha
#'                        })
#' d2 <- new_MyDIRICHLET(c(10, 20, 70), dimnames = c("A", "B", "C"))
#' summary(d2)
#' @note The function return a new function, that have as arguments the formals
#' of the \code{rfunction} plus a new argument \code{dimnames} for the dimension
#' names. If The distribution is unidimensional, the default value 
#' \code{ dimnames = "rvar"} will  works well, but if not, the \code{dimnames} 
#' argument should be specified when the generated function is used as in 
#' the example for the \code{new_MyDIRICHLET}
#' @author John J. Aponte
#' @export
#' @keywords DISTRIBUTION
DISTRIBUTION_factory <-
  function(distname, rfunction, ovalfunc) {
    fx <- function() {
      foval <- function() {
        
      }
      body(foval) <- body(ovalfunc)
      .oval <- foval()
      stopifnot(length(.oval) == length(dimnames))
      names(.oval) <- dimnames
      redenv <- as.list(environment())
      topass <-
        redenv[names(redenv[!names(redenv) %in% c(".oval", "ovalfunc", "foval")])]
      .rfunc <- restrict_environment(function(n) {
        draws <-
          do.call(rfunction, c(n, topass[names(topass) %in% names(formals(rfunction))]))
        matrix(draws,
               ncol = cols,
               dimnames = list(1:n, topass$dimnames))
      },
      cols = length(.oval),
      topass)
      structure(
        list(
          distribution = toupper(distname),
          seed = sample(1:2 ^ 15, 1),
          oval = .oval,
          rfunc = .rfunc
        ),
        class = c(toupper(distname), "DISTRIBUTION")
      )
    }
    formals(fx) <-
      c(formals(rfunction)[-1],
        "ovalfunc" = ovalfunc,
        "dimnames" = "rvar")
    fx
  }

#' Factory for a NORMAL distribution object
#'
#' Returns a NORMAL distribution object that produce random numbers
#' from a normal distribution using the \code{\link{rnorm}} function
#' @author John J. Aponte
#' @param p_mean A numeric that represents the mean value
#' @param p_sd A numeric that represents the standard deviation
#' @param p_dimnames A character that represents the name of the dimension
#' @return An object of class \code{\link{DISTRIBUTION}}, \code{NORMAL}
#' @importFrom stats rnorm
#' @export
#' @examples
#' myDistr <- new_NORMAL(0,1)
#' myDistr$rfunc(10)
#' @name NORMAL
new_NORMAL <- function(p_mean, p_sd, p_dimnames = "rvar") {
  stopifnot(length(p_mean) == 1)
  stopifnot(length(p_sd) == 1)
  stopifnot(length(p_dimnames) == 1)
  stopifnot(p_sd >= 0)
  .oval = p_mean
  names(.oval) <- p_dimnames
  structure(
    list(
      distribution = "NORMAL",
      seed = sample(1:2 ^ 15, 1),
      oval = .oval,
      rfunc = restrict_environment(function(n) {
        matrix(rnorm(n, p_mean, p_sd),
               ncol = 1,
               dimnames = list(1:n, p_dimnames))
      },
      p_mean = p_mean, p_sd = p_sd, p_dimnames = p_dimnames)
    ),
    class = c("NORMAL", "DISTRIBUTION")
  )
}

#' Factory for a UNIFORM distribution object
#'
#' Returns an UNIFORM distribution object that produce random numbers
#' from a  uniform distribution using the \code{\link{runif}} function
#' @author John J. Aponte
#' @param p_min A numeric that represents the lower limit
#' @param p_max A numeric that represents the upper limit
#' @param p_dimnames A character that represents the name of the dimension
#' @return An object of class \code{DISTRIBUTION}, \code{UNIFORM}
#' @importFrom stats runif
#' @export
#' @examples
#' myDistr <- new_UNIFORM(0,1)
#' myDistr$rfunc(10)
#' @name UNIFORM
new_UNIFORM <- function(p_min, p_max, p_dimnames = "rvar") {
  stopifnot(p_min <= p_max)
  .oval = (p_max + p_min)/2
  names(.oval) <- p_dimnames
  structure(
    list(
      distribution = "UNIFORM",
      seed = sample(1:2 ^ 15, 1),
      oval = .oval,
      rfunc = restrict_environment(function(n) {
        matrix(runif(n, p_min, p_max),
               ncol = 1,
               dimnames = list(1:n, p_dimnames))
      },
      p_min = p_min, p_max = p_max, p_dimnames = p_dimnames)
    ),
    class = c("UNIFORM", "DISTRIBUTION")
  )
}


#' Factory for a BETA distribution object
#'
#' Returns an BETA distribution object that produce random numbers
#' from a  beta distribution using the \code{\link{rbeta}} function
#' @author John J. Aponte
#' @param p_shape1 non-negative parameters of the Beta distribution
#' @param p_shape2 non-negative parameters of the Beta distribution
#' @param p_dimnames A character that represents the name of the dimension
#' @return An object of class \code{DISTRIBUTION}, \code{BETA}
#' @importFrom stats rbeta
#' @export
#' @examples
#' myDistr <- new_BETA(1,1)
#' myDistr$rfunc(10)
#' @name BETA
new_BETA <- function(p_shape1, p_shape2, p_dimnames = "rvar") {
  .oval = p_shape1 / (p_shape1 + p_shape2)
  names(.oval) <- p_dimnames
  structure(
    list(
      distribution = "BETA",
      seed = sample(1:2 ^ 15, 1),
      oval = .oval,
      rfunc = restrict_environment(function(n) {
        matrix(rbeta(n, p_shape1, p_shape2),
               ncol = 1,
               dimnames = list(1:n,p_dimnames))
      },
      p_shape1 = p_shape1, p_shape2 = p_shape2, p_dimnames = p_dimnames)
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
#' @export
#' @examples
#' myDistr <- new_BETA_lci(0.30,0.25,0.35)
#' myDistr$rfunc(10)
#' @describeIn BETA Constructor based on confidence intervals. Preserve expected value.
new_BETA_lci <- function(p_mean, p_lci, p_uci, p_dimnames = "rvar") {
  stopifnot(p_lci < p_uci)
  stopifnot(p_lci < p_mean & p_mean < p_uci)
  stopifnot(0 < p_mean & p_mean < 1)
  stopifnot(0 <= p_lci & p_lci < 1)
  stopifnot(0 < p_uci & p_uci <= 1)
  fitval <- fitbeta(p_mean, p_lci, p_uci)
  new_BETA(fitval["shape1"],fitval["shape2"], p_dimnames = p_dimnames)
}

#' @note
#' new_BETA_lci2 estimate parameters using maximum likelihood
#' myDistr <- new_BETA_lci2(0.30,0.25,0.35)
#' myDistr$rfunc(10)
#' @export
#' @describeIn BETA Constructor based on ML confidence intervals
new_BETA_lci2 <- function(p_mean, p_lci, p_uci, p_dimnames = "rvar") {
  stopifnot(p_lci < p_uci)
  stopifnot(p_lci < p_mean & p_mean < p_uci)
  stopifnot(0 < p_mean & p_mean < 1)
  stopifnot(0 <= p_lci & p_lci < 1)
  stopifnot(0 < p_uci & p_uci <= 1)
  # Using maximum likelihood fiting from rriskDistributions
  fitval <- fitbeta_ml(p_mean, p_lci, p_uci)
  new_BETA(fitval["shape1"],fitval["shape2"], p_dimnames = p_dimnames)
}


#' Factory for a TRIANGULAR distribution object
#'
#' Returns an TRIANGULAR distribution object that produce random numbers
#' from a  triangular distribution using the \code{\link[extraDistr]{rtriang}}
#' function
#' @author John J. Aponte
#' @param p_min A numeric that represents the lower limit
#' @param p_max A numeric that represents the upper limit
#' @param p_mode A numeric that represents the mode
#' @param p_dimnames A character that represents the name of the dimension
#' @return An object of class \code{DISTRIBUTION}, \code{TRIANGULAR}
#' @importFrom extraDistr rtriang
#' @export
#' @examples
#' myDistr <- new_TRIANGULAR(-1,1,0)
#' myDistr$rfunc(10)
#' @name TRIANGULAR
new_TRIANGULAR <- function(p_min, p_max, p_mode, p_dimnames = "rvar") {
  stopifnot(p_min < p_max)
  stopifnot(p_min <= p_mode & p_mode <= p_max)
  .oval = (p_min + p_max + p_mode) / 3
  names(.oval) <- p_dimnames
  structure(
    list(
      distribution = "TRIANGULAR",
      seed = sample(1:2 ^ 15, 1),
      oval = .oval,
      rfunc = restrict_environment(
        function(n) {
          matrix(rtriang(n, a, b, c),
                 ncol = 1,
                 dimnames = list(1:n, p_dimnames))
        },
        a = p_min,
        b = p_max,
        c = p_mode,
        p_dimnames = p_dimnames
      )
    ),
    class = c("TRIANGULAR", "DISTRIBUTION")
  )
}


#' Factory for a POISSON distribution using confidence intervals
#'
#' Returns an POISSON distribution object that produce random numbers
#' from a Poisson distribution using the \code{\link{rpois}} function
#' @author John J. Aponte
#' @param p_lambda A numeric that represents the expected number of events
#' @param p_dimnames A character that represents the name of the dimension
#' @return An object of class \code{DISTRIBUTION}, \code{POISSON}
#' @importFrom stats rpois
#' @export
#' @examples
#' myDistr <- new_POISSON(5)
#' myDistr$rfunc(10)
#' @name POISSON
new_POISSON <- function(p_lambda, p_dimnames = "rvar") {
  stopifnot(p_lambda > 0)
  .oval = p_lambda
  names(.oval) = "rvar"
  structure(
    list(
      distribution = "POISSON",
      seed = sample(1:2 ^ 15, 1),
      oval = .oval,
      rfunc = restrict_environment(function(n) {
        matrix(rpois(n, p_lambda),
               ncol = 1,
               dimnames = list(1:n, p_dimnames))
      },
      p_lambda = p_lambda, p_dimnames = p_dimnames)
    ),
    class = c("POISSON", "DISTRIBUTION")
  )
}


#' Factory for a EXPONENTIAL distribution using confidence intervals
#'
#' Returns an EXPONENTIAL distribution object that produce random numbers
#' from an exponential distribution using the \code{\link{rexp}} function
#' @author John J. Aponte
#' @param p_rate A numeric that represents the rate of events
#' @param p_dimnames A character that represents the name of the dimension
#' @return An object of class \code{DISTRIBUTION}, \code{EXPONENTIAL}
#' @importFrom stats rexp
#' @export
#' @examples
#' myDistr <- new_EXPONENTIAL(5)
#' myDistr$rfunc(10)
#' @name EXPONENTIAL
new_EXPONENTIAL <- function(p_rate, p_dimnames = "rvar") {
  stopifnot(p_rate >= 0)
  .oval = 1/p_rate
  names(.oval) <- p_dimnames
  structure(
    list(
      distribution = "EXPONENTIAL",
      seed = sample(1:2 ^ 15, 1),
      oval = .oval,
      rfunc = restrict_environment(function(n) {
        matrix(rexp(n, p_rate),
               ncol = 1,
               dimnames = list(1:n, p_dimnames))
      },
      p_rate = p_rate, p_dimnames = p_dimnames)
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
#' @author John J. Aponte
#' @param p_supp A numeric vector of options
#' @param p_prob A numeric vector of probabilities.
#' @param p_dimnames A character that represents the name of the dimension
#' @return An object of class \code{DISTRIBUTION}, \code{DISCRETE}
#' @export
#' @examples
#' myDistr <- new_DISCRETE(p_supp=c(1,2,3,4), p_prob=c(0.40,0.30,0.20,0.10))
#' myDistr$rfunc(10)
#' @name DISCRETE
new_DISCRETE <- function(p_supp, p_prob, p_dimnames = "rvar") {
  if (missing(p_prob)) {
    p_prob = rep(1 / length(p_supp), length(p_supp))
  }
  stopifnot(missing(p_prob)  | length(p_supp) == length(p_prob))
  stopifnot(abs(1 - sum(p_prob)) < 1 ^ 0.4)
  .oval = sum(p_supp * p_prob)
  names(.oval) <- p_dimnames
  structure(
    list(
      distribution = "DISCRETE",
      seed = sample(1:2 ^ 15, 1),
      oval = .oval,
      rfunc = restrict_environment(function(n) {
        matrix(
          sample(p_supp, n, replace = TRUE, prob = p_prob),
          ncol = 1,
          dimnames = list(1:n, p_dimnames)
        )
      },
      p_supp = p_supp, p_prob = p_prob, p_dimnames = p_dimnames)
    ),
    class = c("DISCRETE", "DISTRIBUTION")
  )
}

#' Factory for a NA distribution object
#'
#' Returns an NA distribution object that always return \code{NA_real_}
#' This is useful to handle \code{NA}.
#' By default only one dimension \code{rvar} is produced, but if several
#' names are provided more columns will be added to the return matrix
#' @author John J. Aponte
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
#' @author John J. Aponte
#' @param p_scalar A numeric that set the value for the distribution
#' @return An object of class \code{DISTRIBUTION}, \code{DIRAC}
#' @param p_dimnames A character that represents the name of the dimension
#' @export
#' @examples
#' myDistr <- new_DIRAC(1)
#' myDistr$rfunc(10)
#' @name DIRAC
new_DIRAC <- function(p_scalar, p_dimnames = "rvar") {
  stopifnot(length(p_scalar) == 1)
  .oval = p_scalar
  names(.oval) <- p_dimnames
  structure(
    list(
      distribution = "DIRAC",
      seed = sample(1:2 ^ 15, 1),
      oval = .oval,
      rfunc = restrict_environment(function(n) {
        matrix(rep(p_scalar, n),
               ncol = 1,
               dimnames = list(1:n, p_dimnames))
      },
      p_scalar = p_scalar, p_dimnames = p_dimnames)
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
#' careful as the \code{oval} field is not changed and may not represent
#' any more the expected value of the distribution.
#'
#' If the distribution is multidimensional, the limits will apply to all dimensions.
#' @author John J. Aponte
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
#' Returns an \code{DIRICHLET} distribution object that draw random numbers
#' generated by the function \code{\link[extraDistr]{rdirichlet}}
#'
#'A name can be provided for the dimensions. Otherwise \code{rvar1},
#'\code{rvar2}, ..., \code{rvark} will be assigned
#'
#' @author John J. Aponte
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
        with0 <- which(p_alpha == 0)
        if (length(with0) == 0) {
          res <- rdirichlet(n, p_alpha)
          colnames(res) <- p_dimnames
          res
        } 
        else {
          new_alpha = p_alpha[-with0]
          new_colname = p_dimnames[-with0]
          cero_colname = p_dimnames[with0]
          if ( length(new_alpha) == 1) {
            resmat <- matrix(rep(1,n), ncol = 1)
          } else {
            resmat <- rdirichlet(n, new_alpha)
          }
          zeromat <- matrix(rep(0,n*length(cero_colname)), ncol = length(cero_colname))
          res <- cbind(resmat, zeromat)
          colnames(res) <- c(new_colname, cero_colname)
          res[,p_dimnames]
        }
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
#' from a log normal distribution using the \code{\link{rlnorm}} function
#' @author John J. Aponte
#' @param p_meanlog mean of the distribution on the log scale
#' @param p_sdlog A numeric that represents the standard deviation on the log scale
#' @param p_dimnames A character that represents the name of the dimension
#' @return An object of class \code{\link{DISTRIBUTION}}, \code{LOGNORMAL}
#' @importFrom stats rnorm
#' @export
#' @examples
#' myDistr <- new_LOGNORMAL(0,1)
#' myDistr$rfunc(10)
#' @name LOGNORMAL
new_LOGNORMAL <- function(p_meanlog, p_sdlog, p_dimnames = "rvar") {
  .oval =  p_meanlog + (p_sdlog^2)/2
  names(.oval) <- "rvar"
  structure(
    list(
      distribution = "LOGNORMAL",
      seed = sample(1:2 ^ 15, 1),
      oval = .oval, 
      rfunc = restrict_environment(function(n) {
        matrix(rlnorm(n, p_meanlog, p_sdlog),
               ncol = 1,
               dimnames = list(1:n, p_dimnames))
      },
      p_meanlog = p_meanlog, p_sdlog = p_sdlog, p_dimnames = p_dimnames)
    ),
    class = c("LOGNORMAL", "DISTRIBUTION")
  )
}


#' Factory for a BINOMIAL distribution object
#'
#' Returns a BINOMIAL distribution object that produce random numbers
#' from a binomial distribution using the \code{\link{rbinom}} function
#' @author John J. Aponte
#' @param p_size integer that represent the number of trials
#' @param p_prob probability of success
#' @param p_dimnames A character that represents the name of the dimension
#' @return An object of class \code{\link{DISTRIBUTION}}, \code{BINOMIAL}
#' @importFrom stats rnorm
#' @export
#' @examples
#' myDistr <- new_BINOMIAL(1000,0.3)
#' myDistr$rfunc(10)
#' @name BINOMIAL
#' 
new_BINOMIAL <- function(p_size, p_prob, p_dimnames = "rvar") {
  stopifnot(p_size >= 0)
  stopifnot(trunc(p_size) == p_size)
  stopifnot(0 <= p_prob & p_prob <= 1 )
  .oval =  p_size*p_prob
  names(.oval) <- p_dimnames
  structure(
    list(
      distribution = "BINOMIAL",
      seed = sample(1:2 ^ 15, 1),
      oval = .oval,
      rfunc = restrict_environment(function(n) {
        matrix(rbinom(n, p_size, p_prob),
               ncol = 1,
               dimnames = list(1:n, p_dimnames))
      },
      p_size = p_size, p_prob = p_prob, p_dimnames = p_dimnames)
    ),
    class = c("BINOMIAL", "DISTRIBUTION")
  )
}

# new_BINOMIAL = DISTRIBUTION_factory("BINOMIAL", rbinom, function(){prob*size})

#' Multivariate Normal Distribution
#' 
#' Return a \code{\link{DISTRIBUTION}} object that draw random numbers from a 
#' multivariate normal distribution using the \code{\link[MASS]{mvrnorm}} function.
#' 
#' @author John J. Aponte
#' @param p_mu a vector of means
#' @param p_sigma a positive-definite symmetric matrix for the covariance matrix
#' @param p_dimnames A character that represents the name of the dimension 
#' @param tol tolerance (relative to largest variance) for numerical lack of positive-definiteness in p_sigma.
#' @param empirical logical. If true, mu and Sigma specify the empirical not population mean and covariance matrix.
#' @importFrom MASS mvrnorm
#' @export
#' @seealso \code{\link[MASS]{mvrnorm}}
#' @examples 
#' msigma <- matrix(c(1,0,0,1), ncol=2)
#' d1 <- new_MULTINORMAL(c(0,1), msigma)
#' rfunc(d1, 10)
new_MULTINORMAL <-
  function(p_mu,
           p_sigma,
           p_dimnames,
           tol = 1e-6,
           empirical = FALSE) {
    if (missing(p_dimnames)) {
      p_dimnames = paste("rvar", 1:length(p_mu), sep = "")
    }
    
    stopifnot(ncol(p_sigma) == length(p_mu))
    stopifnot(isSymmetric.matrix(p_sigma))
    .oval = p_mu
    names(.oval) <- p_dimnames
    structure(
      list(
        distribution = "MULTINORMAL",
        seed = sample(1:2 ^ 15, 1),
        oval = .oval,
        rfunc = restrict_environment(
          function(n) {
            res <- mvrnorm(n, p_mu, p_sigma, tol, empirical)
            dimnames(res) <- list(1:n, p_dimnames)
            res
          },
          p_mu = p_mu,
          p_sigma = p_sigma,
          tol = tol,
          empirical = empirical,
          p_dimnames = p_dimnames
        )
      ),
      class = c("MULTINORMAL", "DISTRIBUTION")
    )
  }
