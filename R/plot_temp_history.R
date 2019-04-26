##' @name plot_temp_history
##' @title Plot 3 day (72 hours) temperature history of Selected Airport Location
##' @description This function plot a time series of 3 day temperature history for Selected Airports
##' @usage plot_temp_history(id)
##' @param id one 4 character airport code
##' @examples plot_temp_history("KAMW")
##' @import ggplot2
##' @importFrom lubridate as_datetime
##' @importFrom assertthat assert_that
##' @export
##'

plot_temp_history <- function(id=NULL){
  assertthat::assert_that((length(id) == 1), msg = "num of argument should be 1")
  assertthat::assert_that(is.character(id) , msg ="id is not a string")
  assertthat::assert_that(stringr::str_length(id) == 4, msg = "id is not 4 characters")
  #load("./data/all_code.rda")
  data(package = "weatherstar", "all_code")

  code <- all_code$Code
  assertthat::assert_that(id %in% code , msg = "not a correct ID")

  airportname <- all_code$Name[match(id, code)]
  weather_table <- obhistory(id)

  theme_set(theme_light()+
              theme(plot.title =
                      element_text(hjust = 0.5, size = 15, face = "bold"),
                                axis.title = element_text(size = 15)))

  weather_table %>% ggplot(aes(as_datetime(localtime), Temperature, color = hday )) +
    geom_line(na.rm=TRUE) +
    ggtitle(paste0("Temperatue history for the past 72 hours", " in ", airportname )) +
    xlab( "Time") +
    scale_x_datetime(breaks=scales::date_breaks("4 hour"), labels=scales::date_format("%H:%M"))

}



#plot_temp_history("KORD")
