library(shiny)
library(tidyr)
library(readr)
library(leaflet)


data0 <- read_csv("DeltaX_Soil_Properties_Fall2020_Spring2021_Fall2021.csv")
dsp <- data0[!(data0$soil_bulk_density == "-9999"),]
dsp_latlong <- data0[,6:7]



data0$label <- with(data0, paste(
 
  "<strong> Normal Accretion: </strong>", normalized_accretion, 
  "</br> <strong> Soil bulk dens: </strong>", soil_bulk_density,
  "</br> <strong> Soil organic carb: </strong>", soil_organic_carbon,
  "</br> <strong> Soil organic carb dens: </strong>", soil_organic_carbon_density,
  "</br> <strong> Soil organic matter cont: </strong>", soil_organic_matter_content,

  sep = " "
  ))


attach(data0)




ui <- fluidPage(
  
  leafletOutput("mymap"),
  p(),

)



server <- function(input, output) {
  
  points <- eventReactive(input, {
            dsp_latlong
  }, ignoreNULL = FALSE)
  
  output$mymap <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$Stamen.Terrain,
                       options = providerTileOptions(noWrap = TRUE)
      ) %>%
      addCircleMarkers(data = points(),
                       popup = ~label,
                       radius = 3, 
                       color = "#8B4513",
      )
  })
 
}


shinyApp(ui = ui, server = server)
