context("test-obhistory")

test_that("correct input", {
  expect_error(obhistory(2333), "id is not a string")
  expect_error(obhistory("KAADF"),"id is not 4 characters")
  expect_error(obhistory("AAAA"),"url is not valid, maybe not a correct ID")
  expect_error(obhistory(c("KORD", "KAVX")),"num of argument should be 1")
  expect_error(obhistory(), "num of argument should be 1")
})

test_that("return proper dataframe", {
  expect_equal(ncol(obhistory("KORD")),9)
})
