# Convolution with combination of dimensions

In case of different dimensions of the distribution this function
perform the operation on the combination of the distributions of both
distribution.

## Usage

``` r
new_CONVOLUTION_comb(dist1, dist2, op, p_dimnames)

new_SUM_comb(dist1, dist2)

new_SUBTRACTION_comb(dist1, dist2)

new_MULTIPLICATION_comb(dist1, dist2)

new_DIVISION_comb(dist1, dist2)
```

## Arguments

- dist1:

  an object of class
  [`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md)

- dist2:

  and object of class
  [`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md)

- op:

  one of \`+\`,\`-\`,\`\*\`,\`/\`

- p_dimnames:

  a character vector with the name of the dimensions. If missing the
  combination of the individual dimensions will be used

## Value

an object of class
[`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md)

## Details

If distribution A have dimensions a and b and distribution B have
dimensions b and c, the A + B would produce a distribution with
dimensions a_b,a_c,b_b, b_c

## Functions

- `new_SUM_comb()`: Sum of distributions

- `new_SUBTRACTION_comb()`: Subtraction of distributions

- `new_MULTIPLICATION_comb()`: Multiplication of distributions

- `new_DIVISION_comb()`: Division of distributions

## Note

In case of the same dimensions, only the first combination is taken

## Author

John J. Aponte

## Examples

``` r
x1 <- new_MULTINORMAL(c(0,1), matrix(c(1,0.5,0.5,1),ncol=2), p_dimnames = c("A","B"))
x2 <- new_MULTINORMAL(c(10,1), matrix(c(1,0.4,0.4,1),ncol=2), p_dimnames = c("B","C"))
new_CONVOLUTION_comb(x1,x2, `+`)
#>   distribution A_B B_B A_C B_C
#> 1  CONVOLUTION  10  11   1   2
new_SUM_comb(x1,x2)
#>   distribution A_B B_B A_C B_C
#> 1  CONVOLUTION  10  11   1   2
new_SUBTRACTION_comb(x1,x2)
#>   distribution A_B B_B A_C B_C
#> 1  CONVOLUTION -10  -9  -1   0
new_MULTIPLICATION_comb(x1,x2)
#>   distribution A_B B_B A_C B_C
#> 1  CONVOLUTION   0  10   0   1
new_DIVISION_comb(x1,x2)
#>   distribution A_B B_B A_C B_C
#> 1  CONVOLUTION   0 0.1   0   1
```
