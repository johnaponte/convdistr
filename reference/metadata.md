# Metadata for a DISTRIBUTION

Shows the distribution and the oval values of a
[`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md)
object

## Usage

``` r
metadata(x)

# S3 method for class 'DISTRIBUTION'
metadata(x)

# Default S3 method
metadata(x)
```

## Arguments

- x:

  a
  [`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md)
  object

## Value

A [`data.frame`](https://rdrr.io/r/base/data.frame.html) with the
metadata of the distributions

## Methods (by class)

- `metadata(DISTRIBUTION)`: Metadata for DISTRIBUTION objects

- `metadata(default)`: Metadata for other objects

## Note

The number of columns depends on the dimensions of the distribution.
There will be one column `distribution` with the name of the
distribution and one column for each dimension with the names from the
`oval` field.

## Author

John J. Aponte
