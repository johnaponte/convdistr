# Factory for a NORMAL distribution object

Returns a NORMAL distribution object that produce random numbers from a
normal distribution using the
[`rnorm`](https://rdrr.io/r/stats/Normal.html) function

## Usage

``` r
new_NORMAL(p_mean, p_sd, p_dimnames = "rvar")
```

## Arguments

- p_mean:

  A numeric that represents the mean value

- p_sd:

  A numeric that represents the standard deviation

- p_dimnames:

  A character that represents the name of the dimension

## Value

An object of class
[`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md),
`NORMAL`

## Author

John J. Aponte

## Examples

``` r
myDistr <- new_NORMAL(0,1)
myDistr$rfunc(10)
#>          rvar
#> 1   0.2428887
#> 2   0.1685121
#> 3   0.2390647
#> 4   0.2363214
#> 5  -0.2591192
#> 6   0.6490457
#> 7  -1.2176410
#> 8   0.8419704
#> 9  -1.6192106
#> 10  0.2641659
```
