# The convdistr package

John J. Aponte

The `convdistr` package provide tools to define distribution objects and make
mathematical operations with them. It keep track of the results as if
they where scalar numbers but maintaining the ability to obtain randoms
samples of the convoluted distributions.

To install this package from github

`devtools::install_github("johnaponte/convdistr", build_manual = T, build_vignettes = T)`

## Practical example

What would be the resulting distribution of *a* + *b* \* *c* if *a* is a
**normal** distribution with mean 1 and standard deviation 0.5, *b* is a
**poisson** distribution with lambda 5 and *c* is a **beta**
distribution with shape parameters 10 and 20?

    library(convdistr)
    library(ggplot2)

    a <- new_NORMAL(1,0.5)
    b <- new_POISSON(5)
    c <- new_BETA(10,20)
    res <- a + b * c

    metadata(res) 
    #>   distribution     rvar
    #> 1  CONVOLUTION 2.666667
    summary(res)

<table>
<thead>
<tr class="header">
<th style="text-align: left;">distribution</th>
<th style="text-align: left;">varname</th>
<th style="text-align: right;">oval</th>
<th style="text-align: right;">nsample</th>
<th style="text-align: right;">mean_</th>
<th style="text-align: right;">sd_</th>
<th style="text-align: right;">lci_</th>
<th style="text-align: right;">median_</th>
<th style="text-align: right;">uci_</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">CONVOLUTION</td>
<td style="text-align: left;">rvar</td>
<td style="text-align: right;">2.67</td>
<td style="text-align: right;">10000</td>
<td style="text-align: right;">2.66</td>
<td style="text-align: right;">1.02</td>
<td style="text-align: right;">0.94</td>
<td style="text-align: right;">2.56</td>
<td style="text-align: right;">4.95</td>
</tr>
</tbody>
</table>

    ggDISTRIBUTION(res) + ggtitle("a + b * c")

<img src = "https://user-images.githubusercontent.com/3891174/61119313-d3645e80-a49a-11e9-834e-74fc29fd1e37.png"></img>

The result is a distribution with expected value 2.67. A sample from
10000 drawns of the distribution shows a mean value of 2.66, a median of
2.56 and 95% quantiles of 0.94, 4.95

The following sections describe the DISTRIBUTION object, how to create
new DISTRIBUTION objects and how to make operations and mixtures with
them.

Please note that when convoluting distributions, this package assumes
the distributions are independent between them, i.e. their correlation
is 0. If not, you need to implement specific distributions to handle the
correlation, like the MULTIVARIATE object.

## Description of the `DISTRIBUTION` object

The `DISTRIBUTION` is kind of abstract class (or interface) that
specific constructors should implement.

It contains 4 fields:

**distribution** : A character with the name of the distribution
implemented

**seed** : A numerical seed that is use to get a repeatable sample in
the `summary` function

**oval** : The observed value. It is the value expected. It is used as a
number for the mathematical operations of the distributions as if they
were a simple scalar

**rfunc(n)** : A function that generate random numbers from the
distribution. Its only parameter `n` is the number of drawns of the
distribution. It returns a matrix with as many rows as `n`, and as many
columns as the dimensions of the distributions

The DISTRIBUTION object can support multidimensional distributions for
example a dirichlet distribution. The names of the dimensions should
coincides with the names of the `oval` vector. If it has only one
dimension, the default name is `rvar`.

It is expected that the `rfunc` could be included in the creation of new
distributions by convolution or mixture, so the environment should be
carefully controlled to avoid reference leaking that is possible within
the R language. For that reason, the `rfunc` should be created within a
`restrict_environment` function that controls that only the variables
that are required within the `function` are saved in the environment of
the function.

Once the new objects are instanced, the fields are immutable and should
not be changed.

## Factory of `DISTRIBUTION` objects

The following functions create new objects of class `DISTRIBUTION`

