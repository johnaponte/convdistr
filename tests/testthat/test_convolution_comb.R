# Test fo convolution_comb
# 20181106 by JJAV
# # # # # # # # # # # # # # # # # # 

context("The convolution combinations")

test_that(
  "The new_CONVOLUTION_comb works", {
    d1 <- new_MULTINORMAL(c(100, 200), matrix(c(1, 0.2, 0.2, 1), ncol = 2))
    d2 <- new_DIRICHLET(c(10, 90))
    comb <- new_CONVOLUTION_comb(d1, d2, `*`)
    expect_equal(length(dimnames(comb)), 4)
    drawns <- rfunc(comb,10)
    expect_equal(ncol(drawns),4)
    expect_equal(nrow(drawns),10)
}
)

test_that(
  "The add_total works", {
    d1 <- new_DIRICHLET(c(10,20,70))
    d2 <- add_total(d1)
    expect_equal(length(dimnames(d2)),4)
    expect_equal(d2$oval[4], c(TOTAL = 1))
    rd2 <- rfunc(d2,10)
    expect_equal(ncol(rd2),4)
    expect_equal(nrow(rd2),10)
    expect_equal(rd2[,4], rep(1,10))
  }
)