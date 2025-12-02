# Factory for a UNIFORM distribution object

Returns an UNIFORM distribution object that produce random numbers from
a uniform distribution using the
[`runif`](https://rdrr.io/r/stats/Uniform.html) function

## Usage

``` r
new_UNIFORM(p_min, p_max, p_dimnames = "rvar")
```

## Arguments

- p_min:

  A numeric that represents the lower limit

- p_max:

  A numeric that represents the upper limit

- p_dimnames:

  A character that represents the name of the dimension

## Value

An object of class `DISTRIBUTION`, `UNIFORM`

## Author

John J. Aponte

## Examples

``` r
myDistr <- new_UNIFORM(0,1)
myDistr$rfunc(10)
#>         rvar
#> 1  0.7841724
#> 2  0.4903928
#> 3  0.1019510
#> 4  0.9434597
#> 5  0.7061395
#> 6  0.5022642
#> 7  0.5299348
#> 8  0.2584263
#> 9  0.7117534
#> 10 0.9684625
```
