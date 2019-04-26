server <- function(input, output) {
  output$plot_temp <- renderPlot({
    plot_temp_history(input$code)
  })
  output$table <- renderDataTable( obhistory(input$code))
}
