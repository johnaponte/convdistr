#' convdistr: A package useful for convolution of distributions.
#' 
#' The convdistr package provides tools to define \code{\link{DISTRIBUTION}} objects and make 
#' mathematical operations with them. It keeps track of the results as if they
#' were scalar numbers but maintaining the ability to obtain random samples of
#' the convoluted distributions.
#' 
#' @docType package
#' @name convdistr
NULL

utils::globalVariables(c("a","b","p_function","rfuncs","dimension","value","cols","rfunc1","rfunc2"))
