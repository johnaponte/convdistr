# Factory for a BINOMIAL distribution object

Returns a BINOMIAL distribution object that produce random numbers from
a binomial distribution using the
[`rbinom`](https://rdrr.io/r/stats/Binomial.html) function

## Usage

``` r
new_BINOMIAL(p_size, p_prob, p_dimnames = "rvar")
```

## Arguments

- p_size:

  integer that represent the number of trials

- p_prob:

  probability of success

- p_dimnames:

  A character that represents the name of the dimension

## Value

An object of class
[`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md),
`BINOMIAL`

## Author

John J. Aponte

## Examples

``` r
myDistr <- new_BINOMIAL(1000,0.3)
myDistr$rfunc(10)
#>    rvar
#> 1   303
#> 2   294
#> 3   311
#> 4   273
#> 5   298
#> 6   283
#> 7   300
#> 8   288
#> 9   311
#> 10  299
```
