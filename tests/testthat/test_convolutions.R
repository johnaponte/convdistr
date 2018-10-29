# Test convolution of distribution 
# 20181028
# # # # # # # # # # # # # # # # # #

context("Test Convolution")

test_that("The new_SUM function works", {
  x1 <- new_NORMAL(0,1)
  x2 <- new_UNIFORM(0,1)
  x3 <- new_DIRAC(3)
  expect_is(new_SUM(list(x1,x2)), "DISTRIBUTION")
  expect_equivalent(new_SUM(list(x1,x2))$oval, 0.5)
  rsum <- new_SUM(list(x1,x2,x3))
  expect_is(rsum, "DISTRIBUTION")
  expect_equivalent(rsum$oval, 3.5)
  expect_is(rfunc(rsum,10),"matrix")
  expect_equivalent(nrow(rfunc(rsum,10)),10)
  expect_equivalent(ncol(rfunc(rsum,10)),1)
})