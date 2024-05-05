# News for the package convdistr

## convdistr 1.6.2
  * Update the use of a depecrated function from ggplot2
  * Add aLogo

## convdistr 1.6.1
  * Update documentation of the package
  * Add pkgdown

## convdistr 1.6.0
  * Add a betabinomial distribution

## convdistr 1.5.3
  * Change date of submission for a current date

## convdistr 1.5.2
  * cinqnum.DISTRIBUTION function now use repeatable from shiny in order to 
ensure the seed from the distribution is used and the same cinqnum results are
obtained. CRAN does not allow to change 
the environment, necessary to ensure the seed from the system is not affected by
the function cinqnum, but the already approved shiny function do it for us.

## convdistr 1.5.1
  * Fix documentation and the return value for all objects is complete
  * Change the approach to make cinqnum.DISTRIBUTION reproducible

## convdistr 1.5
  * new_DIRAC distribution allows now multiple dimensions

## convdistr 1.4
  * new_DIRICHLET now accept to have a column with zero probability. If only
one column have probability, returns 1 in that column and zero elsewhere

  * new_BETA_lci and new_BETA_lci2 are separated functions. The first keep the
expected value but could be less accurate on CI, the second could be more 
accurate on the CI but the expected value may change. The second use a ML 
function to find the parameters. Equivalent changes has made to fitbeta and
fitbeta_ml

## convdistr 1.3

## convdistr 1.2
  * Fix example for fitdirichlet
  * Spelling of news

## convdistr 1.1
  * Change for minimum square diff on the cumulative distribution for BETA_LCI
  * avoid sink in fitdirichlet

## convdistr 1.0
  * Package is ready for distribution

## convdistr 0.3.0
  * Fixed typos in documentation of package
  * Change documentation of new_BETA parameters 
  * Change the name new_SUBSTRATION to new_SUBTRACTION
  * New test for seed management on summary
  * New set_seed function
  * Check of spelling of documentation
  * Sample size has been extended

## convdistr 0.2.0
  * DISTRIBUTION_factory added
  * New_BINOMIAL function added
  * Added the fitdiri and fitbeta functions
  * Added the dimmnames function
  * All distributions now accept a dimnames parameter
  * Added MULTINORMAL distribution
  * Added new_CONVOLUTION_assoc
  * Added new_CONVOLUTION_comb
  * Added new add_total

## convdistr 0.1.0
  * Basic functionality of the package and first testing

