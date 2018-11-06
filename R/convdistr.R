#' convdistr: A package usefull for convolution of distributions.
#' 
#' The convdistr provides tools to definde distribution objects and make 
#' mathematical operations with them. It keep track of the results as if they
#' where scalar numbers but mantain the ability to obtain randoms samples of
#' the convoluted distributions.
#' 
#' @docType package
#' @name convdistr
NULL

utils::globalVariables(c("a","b","p_function","rfuncs","dimension","value","cols","rfunc1","rfunc2"))
