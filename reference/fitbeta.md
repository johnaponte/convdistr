# Fits a beta distribution based on quantiles

Fits a beta distribution based on quantiles

## Usage

``` r
fitbeta_ml(point, lci, uci)

fitbeta(point, lci, uci)
```

## Arguments

- point:

  Point estimates corresponding to the median

- lci:

  Lower limit (quantile 0.025)

- uci:

  Upper limit (quantile 0.975)

## Value

parameters shape1 and shape2 of a beta distribution

## Functions

- `fitbeta_ml()`: using ML to estimate parameters

- `fitbeta()`: preserve the expected value

## Note

This is a wrap of the
[`fitdist`](https://rdrr.io/pkg/SHELF/man/fitdist.html) to obtain the
best parameters for a beta distribution based on quantiles.

When using confidence intervals (not ML), the shape parameters are
obtained using the following formula:

\\varp = (p_uci-p_lci)/4^2\\

\\shape1 = p_mean \* (p_mean \* (1 - p_mean) / varp - 1)\\

\\shape2 =(1 - p_mean) \* (p_mean \* (1 - p_mean) / varp - 1) \\

## See also

[`fitdist`](https://rdrr.io/pkg/SHELF/man/fitdist.html)

## Author

John J. Aponte

## Examples

``` r
fitbeta_ml(0.45,0.40,0.50)
#>   shape1   shape2 
#> 170.5639 208.4047 
fitbeta(0.45,0.40,0.50)
#> shape1 shape2 
#> 177.75 217.25 
```
