library(shiny)
library(dplyr)
library(ggplot2)
library(DT)
library(readr)

data0 <- read_csv("DeltaX_Soil_Properties_Fall2020_Spring2021_Fall2021.csv")
dsp <- data0[!(data0$soil_bulk_density == "-9999"),]


ui <- fluidPage(
  fluidRow(
    column(width = 8, class = "well",
           h4("Left plot controls right plot"),
           fluidRow(
             column(width = 6,
                    plotOutput("plot2", height = 300, brush = brushOpts(id = "plot2_brush", resetOnNew = TRUE)),
                    ), 
             column(width = 6, plotOutput("plot3", height = 300))
             )
           ),
    ),
  fluidRow(
    column(width = 12, class = "well",
           h4("Data from the points"),
           dataTableOutput("table"),
           )
    
    )
  )



server <- function(input, output) {
  

  ranges2 <- reactiveValues(x = NULL, y = NULL)
  
  output$plot2 <- renderPlot({
    ggplot(dsp, aes(latitude, longitude, col = basin)) +
      geom_point()
  })
  
  output$plot3 <- renderPlot({
    ggplot(dsp, aes(latitude, longitude, col = basin)) +
      geom_point() +
      coord_cartesian(xlim = ranges2$x, ylim = ranges2$y, expand = FALSE)
  })
  
  observe({
    brush <- input$plot2_brush
    if (!is.null(brush)) {
      ranges2$x <- c(brush$xmin, brush$xmax)
      ranges2$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges2$x <- NULL
      ranges2$y <- NULL
    }
  })
  dat <- reactive({
    brush <- input$plot2_brush
    brushedPoints(dsp, brush)
  })
  
  output$table <- DT::renderDataTable({DT::datatable(dat())})
}


shinyApp(ui = ui, server = server)
