# Test for methods
# 20181028 by JJAV
# # # # # # # # # #

context("Test for methods")

test_that("Replacement is not possible for DISTRIBUTION objects", {
  myDistr <- new_NORMAL(0,1)
  expect_error(myDistr$new_field <-  "hola", "Objects of class DISTRIBUTION are immutable")
  expect_error(myDistr$oval <- 3 , "Objects of class DISTRIBUTION are immutable")
  expect_error(myDistr["oval"] <- 3 , "Objects of class DISTRIBUTION are immutable")
  expect_error(myDistr[["oval"]] <- 3, "Objects of class DISTRIBUTION are immutable")
  expect_error(myDistr["new_field"] <- 3 , "Objects of class DISTRIBUTION are immutable")
})

test_that("The metadata function works well", {
  myDistr <- new_NORMAL(0,1)
  df <- data.frame(distribution = "NORMAL", rvar = 0, stringsAsFactors = FALSE)
  expect_equivalent(metadata(myDistr), df)
})

test_that("The print.DISTRIBUTION function works well" , {
  myDistr <- new_NORMAL(0,1)
  expect_output_file(print(myDistr), "print_myDistr.txt")
})