<table>
<thead>
<tr class="header">
<th>Distribution</th>
<th>factory</th>
<th>parameters</th>
<th>function</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>uniform</td>
<td>new_UNIFORM</td>
<td>p_min, p_max</td>
<td>runif</td>
</tr>
<tr class="even">
<td>normal</td>
<td>new_NORMAL</td>
<td>p_mean, p_sd</td>
<td>rnorm</td>
</tr>
<tr class="odd">
<td>beta</td>
<td>new_BETA</td>
<td>p_shape1, p_shape2</td>
<td>rbeta</td>
</tr>
<tr class="even">
<td>beta</td>
<td>new_BETA_lci</td>
<td>p_mean, p_lci, p_uci</td>
<td>rbeta</td>
</tr>
<tr class="odd">
<td>triangular</td>
<td>new_TRIANGULAR</td>
<td>p_min, p_max, p_mode</td>
<td>rtriangular</td>
</tr>
<tr class="even">
<td>poisson</td>
<td>new_POISSON</td>
<td>p_lambda</td>
<td>rpoisson</td>
</tr>
<tr class="odd">
<td>exponential</td>
<td>new_EXPONENTIAL</td>
<td>p_rate</td>
<td>rexp</td>
</tr>
<tr class="even">
<td>discrete</td>
<td>new_DISCRETE</td>
<td>p_supp, p_prob</td>
<td>sample</td>
</tr>
<tr class="odd">
<td>dirichlet</td>
<td>new_DIRICHLET</td>
<td>p_alpha, p_dimnames</td>
<td>rdirichlet</td>
</tr>
<tr class="even">
<td>truncated</td>
<td>new_TRUNCATED</td>
<td>p_distribution, p_min, p_max</td>
<td></td>
</tr>
<tr class="odd">
<td>dirac</td>
<td>new_DIRAC</td>
<td>p_value</td>
<td></td>
</tr>
<tr class="even">
<td>NA</td>
<td>new_NA</td>
<td>p_dimnames</td>
<td></td>
</tr>
</tbody>
</table>

## Methods

The following are methods for all objects of class `DISTRIBUTION`

-   `metadata(x)` Print the metadata for the distribution
-   `summary(object, n=10000)` Produce a summary of the distribution
-   `rfunc(x, n)` Generate `n` random drawns of the distribution
-   `plot(x, n= 10000)` Produce a density plot of the distribution
-   `ggDISTRIBUTION(x, n= 10000)` produce a density plot of the
    distribution using ggplot2

<!-- -->

    myDistr <- new_NORMAL(0,1)
    metadata(myDistr)
    #>   distribution rvar
    #> 1       NORMAL    0
    rfunc(myDistr, 10)
    #>            rvar
    #> 1  -0.202292246
    #> 2   2.359176819
    #> 3  -0.378977974
    #> 4  -1.108465547
    #> 5   0.080081266
    #> 6  -0.001522165
    #> 7   1.140359435
    #> 8   0.220586273
    #> 9   0.533860090
    #> 10  1.450453816
    summary(myDistr)

<table>
<thead>
<tr class="header">
<th style="text-align: left;">distribution</th>
<th style="text-align: left;">varname</th>
<th style="text-align: right;">oval</th>
<th style="text-align: right;">nsample</th>
<th style="text-align: right;">mean_</th>
<th style="text-align: right;">sd_</th>
<th style="text-align: right;">lci_</th>
<th style="text-align: right;">median_</th>
<th style="text-align: right;">uci_</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">NORMAL</td>
<td style="text-align: left;">rvar</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">10000</td>
<td style="text-align: right;">0.01</td>
<td style="text-align: right;">1.01</td>
<td style="text-align: right;">-1.98</td>
<td style="text-align: right;">0.02</td>
<td style="text-align: right;">1.97</td>
</tr>
</tbody>
</table>

    plot(myDistr)

<img src="https://user-images.githubusercontent.com/3891174/61120096-78336b80-a49c-11e9-861c-196c0a72d3d9.png"></img>

    ggDISTRIBUTION(myDistr)

<img src="https://user-images.githubusercontent.com/3891174/61120178-a3b65600-a49c-11e9-91bc-2cc16ee98d28.png"></img>

## Convolution for Distribution with the same dimensions

Mathematical operations like `+`, `-`, `*`, `/` between `DISTRIBUTION`
with the same dimensions can be perform with the
`new_CONVOLUTION(listdistr, op, omit_NA = FALSE)` function. The
`listdistr` parameter is a list of `DISTRIBUTION` objects on which the
operation is made. A shorter version exists for each one of the
operations as follow

-   `new_SUM(listdistr, omit_NA = FALSE)`
-   `new_SUBTRACTION(listdistr, omit_NA = FALSE)`
-   `new_MULTIPLICATION(listdistr, omit_NA = FALSE)`
-   `new_DIVISION(listdistr, omit_NA = FALSE)`

but Mathematical operator can also be used.

    d1 <- new_NORMAL(1,1)
    d2 <- new_UNIFORM(2,8)
    d3 <- new_POISSON(5)
    dsum <- new_SUM(list(d1,d2,d3))
    dsum
    #>   distribution rvar
    #> 1  CONVOLUTION   11
    d1 + d2 + d3
    #>   distribution rvar
    #> 1  CONVOLUTION   11
    summary(dsum)

