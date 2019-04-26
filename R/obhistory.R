##' @name  obhistory
##' @title Read weather observation history of One Airport Location
##' @description This function read a table from an html page from National Weather Service website and output a dataframe
##' @usage obhistory(id)
##' @param id one 4 character airport code
##' @return a data frame with 7 variabes descripting the weather history of Weather and Temperature
##' @examples obhistory("KAMW")
##' @importFrom lubridate days hours
##' @importFrom assertthat assert_that
##' @importFrom dplyr if_else mutate
##' @export

obhistory <- function(id=NULL){
  assertthat::assert_that((length(id) == 1), msg = "num of argument should be 1")
  assertthat::assert_that(is.character(id) , msg = "id is not a string")
  assertthat::assert_that(stringr::str_length(id) == 4, msg = "id is not 4 characters")
  #load("./data/all_code.rda")
  data(package = "weatherstar", "all_code")
  code <- all_code$Code
  assertthat::assert_that(id %in% code , msg = "not a correct ID")

  webpage <- xml2::read_html(paste("https://w1.weather.gov/data/obhistory/", id, ".html", sep = ""))
  tbls_ls <- webpage %>%
    rvest::html_nodes("table") %>%
    .[4] %>%
    rvest::html_table(fill = TRUE)

  weather_table <- tbls_ls[[1]] %>% .[c(1,2,5,7)]%>% tail(-2) %>% head(-3)
  names(weather_table) <- c("date", "time", "Weather", "Temperature")
  weather_table$Weather <- as.factor(weather_table$Weather)
  weather_table$Temperature <- as.numeric(weather_table$Temperature)
  nobs <- nrow(weather_table) # total number of obs

  # to get current time from current weather XML
  current <- xml2::read_xml(paste0("https://w1.weather.gov/xml/current_obs/", id ,".xml"))
  current_obs_time <- current %>% xml2::xml_children()%>%
    xml2::xml_text()%>%.[10]

  TZ <- tail(unlist(strsplit(current_obs_time, " ")), 1)

  current_obs_time <- lubridate::mdy_hm(current_obs_time)
  crtdate <-as.character(as.Date(current_obs_time))
  weather_table$crt_date <- crtdate  # add a new column of current date

  # paste the date and time
  weather_table$fulltime <- with(weather_table, as.POSIXct(paste(crt_date, time), tz = "UTC" ))

  udate <- unique(weather_table$date) # different date, could be (2,1,31,32)
  nd <- length(unique(weather_table$date)) # number of different date

  for (i in 1:nd){
    weather_table$day[weather_table$date == udate[i]] <- nd -i + 1
  }

  # fulltime has the same value as local time but in UTC
  weather_table$fulltime <- weather_table$fulltime - days(nd - weather_table$day)
  weather_table$localtime <- as.character(weather_table$fulltime) # local time


  # deal with hday: first, second, thirs 24 hours
  last_obs_time<- weather_table$fulltime[1]

  weather_table <- weather_table %>%
    dplyr::mutate (hday = if_else(as.numeric(last_obs_time - fulltime) < 86400, "third24hours",
                           if_else(as.numeric(last_obs_time - fulltime) < 172800, "second24hours", "first24hours")))

  # transfer to true time, based on TZ, time_UTC
  shift <- if_else(TZ =="EDT", 4,
                   if_else(TZ %in% c("CDT","EST"), 5,
                           if_else(TZ %in% c("MDT","CST"), 6,
                                   if_else(TZ %in% c("PDT","MST"), 7,
                                           if_else(TZ%in% c("AKDT","PST"), 8,
                                                   if_else(TZ == "AKST", 9,
                                                           if_else(TZ == "HST",10,0)))))))

  weather_table$time_UTC <-  weather_table$fulltime - hours(shift)

  # reverse the dataset
  weather_table<- weather_table %>% purrr::map_df(rev)

  histweather <- weather_table %>% dplyr::select(date, time, localtime, time_UTC, Weather, Temperature, hday)

  assertthat::assert_that(is.data.frame(histweather))
  return(histweather)
}

# example
# obhistory("KAMW")
