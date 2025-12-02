# Factory for a NA distribution object

Returns an NA distribution object that always return `NA_real_` This is
useful to handle `NA`. By default only one dimension `rvar` is produced,
but if several names are provided more columns will be added to the
return matrix

## Usage

``` r
new_NA(p_dimnames = "rvar")
```

## Arguments

- p_dimnames:

  A character that represents the the names of the dimensions. By
  default only one dimension with name `rvar`

## Value

An object of class `DISTRIBUTION`, `NA`

## Author

John J. Aponte

## Examples

``` r
myDistr <- new_NA(p_dimnames = "rvar")
myDistr$rfunc(10)
#>    rvar
#> 1    NA
#> 2    NA
#> 3    NA
#> 4    NA
#> 5    NA
#> 6    NA
#> 7    NA
#> 8    NA
#> 9    NA
#> 10   NA
```
