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
