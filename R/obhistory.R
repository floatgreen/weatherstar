##' @name  obhistory
##' @title Read weather observation history of One Airport Location
##' @description This function read a table from an html page from National Weather Service website and output a dataframe
##' @usage obhistory(id)
##' @param id one 4 character airport code
##' @return a data frame with 7 variabes descripting the weather history of Weather and Temperature
##' @examples obhistory("KAMW")
##' @importFrom lubridate days
##' @importFrom assertthat assert_that
##' @export

obhistory <- function(id=NULL){
  assertthat::assert_that((length(id) == 1), msg = "num of argument should be 1")
  assertthat::assert_that(is.character(id) , msg = "id is not a string")
  assertthat::assert_that(stringr::str_length(id) == 4, msg = "id is not 4 characters")
  #load("./data/all_code.rda")
  data(package = "weatherstar", "all_code")
  code <- all_code$Code
  assert_that(id %in% code , msg = "not a correct ID")

  webpage <- xml2::read_html(paste("https://w1.weather.gov/data/obhistory/", id, ".html", sep = ""))

  tbls_ls <- webpage %>%
    rvest::html_nodes("table") %>%
    .[4] %>%
    rvest::html_table(fill = TRUE)

  weather_table <- tbls_ls[[1]] %>% .[c(1,2,5,7)]%>% tail(-2) %>% head(-3)
  names(weather_table) <- c("date", "time", "Weather", "Temperature")
  weather_table<- weather_table %>% purrr::map_df(rev) # reverse the dataset

  weather_table$Weather <- as.factor(weather_table$Weather)
  weather_table$Temperature <- as.numeric(weather_table$Temperature)

  nobs <- nrow(weather_table)
  n<- ceiling(nobs/3)
  weather_table$hday  <- c(rep("first24hrs", n), rep("second24hrs", n), rep("third24hrs", nobs - 2*n))
  weather_table$hday <- as.factor(weather_table$hday)

  weather_table$t<- as.POSIXct(weather_table$time, format="%H:%M")
  weather_table$day <- as.numeric(as.factor(weather_table$date))
  nd <- nlevels(as.factor(weather_table$day))
  #true time
  weather_table$fulltime <- weather_table$t - days(nd - weather_table$day)

  histweather <- weather_table %>% dplyr::select(day, date, time, fulltime,  Weather, Temperature, hday)
  assertthat::assert_that(is.data.frame(histweather))
  return(histweather)
}

# example
# obhistory("KAMW")
