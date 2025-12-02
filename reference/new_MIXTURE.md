# Mixture of [`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md) objects

Produce a new distribution that obtain random drawns of the mixture of
the
[`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md)
objects

## Usage

``` r
new_MIXTURE(listdistr, mixture)
```

## Arguments

- listdistr:

  a list of
  [`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md)
  objects

- mixture:

  a vector of probabilities to mixture the distributions. Must add 1 If
  missing the drawns are obtained from the distributions with the same
  probability

## Value

an object of class `MIXTURE`,
[`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md)

## Author

John J. Aponte

## Examples

``` r
x1 <- new_NORMAL(0,1)
x2 <- new_NORMAL(4,1)
x3 <- new_NORMAL(6,1)
new_MIXTURE(list(x1,x2,x3))
#>   distribution     rvar
#> 1      MIXTURE 3.333333
```
