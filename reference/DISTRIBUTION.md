# DISTRIBUTION class

DISTRIBUTION is a kind of abstract class (or interface) that the
specific constructors should implement.

## Value

a DISTRIBUTION object

## Details

It contains 4 fields

- distribution:

  A character with the name of the distribution implemented

- seed:

  A numerical that is used for `details` to produce reproducible details
  of the distribution

- oval:

  Observed value. Is the value expected. It is used as a number for the
  mathematical operations of the distributions as if they were a simple
  scalar

- rfunc:

  A function that generate random numbers from the distribution. Its
  only parameter `n` is the number of draws of the distribution. It
  returns a matrix with as many rows as n, and as many columns as the
  dimensions of the distributions

The DISTRIBUTION objects could support multidimensional distributions
for example
[`DIRICHLET`](htinstatps://johnaponte.github.io/convdistr/reference/DIRICHLET.md).
The names of the dimensions should coincides with the names of the
`oval` vector. If only one dimension, the default name is `rvar`.

It is expected that the `rfunc` is included in the creation of new
distributions by convolution so the environment should be carefully
controlled to avoid reference leaking that is possible within the R
language. For that reason, `rfunc` should be created within a
[`restrict_environment`](htinstatps://johnaponte.github.io/convdistr/reference/restrict_environment.md)
function

Once the object is instanced, the fields are immutable and should not be
changed. If the seed needs to be modified, a new object can be created
using the
[`set_seed`](htinstatps://johnaponte.github.io/convdistr/reference/set_seed.md)
function

Objects are defined for the following distributions

- [`UNIFORM`](htinstatps://johnaponte.github.io/convdistr/reference/UNIFORM.md)

- [`NORMAL`](htinstatps://johnaponte.github.io/convdistr/reference/NORMAL.md)

- [`BETA`](htinstatps://johnaponte.github.io/convdistr/reference/BETA.md)

- [`TRIANGULAR`](htinstatps://johnaponte.github.io/convdistr/reference/TRIANGULAR.md)

- [`POISSON`](htinstatps://johnaponte.github.io/convdistr/reference/POISSON.md)

- [`EXPONENTIAL`](htinstatps://johnaponte.github.io/convdistr/reference/EXPONENTIAL.md)

- [`DISCRETE`](htinstatps://johnaponte.github.io/convdistr/reference/DISCRETE.md)

- [`DIRAC`](htinstatps://johnaponte.github.io/convdistr/reference/DIRAC.md)

- [`DIRICHLET`](htinstatps://johnaponte.github.io/convdistr/reference/DIRICHLET.md)

- [`TRUNCATED`](htinstatps://johnaponte.github.io/convdistr/reference/TRUNCATED.md)

- [`NA_DISTRIBUTION`](htinstatps://johnaponte.github.io/convdistr/reference/NA_DISTRIBUTION.md)

## Author

John J. Aponte
