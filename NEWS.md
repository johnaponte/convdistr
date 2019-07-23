---
output:
  pdf_document: default
  html_document: default
---
# News for the package convdistr

# convdistr 0.1.0

* Basic functionality of the package and first testing

# convdistr 0.2.0

* DISTRIBUTION_factory added
* New_BINOMIAL function added
* Added the fitdiri and fitbeta functions
* Added the dimmnames function
* All distributions now accept a dimnames parameter
* Added MULTINORMAL distribution
* Added new_CONVOLUTION_assoc
* Added new_CONVOLUTION_comb
* Added new add_total

# convdistr 0.3.0

* Fixed typos in documentation of package
* Change documentation of new_BETA parameters
* Change the name new_SUBSTRATION to new_SUBTRACTION
* New test for seed management on summary
* New set_seed function
* Check of spelling of documentation
* Sample size has been extended

# convdistr 1.0

* Package is ready for distribution

# convdistr 1.1

* Change for minimum square diff on the cumulative distribution for BETA_LCI
* avoid sink in fitdirichlet

# convdistr 1.2

* Fix example for fitdirichlet
* Spelling of news

# convdistr 1.3

* new_BETA_lci and new_BETA_lci2 are separated functions. The first keep the
expected value but could be less accurate on CI, the second could be more 
accurate on the CI but the expected value may change. The second use a ML 
function to find the parameters. Equivalent changes has made to fitbeta and
fitbeta_ml

