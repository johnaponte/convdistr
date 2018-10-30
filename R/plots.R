# Graphs for DISTRIBUTION objects
# 20181030 by JJAV
# # # # # # # # # # # # # # # # # #


#' Plot of \code{\link{DISTRIBUTION}} objects using \code{\link[ggplot2]{ggplot2}}
#' 
#' @param x an object of class \code{\link{DISTRIBUTION}}
#' @param n number of drawns
#' @return a \code{\link[ggplot2]{ggplot}} object with the density of the distribution
#' @importFrom tidyr gather
#' @import ggplot2
#' @export
#' @examples 
#' x <- new_NORMAL(0,1)
#' ggDISTRIBUTION(x)
#' y <- new_DIRICHLET(c(10,20,70))
#' ggDISTRIBUTION(x)
ggDISTRIBUTION <- function(x, n = 10000) {
  stopifnot(inherits(x, "DISTRIBUTION"))
  xx <- rfunc(x, n)
  xxdf <- tidyr::gather(data.frame(xx), dimension, value)
  if (ncol(xx) > 1) {
    g <-
      ggplot(xxdf, aes(x = value, stat(density), color = dimension)) +
      geom_histogram(aes(fill = dimension),
                     alpha = 0.4,
                     bins = log10(n) * 7 * ncol(xx)) 
      #geom_freqpoly(bins = log10(n) * 7 * ncol(xx))
  }
  else {
    g <-
      ggplot(xxdf,
             aes(x = value, stat(density))) +
      geom_histogram(alpha = 0.4, bins = log10(n) * 7) 
      #geom_freqpoly(bins = log10(n) * 7)
  }
  g + ggtitle(x$distribution)
}

#' plot of  \code{\link{DISTRIBUTION}} objects
#' 
#' Plot an histogram of the density of the distribution using random
#' drawns from the distribution
#' @param x an object of class \code{\link{DISTRIBUTION}}
#' @param n number of drawns
#' @param ... other parameters to the \code{\link{hist}} function
#' @importFrom RColorBrewer brewer.pal
#' @import graphics 
#' @export
#' @examples
#' x <- new_NORMAL(0,1)
#' plot(x)
#' y <- new_DIRICHLET(c(10,20,70))
#' plot(x) 
plot.DISTRIBUTION <- function(x, n = 10000, ...) {
  distribution <- x
  stopifnot(inherits(distribution, "DISTRIBUTION"))
  xx <- rfunc(distribution, n)
  if (ncol(xx) > 1) {
    cols <- brewer.pal(n = ncol(xx), name = "Set2")
    hist(xx[, 1],
         freq = F,
         breaks = log10(n) * 7,
         col = cols[1], 
         main = distribution$distribution,
         xlab = "Value",
         xlim = c(min(xx),max(xx)), ...)
    for (i in 2:ncol(xx)) {
      hist(xx[, i],
           freq = F,
           breaks = log10(n) * 7,
           col = cols[i],
           add = TRUE)
      
    }
    legend(
      "topright",
      legend = colnames(xx),
      fill = cols,
      title = "dimensions",
      box.lty = 0
    )
  }
  else {
    hist(xx[, 1],
         freq = F, 
         breaks = log10(n) * 7,
         xlim = c(min(xx),max(xx)),
         main = distribution$distribution, 
         xlab = "Value")
  }
}
