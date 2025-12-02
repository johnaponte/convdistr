# Factory for a BETA distribution object

Returns an BETA distribution object that produce random numbers from a
beta distribution using the [`rbeta`](https://rdrr.io/r/stats/Beta.html)
function

## Usage

``` r
new_BETA(p_shape1, p_shape2, p_dimnames = "rvar")

new_BETA_lci(p_mean, p_lci, p_uci, p_dimnames = "rvar")

new_BETA_lci2(p_mean, p_lci, p_uci, p_dimnames = "rvar")
```

## Arguments

- p_shape1:

  non-negative parameters of the Beta distribution

- p_shape2:

  non-negative parameters of the Beta distribution

- p_dimnames:

  A character that represents the name of the dimension

- p_mean:

  A numeric that represents the expected value of the proportion

- p_lci:

  A numeric for the lower 95% confidence interval

- p_uci:

  A numeric for the upper 95% confidence interval

## Value

An object of class `DISTRIBUTION`, `BETA`

## Functions

- `new_BETA_lci()`: Constructor based on confidence intervals. Preserve
  expected value.

- `new_BETA_lci2()`: Constructor based on ML confidence intervals

## Note

When using confidence intervals, the shape parameters are obtained using
the following formula:

\\varp = (p_uci-p_lci)/4^2\\

\\shape1 = p_mean \* (p_mean \* (1 - p_mean) / varp - 1)\\

\\shape2 =(1 - p_mean) \* (p_mean \* (1 - p_mean) / varp - 1) \\

new_BETA_lci2 estimate parameters using maximum likelihood myDistr \<-
new_BETA_lci2(0.30,0.25,0.35) myDistr\$rfunc(10)

## Author

John J. Aponte

## Examples

``` r
myDistr <- new_BETA(1,1)
myDistr$rfunc(10)
#>          rvar
#> 1  0.84279156
#> 2  0.53360650
#> 3  0.71023276
#> 4  0.22747849
#> 5  0.82505937
#> 6  0.67961427
#> 7  0.80433017
#> 8  0.93633854
#> 9  0.02445216
#> 10 0.32161957
myDistr <- new_BETA_lci(0.30,0.25,0.35)
myDistr$rfunc(10)
#>         rvar
#> 1  0.2510281
#> 2  0.3148597
#> 3  0.2428678
#> 4  0.2852765
#> 5  0.2985150
#> 6  0.3157819
#> 7  0.2738824
#> 8  0.3135334
#> 9  0.3104217
#> 10 0.2618385
```
