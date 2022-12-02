library(shiny)
library(readr)
library(tidyr)
library(ggplot2)

data0 <- read_csv("Data/DeltaX_Soil_Properties_Fall2020_Spring2021_Fall2021.csv")
data2 <- data0[!(data0$time_marker_sampled=="-9999"),]
Atchafalaya_data <- data2[!(data2$basin == "Terrebonne"),]
Terrebonne_data <- data2[!(data2$basin == "Atchafalaya"),]

ui <- fluidPage(
  h1("Delta X - Soil Properties"),
  tabsetPanel(
    
    tabPanel("Soil Bulk Density",
             sidebarLayout(
            
                  selectInput( inputId = "select1", 
                               label = "Sections of data", 
                               choices = c("Atchafalaya", "Terrebonne")),
                  
                  mainPanel(plotOutput(outputId = "hist1")),
                        )
          ),
    
    tabPanel("Soil Organic Matter Content",
               
                  selectInput( inputId = "select2", 
                               label = "Sections of data", 
                               choices = c("Atchafalaya", "Terrebonne")),
             
                   mainPanel(plotOutput(outputId = "hist2")),
    
    ),
    
    tabPanel("Soil Organic Carbon",
             
             selectInput( inputId = "select3", 
                          label = "Sections of data", 
                          choices = c("Atchafalaya", "Terrebonne")),
             
             mainPanel(plotOutput(outputId = "hist3")),
             ),

    
   tabPanel("Soil Organic Carbon Density",
             
             selectInput( inputId = "select4", 
                          label = "Sections of data", 
                          choices = c("Atchafalaya", "Terrebonne")),
             
             mainPanel(plotOutput(outputId = "hist4")),
    ),
  )
)




server <- function(input, output) {
  
  output$hist1 <- renderPlot({
    
    data1 <- get(paste0(input$select1, "_data"))$soil_bulk_density
    
    hist(data1,
         main = paste("Histogram of", input$select1),
         breaks = 100,
         xlab = "Soil Bulk Density",
         col = "red"
         
         
         )
    
  })
  
  output$hist2 <- renderPlot({
    
    data2 <- get(paste0(input$select2, "_data"))$soil_organic_matter_content
    
    hist(data2,
         main = paste("Histogram of", input$select2),
         breaks = 100,
         xlab = "Soil Organic Matter",
         col = "red"
    )
    
  })
  
  output$hist3 <- renderPlot({
    
    data3 <- get(paste0(input$select3, "_data"))$soil_organic_carbon
    
    hist(data3,
         main = paste("Histogram of", input$select3),
         breaks = 100,
         xlab = "Soil Organic Carbon",
         col = "red"
    )
    
  })
  
  output$hist4 <- renderPlot({
    
    data4 <- get(paste0(input$select4, "_data"))$soil_organic_carbon_density
    
    hist(data4,
         main = paste("Histogram of", input$select4),
         breaks = 100,
         xlab = "Soil Organic Carbon Density",
         col = "red"
        )
    
    })
 
}


shinyApp(ui = ui, server = server)