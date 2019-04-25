context("test-plot_temp_history")


test_that("correct input", {
  expect_error(plot_temp_history(2333), "id is not a string")
  expect_error(plot_temp_history("KAADF"),"id is not 4 characters")
  expect_error(plot_temp_history("AAAA"),"not a correct ID")
  expect_error(plot_temp_history(c("KORD", "KAVX")),"num of argument should be 1")
  expect_error(plot_temp_history(), "num of argument should be 1")
})


test_that("return proper plot ",{
  expect_equal(class(plot_temp_history("KAMW")),c("gg","ggplot"))
})



