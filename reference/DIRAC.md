# Factory for a DIRAC distribution object

Returns an DIRAC distribution object that always return the same number,
or the same matrix of numbers in case multiple dimensions are setup

## Usage

``` r
new_DIRAC(p_scalar, p_dimnames = "rvar")
```

## Arguments

- p_scalar:

  A numeric that set the value for the distribution

- p_dimnames:

  A character that represents the name of the dimension

## Value

An object of class `DISTRIBUTION`, `DIRAC`

## Author

John J. Aponte

## Examples

``` r
myDistr <- new_DIRAC(1)
myDistr$rfunc(10)
#>    rvar
#> 1     1
#> 2     1
#> 3     1
#> 4     1
#> 5     1
#> 6     1
#> 7     1
#> 8     1
#> 9     1
#> 10    1
```
