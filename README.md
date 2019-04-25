  <!-- badges: start -->
[![Travis build status](https://travis-ci.org/floatgreen/weatherstar.svg?branch=master)](https://travis-ci.org/floatgreen/weatherstar)
  <!-- badges: end -->

  <!-- badges: start -->
  [![Codecov test coverage](https://codecov.io/gh/floatgreen/weatherstar/branch/master/graph/badge.svg)](https://codecov.io/gh/floatgreen/weatherstar?branch=master)
  <!-- badges: end -->



# weatherstar

The goal of weatherstar is to read the current weather component(s) from "https://w1.weather.gov/xml/current_obs/" and record the information as data frame or plot it on an US map.

## Installation

You can download the package "weatherstar" from [github](https://github.com/floatgreen/weatherstar), then install (build) it with ctrl+shift+B.

Or you can also install the package using `devtools`:

``` r
library(devtools)
install_github("floatgreen/weatherstar")
```

## Example

Followings are some examples which shows you how to use this package:  

- Read the history data of one airport.  

``` r
obhistory("KAMW")

```

- plot the 3 day history of a temperature changing


``` r
plot_temp_history("KORD")

```


## Shiny app

- Launch shiny spp, and you should see the panel as below

``` r
runShiny()
```