<table>
<thead>
<tr class="header">
<th style="text-align: left;">distribution</th>
<th style="text-align: left;">varname</th>
<th style="text-align: right;">oval</th>
<th style="text-align: right;">nsample</th>
<th style="text-align: right;">mean_</th>
<th style="text-align: right;">sd_</th>
<th style="text-align: right;">lci_</th>
<th style="text-align: right;">median_</th>
<th style="text-align: right;">uci_</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">CONVOLUTION</td>
<td style="text-align: left;">rvar</td>
<td style="text-align: right;">11</td>
<td style="text-align: right;">10000</td>
<td style="text-align: right;">11</td>
<td style="text-align: right;">3.01</td>
<td style="text-align: right;">5.4</td>
<td style="text-align: right;">10.88</td>
<td style="text-align: right;">17.2</td>
</tr>
</tbody>
</table>

    ggDISTRIBUTION(dsum)

<img src="https://user-images.githubusercontent.com/3891174/61120240-c8123280-a49c-11e9-9e13-7354424ae8e0.png"></img>

## Mixture

A `DISTRIBUTION`, consisting on the mixture of several distribution can
be obtained with the `new_MIXTURE(listdistr, mixture)` function where
`listdistr` is a list of `DISTRIBUTION` objects and `mixture` the vector
of probabilities for each distribution. If missing the mixture, the
probability will be the same for each distribution.

    d1 <- new_NORMAL(1,0.5)
    d2 <- new_NORMAL(5,0.5)
    d3 <- new_NORMAL(10,0.5)
    dmix <- new_MIXTURE(list(d1,d2,d3))
    summary(dmix)

<table>
<thead>
<tr class="header">
<th style="text-align: left;">distribution</th>
<th style="text-align: left;">varname</th>
<th style="text-align: right;">oval</th>
<th style="text-align: right;">nsample</th>
<th style="text-align: right;">mean_</th>
<th style="text-align: right;">sd_</th>
<th style="text-align: right;">lci_</th>
<th style="text-align: right;">median_</th>
<th style="text-align: right;">uci_</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">MIXTURE</td>
<td style="text-align: left;">rvar</td>
<td style="text-align: right;">5.33</td>
<td style="text-align: right;">10000</td>
<td style="text-align: right;">5.32</td>
<td style="text-align: right;">3.7</td>
<td style="text-align: right;">0.27</td>
<td style="text-align: right;">4.99</td>
<td style="text-align: right;">10.71</td>
</tr>
</tbody>
</table>

    ggDISTRIBUTION(dmix)

<img src="https://user-images.githubusercontent.com/3891174/61120284-e37d3d80-a49c-11e9-9451-295bafe325af.png"><img>

## Convolution of distributions with different dimensions

When convoluting distribution with different dimensions, there are two
possibilities. The `new_CONVOLUTION_assoc` family of functions perform
the operation only on the common dimensions and left the others
dimensions as they are, or the `new_CONVOLUTION_comb` family of
functions which perform the operation in the combination of all
dimensions.

    d1 <- new_MULTINORMAL(c(0,1), matrix(c(1,0.3,0.3,1), ncol = 2), p_dimnames = c("A","B"))
    d2 <- new_MULTINORMAL(c(3,4), matrix(c(1,0.3,0.3,1), ncol = 2), p_dimnames = c("B","C"))
    summary(d1)

<table>
<thead>
<tr class="header">
<th style="text-align: left;">distribution</th>
<th style="text-align: left;">varname</th>
<th style="text-align: right;">oval</th>
<th style="text-align: right;">nsample</th>
<th style="text-align: right;">mean_</th>
<th style="text-align: right;">sd_</th>
<th style="text-align: right;">lci_</th>
<th style="text-align: right;">median_</th>
<th style="text-align: right;">uci_</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">MULTINORMAL</td>
<td style="text-align: left;">A</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">10000</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-1.96</td>
<td style="text-align: right;">0.01</td>
<td style="text-align: right;">1.95</td>
</tr>
<tr class="even">
<td style="text-align: left;">MULTINORMAL</td>
<td style="text-align: left;">B</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">10000</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.95</td>
<td style="text-align: right;">1.00</td>
<td style="text-align: right;">2.94</td>
</tr>
</tbody>
</table>

    summary(d2)

