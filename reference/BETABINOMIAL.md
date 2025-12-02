# Factory for a BETABINOMIAL distribution object

Returns an BETABINOMIAL distribution object that produce random numbers
from a betabinomial distribution using the
[`rbbinom`](https://rdrr.io/pkg/extraDistr/man/BetaBinom.html) function

## Usage

``` r
new_BETABINOMIAL(p_size, p_shape1, p_shape2, p_dimnames = "rvar")

new_BETABINOMIAL_od(p_size, p_mu, p_od, p_dimnames = "rvar")

new_BETABINOMIAL_icc(p_size, p_mu, p_icc, p_dimnames = "rvar")
```

## Arguments

- p_size:

  a non-negative parameter for the number of trials

- p_shape1:

  non-negative parameters of the Betabinomial distribution

- p_shape2:

  non-negative parameters of the Betabinomial distribution

- p_dimnames:

  A character that represents the name of the dimension

- p_mu:

  mean proportion for the binomial part of the distribution

- p_od:

  over dispersion parameter

- p_icc:

  intra-class correlation parameter

## Value

An object of class `DISTRIBUTION`, `BETADISTRIBUION`

## Functions

- `new_BETABINOMIAL_od()`: parametrization based on dispersion

- `new_BETABINOMIAL_icc()`: parametrization based on intra-class
  correlation

## Note

There are several parametrization for the betabinomial distribution. The
one based on shape1 and shape2 are parameters alpha and beta of the beta
part of the distribution, but it can be parametrized as mu, and od where
mu is the expected mean proportion and od is a measure of the
overdispersion.

\\p_mu = p_shape1/(p_shape1 + p_shape2)\\

\\p_od = p_shape1 + p_shape2\\

\\p_shape1 = p_mu\*p_od\\

\\p_shape2 \<- (1-p_mu)\*p_od\\

Another parametrization is based on mu and the icc where mu is the mean
proportion and icc is the intra-class correlation.

\\p_mu = p_shape1/(p_shape1 + p_shape2)\\

\\p_icc = 1/(p_shape1 + p_shape2 + 1)\\

\\p_shape1 = p_mu\*(1-p_icc)/p_icc\\

\\p_shape2 = (1-p_mu)\*(1-p_icc)/p_icc\\

## Author

John J. Aponte

## Examples

``` r
myDistr <- new_BETABINOMIAL(10,1,1)
myDistr$rfunc(10)
#>    rvar
#> 1     7
#> 2     8
#> 3     3
#> 4     9
#> 5     8
#> 6     7
#> 7     4
#> 8     8
#> 9     8
#> 10    5
```
