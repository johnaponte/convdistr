# Factory for a EXPONENTIAL distribution using confidence intervals

Returns an EXPONENTIAL distribution object that produce random numbers
from an exponential distribution using the
[`rexp`](https://rdrr.io/r/stats/Exponential.html) function

## Usage

``` r
new_EXPONENTIAL(p_rate, p_dimnames = "rvar")
```

## Arguments

- p_rate:

  A numeric that represents the rate of events

- p_dimnames:

  A character that represents the name of the dimension

## Value

An object of class `DISTRIBUTION`, `EXPONENTIAL`

## Author

John J. Aponte

## Examples

``` r
myDistr <- new_EXPONENTIAL(5)
myDistr$rfunc(10)
#>          rvar
#> 1  0.02999667
#> 2  0.40349996
#> 3  0.01943658
#> 4  0.13100057
#> 5  0.28135111
#> 6  0.14757833
#> 7  0.16936306
#> 8  0.88917583
#> 9  0.10040554
#> 10 0.08760558
```
