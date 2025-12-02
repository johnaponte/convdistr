# Make the convolution of two or more [`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md) objects

The convolution of the simple algebraic operations is made by the
operation of individual drawns of the distributions. The
[`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md)
objects must have the same dimensions.

## Usage

``` r
new_CONVOLUTION(listdistr, op, omit_NA = FALSE)

new_SUM(..., omit_NA = FALSE)

# S3 method for class 'DISTRIBUTION'
e1 + e2

new_SUBTRACTION(..., omit_NA = FALSE)

# S3 method for class 'DISTRIBUTION'
e1 - e2

new_MULTIPLICATION(..., omit_NA = FALSE)

# S3 method for class 'DISTRIBUTION'
e1 * e2

new_DIVISION(..., omit_NA = FALSE)

# S3 method for class 'DISTRIBUTION'
e1/e2
```

## Arguments

- listdistr:

  a list of
  [`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md)
  objects

- op:

  a function to convolute \`+\`, \`-\`, \`\*\`, \`\\

- omit_NA:

  if TRUE, `NA` distributions will be omitted

- ...:

  [`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md)
  objects or a list of distribution objects

- e1:

  object of class
  [`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md)

- e2:

  object of class
  [`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md)

## Value

and object of class `CONVOLUTION`,
[`DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/DISTRIBUTION.md)

## Details

If any of the distributions is of class `NA`
([`NA_DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/NA_DISTRIBUTION.md))
the result will be a new distribution of class `NA` unless the `omit_NA`
option is set to `TRUE`

## Functions

- `new_SUM()`: Sum of distributions

- `new_SUBTRACTION()`: Subtraction for distributions

- `new_MULTIPLICATION()`: Multiplication for distributions

- `new_DIVISION()`: DIVISION for distributions

## Author

John J. Aponte

## Examples

``` r
x1 <- new_NORMAL(0,1)
x2 <- new_UNIFORM(1,2)
new_CONVOLUTION(list(x1,x2), `+`)
#>   distribution rvar
#> 1  CONVOLUTION  1.5
new_SUM(x1,x2)
#>   distribution rvar
#> 1  CONVOLUTION  1.5
x1 + x2
#>   distribution rvar
#> 1  CONVOLUTION  1.5
new_SUBTRACTION(x1,x2)
#>   distribution rvar
#> 1  CONVOLUTION -1.5
x1 - x2
#>   distribution rvar
#> 1  CONVOLUTION -1.5
new_MULTIPLICATION(list(x1,x2))
#>   distribution rvar
#> 1  CONVOLUTION    0
x1 * x2
#>   distribution rvar
#> 1  CONVOLUTION    0
new_DIVISION(list(x1,x2))
#>   distribution rvar
#> 1  CONVOLUTION    0
x1 / x2
#>   distribution rvar
#> 1  CONVOLUTION    0
```
