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

test_that(
  "The summary function works" ,
  {
    myDistr <- new_NORMAL(0, 1)
    mySummary <- summary(myDistr)
    expect_is(mySummary, "data.frame")
    expect_equal(
      names(mySummary),
      c(
        "distribution",
        "varname",
        "oval",
        "nsample",
        "mean_",
        "sd_",
        "lci_",
        "median_",
        "uci_"
      )
    )
    expect_equal(nrow(mySummary),1)
    expect_is(summary(new_NA()), "data.frame")
    expect_is(summary(new_DIRAC(1)), "data.frame")
    expect_is(summary(new_DIRICHLET(c(0.1,0.9))), "data.frame")
    expect_equal(nrow(summary(new_DIRICHLET(c(0.1,0.9)))), 2)
  })


test_that("The rfunc works well", {
  myDistr <- new_NORMAL(0,1)
  expect_is(rfunc(myDistr,10),"matrix")
  expect_equal(nrow(rfunc(myDistr,10)),10)
  expect_equal(ncol(rfunc(myDistr,10)),1)
  expect_equal(ncol(rfunc(new_DIRICHLET(c(0.2,0.3,0.4)),10)),3)
  expect_equal(nrow(rfunc(new_DIRICHLET(c(0.2,0.3,0.4)),10)),10)
})

test_that("The dimnames works well" , {
  myDistr <- new_NORMAL(0,1)
  expect_equal(dimnames(myDistr), "rvar")
})


test_that("The Summary does not change the system seed", {
  d1 <- new_NORMAL(0,1)
  # Setup the fixture
  if (exists(".Random.seed", .GlobalEnv))
    oldseed <- .GlobalEnv$.Random.seed
  else
    oldseed <- NULL
  #test start
  set.seed(123456789)
  v1 <- runif(1000)
  v2 <- runif(1000)
  set.seed(123456789)
  v3 <- runif(1000)
  summary(d1)
  v4 <- runif(1000)
  set.seed(123456789)
  v5 <- runif(1000)
  rfunc(d1,10000)
  v6 <- runif(1000)
  expect_equal(v1,v3)
  expect_equal(v1,v5)
  expect_equal(v2,v4)
  expect_true(all(v2 == v4))
  expect_false(all(v2 == v6))
  # Return back the fixture
  if (!is.null(oldseed))
    .GlobalEnv$.Random.seed <- oldseed
  else
    rm(".Random.seed", envir = .GlobalEnv)
})


test_that("The seed only affects the latest created object", {
  d1 <- new_NORMAL(0,1)
  d2 <- new_NORMAL(0,1)
  d3 <- new_NORMAL(0,1)
  
  # Setup the fixture
  if (exists(".Random.seed", .GlobalEnv))
    oldseed <- .GlobalEnv$.Random.seed
  else
    oldseed <- NULL
  
  set.seed(123456789)
  d4 <- d1 + d2
  set.seed(123456789)
  d5 <- d1 + d3
  
  s1 <- summary(d4)
  s2 <- summary(d5)
  
  expect_equal(s2,s2)
  
  # Return back the fixture
  if (!is.null(oldseed))
    .GlobalEnv$.Random.seed <- oldseed
  else
    rm(".Random.seed", envir = .GlobalEnv)
  
})


test_that("The set_seed function", {
  d1 <- new_NORMAL(1,0)
  s1 <- d1$seed
  d2 <- set_seed(d1,123456790)
  s2 <- d2$seed
  expect_equal(s2,123456790)
  expect_false(s1 == s2)
})
