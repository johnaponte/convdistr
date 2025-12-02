# Summary of Distributions

Summary of Distributions

## Usage

``` r
# S3 method for class 'DISTRIBUTION'
summary(object, n = 10000, ...)
```

## Arguments

- object:

  object of class
  [`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md)

- n:

  the number of random samples from the distribution

- ...:

  other parameters. Not used

## Value

A [`data.frame`](https://rdrr.io/r/base/data.frame.html) with as many
rows as dimensions had the distribution and with the following columns

- distribution name

- varname name of the dimension

- oval value

- nsample number of random samples

- mean\_ mean value of the sample

- sd\_ standard deviation of the sample

- lci\_ lower 95

- median\_ median value of the sample

- uci\_ upper 95

## Note

The sample uses the seed saved in the object those it will provide the
same values fir an `n` value

## Author

John J. Aponte
