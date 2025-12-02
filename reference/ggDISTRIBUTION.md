# Plot of [`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md) objects using [`ggplot2`](https://ggplot2.tidyverse.org/reference/ggplot2-package.html)

Plot of
[`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md)
objects using
[`ggplot2`](https://ggplot2.tidyverse.org/reference/ggplot2-package.html)

## Usage

``` r
ggDISTRIBUTION(x, n = 10000)
```

## Arguments

- x:

  an object of class
  [`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md)

- n:

  number of observation

## Value

a [`ggplot`](https://ggplot2.tidyverse.org/reference/ggplot.html) object
with the density of the distribution

## Examples

``` r
x <- new_NORMAL(0,1)
ggDISTRIBUTION(x)

y <- new_DIRICHLET(c(10,20,70))
ggDISTRIBUTION(x)
```
