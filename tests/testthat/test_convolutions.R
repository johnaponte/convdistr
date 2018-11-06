# Test convolution of distribution
# 20181028
# # # # # # # # # # # # # # # # # #

context("Test convolution")

test_that("The new_CONVOLUTION function works", {
  x1 <- new_NORMAL(0, 1)
  x2 <- new_UNIFORM(0, 1)
  x3 <- new_DIRAC(3)
  expect_is(new_SUM(list(x1, x2)), "DISTRIBUTION")
  expect_equivalent(new_SUM(list(x1, x2))$oval, 0.5)
  rsum <- new_SUM(list(x1, x2, x3))
  expect_is(rsum, "DISTRIBUTION")
  expect_equivalent(rsum$oval, 3.5)
  expect_is(rfunc(rsum, 10), "matrix")
  expect_equivalent(nrow(rfunc(rsum, 10)), 10)
  expect_equivalent(ncol(rfunc(rsum, 10)), 1)
  expect_is(x1 + x2, "DISTRIBUTION")
  expect_is(x1 - x2, "DISTRIBUTION")
  expect_is(x1 * x2, "DISTRIBUTION")
  expect_is(x1 / x2, "DISTRIBUTION")
  
  x4 <- new_DIRICHLET(c(0.1,0.2,0.7))
  x5 <- new_DIRICHLET(c(0.8,0.1,0.1))
  x6 <- new_DIRICHLET(c(0.8,0.15,0.05))
  xsum <- x4 + x5 + x6
  expect_is(xsum, "DISTRIBUTION")
  expect_equivalent(nrow(rfunc(xsum, 10)), 10)
  expect_equivalent(ncol(rfunc(xsum, 10)), 3)
})

test_that("The new_MIXTURE function works", {
  x1 <- new_NORMAL(0,1)
  x2 <- new_NORMAL(8,1)
  x3 <- new_NORMAL(16,1)
  expect_silent(new_MIXTURE(list(x1,x2,x3)))
  xmix <- new_MIXTURE(list(x1,x2,x3), c(0.1,0.8,0.1))
  expect_equivalent(xmix$oval, 8)
  expect_equivalent(nrow(rfunc(xmix, 10)), 10)
  expect_equivalent(ncol(rfunc(xmix, 10)), 1)
  
  })