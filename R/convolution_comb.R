# Convulutuion and combination of dimensions
# 20181106 by JJAV
# # # # # # # # # # # # # # # # # # # # # # #

#' Convolution with combination of dimensions
#'
#' In case of different dimnesions of the distribution
#' this function perform the operation on the combination of the distributions
#' of both distribution.
#'
#' If distribution A have dimensions a and b and distribution B have dimensions
#' b and c, the A + B would produce a distribution with dimensions
#' a_b,a_c,b_b, b_c
#'
#' @note In case of the same dimensions, only the first combination is taken
#'
#' @param dist1 an object of class \code{\link{DISTRIBUTION}}
#' @param dist2 and object of class \code{\link{DISTRIBUTION}}
#' @param op one of `+`,`-`,`*`,`/`
#' @param p_dimnames a character vector with the name of the dimensions.
#' If missing the combination of the individual dimensions will be used
#'
#' @return an object of class \code{\link{DISTRIBUTION}}
#' @export
new_CONVOLUTION_comb <-
  function(dist1,
           dist2,
           op,
           p_dimnames) {
    if (missing(p_dimnames))
      p_dimnames = NA_character_
    stopifnot(inherits(dist1, "DISTRIBUTION"))
    stopifnot(inherits(dist2, "DISTRIBUTION"))
    dim1 <- dimnames(dist1)
    dim2 <- dimnames(dist2)
    combdf <-
      as.matrix(expand.grid(dim1, dim2, stringsAsFactors = FALSE))
    if (any(is.na(p_dimnames))) {
      p_dimnames = paste(combdf[, 1], combdf[, 2], sep = "_")
    }
    stopifnot(length(p_dimnames) == nrow(combdf))
    .oval <- numeric(nrow(combdf))
    for (i in 1:nrow(combdf)) {
      .oval[i] <- op(dist1$oval[combdf[i, 1]], dist2$oval[combdf[i, 2]])
    }
    names(.oval) <- p_dimnames
    .oval
    .rfunc <- restrict_environment(
      function(n) {
        drawns1 <- rfunc1(n)
        drawns2 <- rfunc2(n)
        res <-
          matrix(op(drawns1[, combdf[1, 1]], drawns2[, combdf[1, 2]]), ncol = 1)
        for (i in 2:nrow(combdf)) {
          res <-
            cbind(res,
                  matrix(op(drawns1[, combdf[i, 1]], drawns2[, combdf[i, 2]]),
                         ncol = 1))
        }
        colnames(res) <- p_dimnames
        res
      },
      p_dimnames = p_dimnames,
      rfunc1 = dist1$rfunc,
      rfunc2 = dist2$rfunc,
      combdf = combdf,
      op = op
    )
    structure(
      list(
        distribution = "CONVOLUTION",
        seed = sample(1:2 ^ 15, 1),
        oval = .oval,
        rfunc = .rfunc
      ),
      class = c("CONVOLUTION", "DISTRIBUTION")
    )
  }

#' Adds a total dimension
#' 
#' This function returns a \code{\link{DISTRIBUTION}} with a new dimension
#' created by the sum of each row of the drawns of the distribution.
#' 
#' Only works with multidimensional distributions.
#' 
#' @param p_distribution an object of class \code{\link{DISTRIBUTION}}
#' @param p_totalname the name of the new dimension
#' @return a \code{\link{DISTRIBUTION}}
#' @export
add_total <- function(p_distribution, p_totalname = "TOTAL") {
  stopifnot(inherits(p_distribution, "DISTRIBUTION"))
  stopifnot(length(p_distribution$oval) > 1)
  stopifnot(!p_totalname %in% names(p_distribution$oval))
  .oval = c(p_distribution$oval, sum(p_distribution$oval))
  names(.oval) <- c(names(p_distribution$oval), p_totalname)
  .rfunc <- restrict_environment(function(n) {
    drawns <- rfunc1(n)
    res <- cbind(drawns, matrix(apply(drawns, 1, sum), ncol = 1))
    colnames(res) <- c(colnames(drawns), p_totalname)
    res
  },
  rfunc1 = p_distribution$rfunc,
  p_totalname = p_totalname)
  structure(
    list(
      distribution = "CONVOLUTION",
      seed = p_distribution$seed,
      oval = .oval,
      rfunc = .rfunc
    ),
    class = c("CONVOLUTION", "DISTRIBUTION")
  )
}
