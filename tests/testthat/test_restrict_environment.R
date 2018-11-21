# Test for restrict envirnoment
# 20181026 by JJAV
# # # # # # # # # # # # # # # # #

context("Test for restrict_enviromnent")

test_that("restrict envirnoment works", {
   a = 0
   b = 1
   c = "Not in my environment"

   # Without restriction
   unrestricted_function <- function(n) { rnorm(n,a,b)}
   expect_true("c" %in% ls(envir = environment(unrestricted_function)))

   # With restriction
    restricted_function <-
    restrict_environment(
      function(n) {
        rnorm(n,meanvalue, sdvalue)
      },
       meanvalue = a, sdvalue = b)
    expect_true( !"c" %in% ls(envir = environment(restricted_function)))
})
