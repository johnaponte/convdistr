# Test the DISTRIBUTION_factory works
# by JJAV 20191101
# # # # # # # # # # # # # # # # # # # #

context("Test distribution_factory")

test_that("The DISTRIBUTION_factory works well" , {
  new_myUNIF <-
    DISTRIBUTION_factory("UNIFORM", runif, function() {
      (min + max) / 2
    })
  d1 <- new_myUNIF(10, 20)
  expect_equivalent(d1$oval, 15)
  expect_equivalent(mean(rfunc(d1, 1000)), 15, tolerance = 0.5)
  expect_is(d1, "UNIFORM")
  expect_is(d1, "DISTRIBUTION")
  
  
  new_myNORM <-
    DISTRIBUTION_factory("normal", rnorm, function() {
      mean
    })
  d2 <- new_myNORM(10, 2)
  expect_equivalent(d2$oval, 10)
  expect_equivalent(mean(rfunc(d2, 1000)), 10, tolerance = 0.5)
  expect_is(d2, "NORMAL")
  expect_is(d2, "DISTRIBUTION")
  
  new_myDIRICHLET3 <-
    DISTRIBUTION_factory('rdirichlet',
                         rdirichlet,
                         function() {
                           salpha = sum(alpha)
                           alpha / salpha
                         })
  d3 <- new_myDIRICHLET3(c(10, 20, 70), dimnames = c("A", "B", "C"))
  expect_equal(d3$oval, c("A" = 0.1, "B" = 0.2, "C" = 0.7))
  expect_equal(apply(rfunc(d3, 100), 2, mean),
               c("A" = 0.1,
                 "B" = 0.2,
                 "C" = 0.7),
               tolerance = 0.05)
  expect_error(new_myDIRICHLET3(c(10, 20, 70)), 
               label = "length(.oval) == length(dimnames) is not TRUE")
  
})

