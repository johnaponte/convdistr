context("Test Distributions")

test_that("new_UNIFORM works fine", {
  myDistr <- new_UNIFORM(0,1)
  expect_s3_class(myDistr, "UNIFORM")
  expect_s3_class(myDistr, "DISTRIBUTION")
  expect_equivalent(myDistr$oval , 0.5)
  expect_silent(myDistr$rfunc(1))

})

test_that("new_NORMAL works fine", {
  myDistr <- new_NORMAL(0,1)
  expect_s3_class(myDistr, "NORMAL")
  expect_s3_class(myDistr, "DISTRIBUTION")
  expect_equivalent(myDistr$oval ,0)
  expect_silent(myDistr$rfunc(1))

})

test_that("new_BETA works fine" ,{
  myDistr <- new_BETA(1,1)
  expect_s3_class(myDistr, "BETA")
  expect_s3_class(myDistr, "DISTRIBUTION")
  expect_equivalent(myDistr$oval ,0.5)
  expect_silent(myDistr$rfunc(1))

})


test_that("new_DISCRETE works fine" ,{
  myDistr <- new_DISCRETE(c(1,2,3))
  expect_s3_class(myDistr, "DISCRETE")
  expect_s3_class(myDistr, "DISTRIBUTION")
  expect_equivalent(myDistr$oval ,2)
  expect_silent(myDistr$rfunc(1))


  myDistr2 <- new_DISCRETE(c(1,2,3), c(0.1,0.8,0.1))
  expect_s3_class(myDistr2, "DISCRETE")
  expect_s3_class(myDistr2, "DISTRIBUTION")
  expect_equivalent(myDistr2$oval ,2)
  expect_silent(myDistr2$rfunc(1))

})


test_that("new_NA works fine" ,{
  myDistr <- new_NA()
  expect_s3_class(myDistr, "NA")
  expect_s3_class(myDistr, "DISTRIBUTION")
  expect_true(is.na(myDistr$oval))
  expect_silent(myDistr$rfunc(1))

  myDistr2 <- new_NA(c("dimension1","dimension2"))
  expect_s3_class(myDistr2, "NA")
  expect_s3_class(myDistr2, "DISTRIBUTION")
  expect_length(myDistr2$oval,2)
  expect_true(is.na(myDistr2$oval[1]))
  expect_true(is.na(myDistr2$oval[2]))
  expect_equal(names(myDistr2$oval), c("dimension1","dimension2"))
  expect_silent(myDistr2$rfunc(1))

})


test_that("new_TRUNCATED works fine", {
  myDistr <- new_TRUNCATED(new_NORMAL(0,1),-0.5,0.5)
  expect_s3_class(myDistr, "TRUNCATED")
  expect_s3_class(myDistr, "NORMAL")
  expect_s3_class(myDistr, "DISTRIBUTION")
  expect_silent(myDistr$rfunc(1))
  vecrand <- myDistr$rfunc(1000)
  expect_true(all(vecrand >= -0.5))
  expect_true(all(vecrand <= 0.5))
})

test_that("new_TRIANGULAR works fine" , {
  myDistr <- new_TRIANGULAR(-1,1,0)
  expect_s3_class(myDistr, "TRIANGULAR")
  expect_s3_class(myDistr, "DISTRIBUTION")
  expect_equal(myDistr$oval, 0)
  expect_silent(myDistr$rfunc(1))
  expect_error(new_TRIANGULAR(1,2,3))
  expect_error(new_TRIANGULAR(2,1,1.5))
  expect_silent(new_TRIANGULAR(1,2,2))
  expect_silent(new_TRIANGULAR(1,2,1))
})

test_that("new_BETA_lci works fine" , {
  myDistr <- new_BETA_lci(0.5,0.4,0.6)
  expect_s3_class(myDistr, "BETA")
  expect_s3_class(myDistr, "DISTRIBUTION")
  expect_equal(myDistr$oval, 0.5)
  expect_silent(myDistr$rfunc(1))
  expect_error(new_BETA_lci(5,4,6))
  expect_error(new_BETA_lci(-0.5,0.4,0.6))
  expect_error(new_BETA_lci(0.5,0.6,0.7))
  expect_error(new_BETA_lci(0.5,0.6,0.4))
})

test_that("new_POISSON works fine",{
  myDistr <- new_POISSON(5)
  expect_s3_class(myDistr, "POISSON")
  expect_s3_class(myDistr, "DISTRIBUTION")
  expect_equal(myDistr$oval, 5)
  expect_silent(myDistr$rfunc(1))
  expect_error(new_POISSON(-1))
})

