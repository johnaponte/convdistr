# Factory for a DISCRETE distribution object

Returns an DISCRETE distribution object that sample from the vector
`p_supp` of options with probability the vector of probabilities
`p_prob`.

## Usage

``` r
new_DISCRETE(p_supp, p_prob, p_dimnames = "rvar")
```

## Arguments

- p_supp:

  A numeric vector of options

- p_prob:

  A numeric vector of probabilities.

- p_dimnames:

  A character that represents the name of the dimension

## Value

An object of class `DISTRIBUTION`, `DISCRETE`

## Note

If the second argument is missing, all options will be sample with equal
probability. If provided, the second argument would add to 1 and must be
the same length that the first argument

## Author

John J. Aponte

## Examples

``` r
myDistr <- new_DISCRETE(p_supp=c(1,2,3,4), p_prob=c(0.40,0.30,0.20,0.10))
myDistr$rfunc(10)
#>    rvar
#> 1     2
#> 2     1
#> 3     1
#> 4     4
#> 5     1
#> 6     3
#> 7     3
#> 8     3
#> 9     2
#> 10    4
```
