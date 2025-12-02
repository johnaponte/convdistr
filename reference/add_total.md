# Adds a total dimension

This function returns a
[`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md)
with a new dimension created by row sum of the dimensions of the
distribution.

## Usage

``` r
add_total(p_distribution, p_totalname = "TOTAL")
```

## Arguments

- p_distribution:

  an object of class
  [`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md)

- p_totalname:

  the name of the new dimension

## Value

a
[`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md)

## Details

Only works with multidimensional distributions.

## Author

John J. Aponte

## Examples

``` r
d1 <- new_DIRICHLET(c(0.2,0.5,0.3))
d2 <- add_total(d1)
```
