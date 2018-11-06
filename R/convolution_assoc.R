# Convulutuion and asociation of dimensions
# 20181106 by JJAV
# # # # # # # # # # # # # # # # # # # # # # #

#' Convolution with asociation of dimensions
#' 
#' In case of different dimnesions of the distribution
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
