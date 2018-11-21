# Convulutuion and association of dimensions
# 20181106 by JJAV
# # # # # # # # # # # # # # # # # # # # # # #

#' Convolution with association of dimensions
#' 
#' In case of different dimensions of the distribution
#' this function perform the operation on the common distributions and
#' add without modifications the other dimensions of the distribution.
#' 
#' If distribution A have dimensions a and b and distribution B have dimensions
#' b and c, the A + B would produce a distribution with dimensions
#' a, c,  b+b, 
#' 
#' @param dist1 an object of class \code{\link{DISTRIBUTION}}
#' @param dist2 and object of class \code{\link{DISTRIBUTION}}
#' @param op one of `+`,`-`,`*`,`/`
#' 
#' @return an object of class \code{\link{DISTRIBUTION}}
#' @export
#' @author John J. Aponte
#' @name CONVOLUTION_assoc
#' @examples
#' x1 <- new_MULTINORMAL(c(0,1), matrix(c(1,0.5,0.5,1),ncol=2), p_dimnames = c("A","B"))
#' x2 <- new_MULTINORMAL(c(10,1), matrix(c(1,0.4,0.4,1),ncol=2), p_dimnames = c("B","C"))
#' new_CONVOLUTION_assoc(x1,x2, `+`)
new_CONVOLUTION_assoc <- function(dist1, dist2, op) {
  stopifnot(inherits(dist1, "DISTRIBUTION"))
  stopifnot(inherits(dist2, "DISTRIBUTION"))
  dim1 <- dimnames(dist1)
  dim2 <- dimnames(dist2)
  inboth <- dim1[dim1 %in% dim2]
  in1 <- dim1[!dim1 %in% dim2]
  in2 <- dim2[!dim2 %in% dim1]
  .oval = c(dist1$oval[in1],
            dist2$oval[in2],
            op(dist1$oval[inboth], dist2$oval[inboth]))
  names(.oval) <- c(in1, in2, inboth)
  .rfunc <- restrict_environment(
    function(n) {
      drawns1 <- rfunc1(n)
      drawns2 <- rfunc2(n)
      res <-
        cbind(drawns1[, in1], drawns2[, in2], op(drawns1[, inboth], drawns2[,inboth]))
      colnames(res) <- c(in1, in2, inboth)
      res
    },
    in1 = in1,
    in2 = in2,
    inboth = inboth,
    rfunc1 = dist1$rfunc,
    rfunc2 = dist2$rfunc,
    op = op
  )
  structure(
    list(
      distribution = "CONVOLUTION",
      seed = sample(1:2^15,1),
      oval = .oval,
      rfunc = .rfunc),
    class = c("CONVOLUTION","DISTRIBUTION"))      
}

#' @describeIn CONVOLUTION_assoc Sum of distributions
#' @export
#' @examples 
#' new_SUM_assoc(x1,x2)
new_SUM_assoc <- function(dist1,dist2) {
  new_CONVOLUTION_assoc(dist1,dist2, `+`)
}


#' @describeIn CONVOLUTION_assoc Subtraction of distributions
#' @export
#' @examples 
#' new_SUBTRACTION_assoc(x1,x2)
new_SUBTRACTION_assoc <- function(dist1,dist2) {
  new_CONVOLUTION_assoc(dist1,dist2, `-`)
}


#' @describeIn CONVOLUTION_assoc Multiplication of distributions
#' @export
#' @examples 
#' new_MULTIPLICATION_assoc(x1,x2)
new_MULTIPLICATION_assoc <- function(dist1,dist2) {
  new_CONVOLUTION_assoc(dist1,dist2, `*`)
}


#' @describeIn CONVOLUTION_assoc Division of distributions
#' @export
#' @examples 
#' new_DIVISION_assoc(x1,x2)
new_DIVISION_assoc <- function(dist1,dist2) {
  new_CONVOLUTION_assoc(dist1,dist2, `/`)
}
