# Test Graphs
# 20181030 by JJAV
# # # # # # # # # #

context("Test for graphs")
# This check the code run but to check if the graph is what you want you must 
# see them

test_that("The ggDISTRIBUTION function works",{
  test_is(ggDESCRIPTION(new_NORMAL(0,1)),"ggplot")
  test_is(ggDESCRIPTION(new_DIRCHLET(c(10,20,70)),"ggplot")
})
  
test_that("The plot.DESCRIPTION function works", {
  test_silent(plot(new_NORMAL(0.1)))
  test_silent(plot(new_DIRCHLET(c(10,20,30))))
})  
