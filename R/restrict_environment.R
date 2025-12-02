
#' Build a new function with a smaller environment
#'
#' As standard feature, R include in the environment of a function
#' all the variables that are available when the function is created.
#' This, however is prompt to leak reference when you have a factory
#' of function and they are created within a list.. it will include all
#' the component of the list in the function environment.
#' To prevent that, the random generator functions are encapsulated with a
#' restricted environment where only the variables that the function requires
#' to work are included
#'
#' @author  John J. Aponte
#' @param f input function
#' @param ... define the set of  variables to be included as variable = value.
#' @return new function with a restricted environment
#' @export
#' @examples
#' a = 0
#' b = 1
#' myfunc <- restrict_environment(
#'  function(n) {
#'    rnorm(meanvalue, sdvalue)
#'  },
#'  meanvalue = a, sdvalue = b)
#'
#' myfunc(10)
#' ls(envir=environment(myfunc))
#'
restrict_environment <- function(f, ...) {
  ## capture unevaluated ... as a list
  mc   <- match.call(expand.dots = FALSE)
  dots <- mc[["..."]]
  if (is.null(dots)) dots <- list()
  dots <- as.list(dots)
  
  ## auto-name unnamed arguments with their expressions
  nms <- names(dots)
  if (is.null(nms)) nms <- rep("", length(dots))
  missing <- nms == "" | is.na(nms)
  
  if (any(missing)) {
    nms[missing] <- vapply(
      dots[missing],
      function(x) paste(deparse(x, 500L), collapse = ""),
      character(1L)
    )
  }
  names(dots) <- nms
  
  ## build restricted environment
  oldEnv <- environment(f)
  newEnv <- new.env(parent = parent.env(oldEnv))
  
  values <- lapply(dots, eval, envir = oldEnv)
  for (nm in names(values)) {
    assign(nm, values[[nm]], envir = newEnv)
  }
  
  environment(f) <- newEnv
  f
}