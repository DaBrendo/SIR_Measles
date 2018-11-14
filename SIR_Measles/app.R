#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(ggplot2)
library(rgdal)
library(RColorBrewer)
library(leaflet)
library(dplyr)

r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()

# Define server logic
server <- function(input, output, session) {
  
  points <- eventReactive(input$recalc, {
    cbind(rnorm(40) - 105, rnorm(40) + 39)
  }, ignoreNULL = FALSE)
  
  output$mymap <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$OpenMapSurfer.AdminBounds,
                       options = providerTileOptions(noWrap = FALSE),
                       group = "Administrative Boundries"
      ) %>%
      addProviderTiles(providers$Stamen.TonerLite,
                       options = providerTileOptions(noWrap = FALSE),
                       group = "Pretty Map"
      ) %>%
      addMarkers(data = points(), popup = "I am a School (maybe)!"
      ) %>%
      addLayersControl(
          baseGroups = c("Administrative Boundries", "Pretty Map"),
          options = layersControlOptions(collapsed = FALSE))
      })
}

# Define UI for application
ui <- dashboardPage(
    dashboardHeader(title = "Schools in Colorado"),
    dashboardSidebar(),
    dashboardBody(
      tags$style(type = "text/css", "#mymap {height: calc(100vh - 80px) !important;}"),
      leafletOutput("mymap", width = '100%', height = 800)
    )
  )



# Run the application 
shinyApp(ui = ui, server = server)

