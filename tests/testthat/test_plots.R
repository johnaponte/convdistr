# Test Graphs
# 20181030 by JJAV
# # # # # # # # # #

context("Test for graphs")
# This check the code run but to check if the graph is what you want you must 
# see them


test_that("The ggDISTRIBUTION function works", {
  expect_true(inherits(ggDISTRIBUTION(new_NORMAL(0, 1)), "ggplot"))
  expect_true(inherits(ggDISTRIBUTION(new_DIRICHLET(c(10, 20, 70))), "ggplot"))
})

test_that("The plot.DESCRIPTION function works", {
  expect_silent(plot(new_NORMAL(0,1)))
  expect_silent(plot(new_DIRICHLET(c(10, 20, 30))))
})
