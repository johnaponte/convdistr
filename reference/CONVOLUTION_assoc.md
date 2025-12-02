# Convolution with association of dimensions

In case of different dimensions of the distribution this function
perform the operation on the common distributions and add without
modifications the other dimensions of the distribution.

## Usage

``` r
new_CONVOLUTION_assoc(dist1, dist2, op)

new_SUM_assoc(dist1, dist2)

new_SUBTRACTION_assoc(dist1, dist2)

new_MULTIPLICATION_assoc(dist1, dist2)

new_DIVISION_assoc(dist1, dist2)
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

## Value

an object of class
[`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md)

## Details

If distribution A have dimensions a and b and distribution B have
dimensions b and c, the A + B would produce a distribution with
dimensions a, c, b+b,

## Functions

- `new_SUM_assoc()`: Sum of distributions

- `new_SUBTRACTION_assoc()`: Subtraction of distributions

- `new_MULTIPLICATION_assoc()`: Multiplication of distributions

- `new_DIVISION_assoc()`: Division of distributions

## Author

John J. Aponte

## Examples

``` r
x1 <- new_MULTINORMAL(c(0,1), matrix(c(1,0.5,0.5,1),ncol=2), p_dimnames = c("A","B"))
x2 <- new_MULTINORMAL(c(10,1), matrix(c(1,0.4,0.4,1),ncol=2), p_dimnames = c("B","C"))
new_CONVOLUTION_assoc(x1,x2, `+`)
#>   distribution A C  B
#> 1  CONVOLUTION 0 1 11
new_SUM_assoc(x1,x2)
#>   distribution A C  B
#> 1  CONVOLUTION 0 1 11
new_SUBTRACTION_assoc(x1,x2)
#>   distribution A C  B
#> 1  CONVOLUTION 0 1 -9
new_MULTIPLICATION_assoc(x1,x2)
#>   distribution A C  B
#> 1  CONVOLUTION 0 1 10
new_DIVISION_assoc(x1,x2)
#>   distribution A C   B
#> 1  CONVOLUTION 0 1 0.1
```
