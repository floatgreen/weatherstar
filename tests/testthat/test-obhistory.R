context("test-obhistory")

test_that("correct input", {
  expect_error(obhistory(2333), "id is not a string")
  expect_error(obhistory("KAADF"),"id is not 4 characters")
  expect_error(obhistory("AAAA"),"not a correct ID")
})

test_that("ouput is appropriate dataframe", {
  expect_equal(ncol(obhistory("KORD")),7)
})
