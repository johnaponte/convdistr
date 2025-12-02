# plot of [`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md) objects

Plot an histogram of the density of the distribution using random
numbers from the distribution

## Usage

``` r
# S3 method for class 'DISTRIBUTION'
plot(x, n = 10000, ...)
```

## Arguments

- x:

  an object of class
  [`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md)

- n:

  number of observations

- ...:

  other parameters to the [`hist`](https://rdrr.io/r/graphics/hist.html)
  function

## Value

No return value. Side effect plot the histogram.

## Examples

``` r
x <- new_NORMAL(0,1)
plot(x)

y <- new_DIRICHLET(c(10,20,70))
plot(x) 
```
