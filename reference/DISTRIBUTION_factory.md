# A factory of [`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md) classes

Generate a function that creates
[`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md)
objects

## Usage

``` r
DISTRIBUTION_factory(distname, rfunction, ovalfunc)
```

## Arguments

- distname:

  name of the distribution. By convention they are upper case

- rfunction:

  a function to generate random numbers from the distribution

- ovalfunc:

  a function that calculate the oval value, should used only the same
  arguments that the `rfunction`

## Value

A function that is able to create
[`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md)
objects.

## Note

The function return a new function, that have as arguments the formals
of the `rfunction` plus a new argument `dimnames` for the dimension
names. If The distribution is unidimensional, the default value
` dimnames = "rvar"` will works well, but if not, the `dimnames`
argument should be specified when the generated function is used as in
the example for the `new_MyDIRICHLET`

## Author

John J. Aponte

## Examples

``` r
new_MYDISTR <- DISTRIBUTION_factory("MYDISTR", rnorm, function(){mean})
d1 <- new_MYDISTR(0,1)
summary(d1)
#>   distribution varname oval nsample       mean_       sd_      lci_
#> 1      MYDISTR    rvar    0   10000 -0.01058721 0.9829487 -1.921243
#>        median_     uci_
#> 1 -0.006960662 1.925305
require(extraDistr)
#> Loading required package: extraDistr
new_MyDIRICHLET <- DISTRIBUTION_factory('rdirichlet',
                       rdirichlet,
                       function() {
                         salpha = sum(alpha)
                         alpha / salpha
                       })
d2 <- new_MyDIRICHLET(c(10, 20, 70), dimnames = c("A", "B", "C"))
summary(d2)
#>   distribution varname oval nsample     mean_        sd_       lci_    median_
#> 1   RDIRICHLET       A  0.1   10000 0.1001997 0.02986391 0.05017346 0.09700138
#> 2   RDIRICHLET       B  0.2   10000 0.1993013 0.04012581 0.12676269 0.19697212
#> 3   RDIRICHLET       C  0.7   10000 0.7004990 0.04569202 0.60742357 0.70139104
#>        uci_
#> 1 0.1652445
#> 2 0.2842441
#> 3 0.7865767
```
