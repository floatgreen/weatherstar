data(package = "weatherstar", "all_code")
codes <- all_code$Code

ui <- fluidPage(

  titlePanel("Plot Temperature History"),

  sidebarPanel(
    selectInput("code", "airport code", choices = codes  )
  ),

  mainPanel(
    plotOutput("plot_temp"),
    dataTableOutput("table")
  )
)
