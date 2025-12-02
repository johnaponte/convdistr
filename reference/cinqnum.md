# cinqnum

Produce 5 numbers of the distribution (mean\_, sd\_, lci\_, uci\_,
median\_).

## Usage

``` r
cinqnum(x, ...)

# S3 method for class 'DISTRIBUTION'
cinqnum(x, n, ...)

# S3 method for class '`NA`'
cinqnum(x, n, ...)

# S3 method for class 'DIRAC'
cinqnum(x, n, ...)
```

## Arguments

- x:

  an object of class
  [`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md)

- ...:

  further parameters

- n:

  number of drawns

## Value

a vector with the mean, sd, lci, uci and median values

## Details

Uses the stored seed to have the same sequence always and produce the
same numbers This is an internal function for the summary function

## Methods (by class)

- `cinqnum(DISTRIBUTION)`: Generic method for a DISTRIBUTION

- `` cinqnum(`NA`) ``: Generic method for optimized for a NA
  distribution

- `cinqnum(DIRAC)`: Generic method optimized for a DIRAC distribution

## Author

John J. Aponte
