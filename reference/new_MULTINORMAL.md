# Multivariate Normal Distribution

Return a
[`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md)
object that draw random numbers from a multivariate normal distribution
using the [`mvrnorm`](https://rdrr.io/pkg/MASS/man/mvrnorm.html)
function.

## Usage

``` r
new_MULTINORMAL(p_mu, p_sigma, p_dimnames, tol = 1e-06, empirical = FALSE)
```

## Arguments

- p_mu:

  a vector of means

- p_sigma:

  a positive-definite symmetric matrix for the covariance matrix

- p_dimnames:

  A character that represents the name of the dimension

- tol:

  tolerance (relative to largest variance) for numerical lack of
  positive-definiteness in p_sigma.

- empirical:

  logical. If true, mu and Sigma specify the empirical not population
  mean and covariance matrix.

## Value

An object of class
[`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md),
`MULTINORMAL`

## See also

[`mvrnorm`](https://rdrr.io/pkg/MASS/man/mvrnorm.html)

## Author

John J. Aponte

## Examples

``` r
msigma <- matrix(c(1,0,0,1), ncol=2)
d1 <- new_MULTINORMAL(c(0,1), msigma)
rfunc(d1, 10)
#>          rvar1      rvar2
#> 1   0.67186788  1.1421718
#> 2  -0.19396654 -1.3533226
#> 3   0.38802615  1.6537917
#> 4  -0.06650056  0.8940403
#> 5   0.53464882  1.6754738
#> 6   0.83192028  1.0393404
#> 7   0.15243807  1.1974442
#> 8  -1.49181104  3.3806959
#> 9  -0.29851275  1.3961280
#> 10 -0.06355927 -0.2690588
```