<table>
<thead>
<tr class="header">
<th style="text-align: left;">distribution</th>
<th style="text-align: left;">varname</th>
<th style="text-align: right;">oval</th>
<th style="text-align: right;">nsample</th>
<th style="text-align: right;">mean_</th>
<th style="text-align: right;">sd_</th>
<th style="text-align: right;">lci_</th>
<th style="text-align: right;">median_</th>
<th style="text-align: right;">uci_</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">MULTINORMAL</td>
<td style="text-align: left;">B</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">10000</td>
<td style="text-align: right;">3.01</td>
<td style="text-align: right;">1.00</td>
<td style="text-align: right;">1.04</td>
<td style="text-align: right;">3.03</td>
<td style="text-align: right;">4.97</td>
</tr>
<tr class="even">
<td style="text-align: left;">MULTINORMAL</td>
<td style="text-align: left;">C</td>
<td style="text-align: right;">4</td>
<td style="text-align: right;">10000</td>
<td style="text-align: right;">4.01</td>
<td style="text-align: right;">1.01</td>
<td style="text-align: right;">2.04</td>
<td style="text-align: right;">4.00</td>
<td style="text-align: right;">6.00</td>
</tr>
</tbody>
</table>

    summary(new_SUM_assoc(d1,d2))

<table>
<thead>
<tr class="header">
<th style="text-align: left;">distribution</th>
<th style="text-align: left;">varname</th>
<th style="text-align: right;">oval</th>
<th style="text-align: right;">nsample</th>
<th style="text-align: right;">mean_</th>
<th style="text-align: right;">sd_</th>
<th style="text-align: right;">lci_</th>
<th style="text-align: right;">median_</th>
<th style="text-align: right;">uci_</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">CONVOLUTION</td>
<td style="text-align: left;">A</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">10000</td>
<td style="text-align: right;">-0.01</td>
<td style="text-align: right;">0.99</td>
<td style="text-align: right;">-1.94</td>
<td style="text-align: right;">-0.01</td>
<td style="text-align: right;">1.92</td>
</tr>
<tr class="even">
<td style="text-align: left;">CONVOLUTION</td>
<td style="text-align: left;">C</td>
<td style="text-align: right;">4</td>
<td style="text-align: right;">10000</td>
<td style="text-align: right;">4.00</td>
<td style="text-align: right;">1.00</td>
<td style="text-align: right;">2.05</td>
<td style="text-align: right;">3.99</td>
<td style="text-align: right;">5.95</td>
</tr>
<tr class="odd">
<td style="text-align: left;">CONVOLUTION</td>
<td style="text-align: left;">B</td>
<td style="text-align: right;">4</td>
<td style="text-align: right;">10000</td>
<td style="text-align: right;">4.01</td>
<td style="text-align: right;">1.42</td>
<td style="text-align: right;">1.21</td>
<td style="text-align: right;">4.01</td>
<td style="text-align: right;">6.80</td>
</tr>
</tbody>
</table>

    summary(new_SUM_comb(d1,d2))

<table>
<thead>
<tr class="header">
<th style="text-align: left;">distribution</th>
<th style="text-align: left;">varname</th>
<th style="text-align: right;">oval</th>
<th style="text-align: right;">nsample</th>
<th style="text-align: right;">mean_</th>
<th style="text-align: right;">sd_</th>
<th style="text-align: right;">lci_</th>
<th style="text-align: right;">median_</th>
<th style="text-align: right;">uci_</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">CONVOLUTION</td>
<td style="text-align: left;">A_B</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">10000</td>
<td style="text-align: right;">2.96</td>
<td style="text-align: right;">1.42</td>
<td style="text-align: right;">0.17</td>
<td style="text-align: right;">2.97</td>
<td style="text-align: right;">5.76</td>
</tr>
<tr class="even">
<td style="text-align: left;">CONVOLUTION</td>
<td style="text-align: left;">B_B</td>
<td style="text-align: right;">4</td>
<td style="text-align: right;">10000</td>
<td style="text-align: right;">3.98</td>
<td style="text-align: right;">1.41</td>
<td style="text-align: right;">1.17</td>
<td style="text-align: right;">4.00</td>
<td style="text-align: right;">6.71</td>
</tr>
<tr class="odd">
<td style="text-align: left;">CONVOLUTION</td>
<td style="text-align: left;">A_C</td>
<td style="text-align: right;">4</td>
<td style="text-align: right;">10000</td>
<td style="text-align: right;">3.97</td>
<td style="text-align: right;">1.41</td>
<td style="text-align: right;">1.28</td>
<td style="text-align: right;">3.97</td>
<td style="text-align: right;">6.75</td>
</tr>
<tr class="even">
<td style="text-align: left;">CONVOLUTION</td>
<td style="text-align: left;">B_C</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">10000</td>
<td style="text-align: right;">4.99</td>
<td style="text-align: right;">1.40</td>
<td style="text-align: right;">2.20</td>
<td style="text-align: right;">4.98</td>
<td style="text-align: right;">7.67</td>
</tr>
</tbody>
</table>


<img src="man/figures/logo.png" align="right" height="139" alt="convdistr website" />