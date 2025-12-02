# Factory for a TRIANGULAR distribution object

Returns an TRIANGULAR distribution object that produce random numbers
from a triangular distribution using the
[`rtriang`](https://rdrr.io/pkg/extraDistr/man/Triangular.html) function

## Usage

``` r
new_TRIANGULAR(p_min, p_max, p_mode, p_dimnames = "rvar")
```

## Arguments

- p_min:

  A numeric that represents the lower limit

- p_max:

  A numeric that represents the upper limit

- p_mode:

  A numeric that represents the mode

- p_dimnames:

  A character that represents the name of the dimension

## Value

An object of class `DISTRIBUTION`, `TRIANGULAR`

## Author

John J. Aponte

## Examples

``` r
myDistr <- new_TRIANGULAR(-1,1,0)
myDistr$rfunc(10)
#>          rvar
#> 1   0.4137550
#> 2   0.3850449
#> 3   0.2022058
#> 4  -0.7947166
#> 5   0.2265540
#> 6   0.8420505
#> 7  -0.4430813
#> 8  -0.1340369
#> 9   0.6002895
#> 10  0.2747273
```
