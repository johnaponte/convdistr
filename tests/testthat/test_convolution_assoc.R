# Test the convolution_association distribution
# 20181106 by JJAV
# # # # # # # # # # # # # # # # # # # # # # # #

context("Test convolution with association")

test_that("The new_CONVOLUTION_assoc works well with mixing dimensions", {
  d1 <- new_DIRICHLET(c(10,20,70), p_dimnames = c("A","B","C"))
  d2 <- new_DIRICHLET(c(20,30,50), p_dimnames = c("B","C","D"))
  comb1 <- new_CONVOLUTION_assoc(d1,d2,`+`)
  expect_equal(dimnames(comb1),c("A","D","B","C"))
  expect_equal(comb1$oval, c(
    A = 0.1,
    D = 0.5,
    B = 0.4,
    C = 1
  ))
  draw1 <- rfunc(comb1,10)
  expect_equal(nrow(draw1),10)
  expect_equal(ncol(draw1),4)
  expect_equal(colnames(draw1),c("A","D","B","C"))
})

test_that("The new_CONVOLUTION_assoc works with same dimensions", {
  d1 <- new_DIRICHLET(c(10,20,70), p_dimnames = c("A","B","C"))
  d2 <- new_DIRICHLET(c(20,30,50), p_dimnames = c("A","C","B"))
  comb1 <- new_CONVOLUTION_assoc(d1,d2,`+`)
  expect_equal(dimnames(comb1),c("A","B","C"))
  expect_equal(comb1$oval, c(
    A = 0.3,
    B = 0.7,
    C = 1
  ))
  draw1 <- rfunc(comb1,10)
  expect_equal(nrow(draw1),10)
  expect_equal(ncol(draw1),3)
  expect_equal(colnames(draw1),c("A","B","C"))
})

test_that("The new_CONVOLUTION_assoc works with unrelated dimensions" , {
  d1 <- new_NORMAL(0,1,p_dimnames = "A")
  d2 <- new_NORMAL(10,1, p_dimnames = "B")
  comb1 <- new_CONVOLUTION_assoc(d1,d2, `+`)
  expect_equal(dimnames(comb1), c("A","B"))
  expect_equal(comb1$oval, c(A = 0, B = 10))
  draw1 <- rfunc(comb1,10)
  expect_equal(nrow(draw1),10)
  expect_equal(ncol(draw1),2)
  expect_equal(colnames(draw1),c("A","B"))
  
})
