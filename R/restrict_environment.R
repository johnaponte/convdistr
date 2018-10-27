
#' Build a new funcion with a smaller environment
#'
#' As standard feature, R include in the environment of a function
#' all the variables that are available when the function is created.
#' This, however is prompt to leak refenrencewhen you have a factory
#' of function and they are created within a list.. it will include all
#' the component of the list in the function environment.
#' To prevent that, the random generator functions are encapsulated with a
#' restricted enviroment where only the variables that the function requires
#' to work are included
#'
#' @author  John Aponte
#' @param f input function
#' @param ... define the set of  variables to be included as variable = value.
#' @return new function with a restricted environment
#' @importFrom pryr named_dots
#' @examples
#' a = 0, b= 1
#' myfunc <-
#'  restrict_environment(
#'  function(n) {
#'    rnorm(meanvalue, sdvalue)
#' },
#' meanvalue = a, sdvalue = b)
#'
#' myfunc(10)
#' ls(*, envir=environment(myfunc))
#'
restrict_environment <- function(f, ...) {
  dots <- named_dots(...)
  oldEnv <- environment(f)
  newEnv <- new.env(parent = parent.env(oldEnv))
  values <- lapply(dots,function(x){eval(x, envir = oldEnv)})
  if (length(values) > 0) {
    for (i in 1:length(values)) {
      assign(names(values)[i], values[[i]], envir = newEnv)
    }
  }
  environment(f) <- newEnv
  f
}
