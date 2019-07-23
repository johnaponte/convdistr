# Test for helper functinos
# 20181029 by JJAV
# # # # # # # # # # # # # # #

context("Test helper function")

test_that("The omit_na function works fine", {
  d1 <- new_NORMAL(0,1)
  d2 <- new_UNIFORM(0,1)
  d3 <- new_NA()
  list1 <- list(d1,d2,d2)
  list2 <- list(d1,d2,d3)
  expect_equal(convdistr:::omit_NA(list1),list1)
  expect_equal(convdistr:::omit_NA(list2), list(d1,d2))
})


test_that("The same_dimensions function works fine", {
  d1 <- new_NORMAL(0,1)
  d2 <- new_UNIFORM(0,1)
  d3 <- new_DIRICHLET(c(0.1,0.4,0.5))
  list1 <- list(d1,d2,d2)
  list2 <- list(d1,d2,d3)
  expect_true(convdistr:::same_dimensions(list1))
  expect_false(convdistr:::same_dimensions(list2))
})


test_that("The fitbeta works fine" , {
  fitval <- fitbeta(0.45,0.40,0.50)
  expect_equivalent(fitval[1] / sum(fitval), 0.45, tolerance = 0.0001)
  expect_equivalent(qbeta(0.025, fitval[1], fitval[2]), 0.40, tolerance = 0.002)
  expect_equivalent(qbeta(0.975, fitval[1], fitval[2]), 0.50, tolerance = 0.002)
})


test_that("The fitbeta_ml works fine" , {
  fitval <- fitbeta_ml(0.45,0.40,0.50)
  expect_equivalent(fitval[1] / sum(fitval), 0.45, tolerance = 0.0001)
  expect_equivalent(qbeta(0.025, fitval[1], fitval[2]), 0.40, tolerance = 0.002)
  expect_equivalent(qbeta(0.975, fitval[1], fitval[2]), 0.50, tolerance = 0.002)
})

test_that("The fitdirichlet works fine", {
  fitval1 <- fitbeta(0.10,0.05,0.15)
  fitval2 <- fitbeta(0.40,0.35,0.45)
  fitval3 <- fitbeta(0.50, 0.45, 0.55)
  fitdir <- fitdirichlet(fitval1,fitval2,fitval3)
  expect_equivalent(fitdir[1]/sum(fitdir),0.10, tolerance = 0.005)
  expect_equivalent(fitdir[2]/sum(fitdir),0.40, tolerance = 0.005)
  expect_equivalent(fitdir[3]/sum(fitdir),0.50, tolerance = 0.005)
})
