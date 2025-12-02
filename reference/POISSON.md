# Factory for a POISSON distribution using confidence intervals

Returns an POISSON distribution object that produce random numbers from
a Poisson distribution using the
[`rpois`](https://rdrr.io/r/stats/Poisson.html) function

## Usage

``` r
new_POISSON(p_lambda, p_dimnames = "rvar")
```

## Arguments

- p_lambda:

  A numeric that represents the expected number of events

- p_dimnames:

  A character that represents the name of the dimension

## Value

An object of class `DISTRIBUTION`, `POISSON`

## Author

John J. Aponte

## Examples

``` r
myDistr <- new_POISSON(5)
myDistr$rfunc(10)
#>    rvar
#> 1     2
#> 2     3
#> 3     9
#> 4    10
#> 5     6
#> 6     8
#> 7    10
#> 8     1
#> 9     4
#> 10    6
```
