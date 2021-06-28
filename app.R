##################################################
## Project: Rescue the Princess
## File name: app.R
## Date: Fri Jun 25 16:47:13 2021
## Author: Peng
## R_Version: R version 4.0.2 (2020-06-22)
## R_Studio_Version: 1.4.1106
## Platform Version: Windows 10 x64 (build 19042)
##################################################


# # pre-loaded data&library -----------------------------------------------
# Load packages ----
library(shiny)
library(maps)
library(mapproj)

# Load data ----
counties <- readRDS("./app-census/data/counties.rds")

# Source helper functions -----
source("helpers.R")

# User interface ----
ui <- fluidPage(
  titlePanel("censusVis"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with 
        information from the 2010 US Census."),
      
      selectInput("var", 
                  label = "Choose a variable to display",
                  choices = c("Percent White", "Percent Black",
                              "Percent Hispanic", "Percent Asian"),
                  selected = "Percent White"),
      
      sliderInput("range", 
                  label = "Range of interest:",
                  min = 0, max = 100, value = c(0, 100))
    ),
    
    mainPanel(plotOutput("map"))
  )
)

# Server logic ----
server <- function(input, output) {
  output$map <- renderPlot({
    data <- switch(input$var, 
                   "Percent White" = counties$white,
                   "Percent Black" = counties$black,
                   "Percent Hispanic" = counties$hispanic,
                   "Percent Asian" = counties$asian)
    
    color <- switch(input$var, 
                    "Percent White" = "darkgreen",
                    "Percent Black" = "black",
                    "Percent Hispanic" = "darkorange",
                    "Percent Asian" = "darkviolet")
    legend<- switch(input$var, 
                           "Percent White" = "% White",
                           "Percent Black" = '% Black',
                           "Percent Hispanic" = '% Hispanic',
                           "Percent Asian" = '% Asian')
    percent_map(data, color, legend, input$range[1], input$range[2])
  })
}

# Run app ----
shinyApp(ui, server)