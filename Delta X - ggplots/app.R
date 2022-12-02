library(shiny)
library(readr)
library(ggplot2)
library(dplyr)

data0 <- read_csv("DeltaX_Soil_Properties_Fall2020_Spring2021_Fall2021.csv")
data1 <- data0[!(data0$time_marker_sampled == "-9999"),]
attach(data1)

ui <- fluidPage(
  fluidRow(
    column(width = 4,
           
           selectInput(inputId = "select1",
                       label = "select the x-axis",
                       choices = c("elevation_navd88", "sediment_accretion", "days_between_sampling_and_deployment", "normalized_accretion", "soil_bulk_density", "soil_organic_matter_content", "soil_organic_carbon", "soil_organic_carbon_density"),
                       selected = "soil_bulk_density"
           ),
           
           selectInput(inputId = "select2",
                       label = "select the y-axis",
                       choices = c("elevation_navd88", "sediment_accretion", "days_between_sampling_and_deployment", "normalized_accretion", "soil_bulk_density", "soil_organic_matter_content", "soil_organic_carbon", "soil_organic_carbon_density"),
                       selected = "soil_organic_carbon"
           ),
    ),
    column(width = 4, offset = 2,
           selectInput(inputId = "select3",
                       label = "Color each point according to:",
                       choices = c("basin", "campaign", "site_id", "elevation_navd88", "hydrogeomorphic_zone", "latitude", "longitude", "station", "time_marker_deployed", "time_marker_sampled"),
                       selected = "site_id"
           ),
    )
  ),
  submitButton(text = "Apply Changes", icon = NULL, width = NULL),
  
  plotOutput(outputId = "myplot")
  
)


server <- function(input, output) {
  
  
  output$myplot <- renderPlot({
    
    
    data1 %>%
      ggplot(aes(x = get(paste(input$select1)), y = get(paste(input$select2)), col = get(paste(input$select3))
      )
      )+
      geom_point(alpha = 0.8)+
      labs(x = paste(input$select1), 
           y = paste(input$select2), 
           col = paste(input$select3))
    
  })
  
}


shinyApp(ui = ui, server = server)
