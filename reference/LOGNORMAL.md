# Factory for a LOGNORMAL distribution object

Returns a LOGNORMAL distribution object that produce random numbers from
a log normal distribution using the
[`rlnorm`](https://rdrr.io/r/stats/Lognormal.html) function

## Usage

``` r
new_LOGNORMAL(p_meanlog, p_sdlog, p_dimnames = "rvar")
```

## Arguments

- p_meanlog:

  mean of the distribution on the log scale

- p_sdlog:

  A numeric that represents the standard deviation on the log scale

- p_dimnames:

  A character that represents the name of the dimension

## Value

An object of class
[`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md),
`LOGNORMAL`

## Author

John J. Aponte

## Examples

``` r
myDistr <- new_LOGNORMAL(0,1)
myDistr$rfunc(10)
#>         rvar
#> 1  0.3857355
#> 2  0.1545272
#> 3  0.3799659
#> 4  2.2088039
#> 5  6.1412655
#> 6  0.3918122
#> 7  2.3662361
#> 8  1.8619790
#> 9  0.1171462
#> 10 1.6237230
```
