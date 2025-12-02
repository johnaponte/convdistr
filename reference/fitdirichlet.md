# Fits a Dirichlet distribution,

Fits a Dirichlet distribution based on the parameters of Beta
distributions

## Usage

``` r
fitdirichlet(..., plotBeta = FALSE, n.fitted = "opt")
```

## Arguments

- ...:

  named vectors with the distribution parameters shape1, shape2

- plotBeta:

  if TRUE a ggplot of the densities are plotted

- n.fitted:

  Method to fit the values

## Value

a vector with the parameters for a Dirichlet distribution

## Details

Each one of the arguments is a named vector with values for shape1,
shape2. Values from
[`fitbeta`](htinstatps://johnaponte.github.io/convdistr/reference/fitbeta.md)
are suitable for this. This is a wrap of
[`fitDirichlet`](https://rdrr.io/pkg/SHELF/man/fitDirichlet.html)

## See also

[`fitDirichlet`](https://rdrr.io/pkg/SHELF/man/fitDirichlet.html)

## Author

John J. Aponte

## Examples

``` r
a <- fitbeta(0.3, 0.2, 0.4)
c <- fitbeta(0.2, 0.1, 0.3)
b <- fitbeta(0.5, 0.4, 0.6)
fitdirichlet(cat1=a,cat2=b,cat3=c)
#>     cat1     cat2     cat3 
#> 24.70347 41.17246 16.46898 
```
