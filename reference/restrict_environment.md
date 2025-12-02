# Build a new function with a smaller environment

As standard feature, R include in the environment of a function all the
variables that are available when the function is created. This, however
is prompt to leak reference when you have a factory of function and they
are created within a list.. it will include all the component of the
list in the function environment. To prevent that, the random generator
functions are encapsulated with a restricted environment where only the
variables that the function requires to work are included

## Usage

``` r
restrict_environment(f, ...)
```

## Arguments

- f:

  input function

- ...:

  define the set of variables to be included as variable = value.

## Value

new function with a restricted environment

## Author

John J. Aponte

## Examples

``` r
a = 0
b = 1
myfunc <- restrict_environment(
 function(n) {
   rnorm(meanvalue, sdvalue)
 },
 meanvalue = a, sdvalue = b)

myfunc(10)
#> numeric(0)
ls(envir=environment(myfunc))
#> [1] "meanvalue" "sdvalue"  
```
