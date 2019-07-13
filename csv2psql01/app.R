#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
source("said.R")


c2p <- function() {
  
  result <- new.env(emptyenv())

  result$said <- said("~/Desktop/XIX/wk-26/Hackathon 3.0/oxford university/challenge 9,10/said business school")
  
    
  result
}

my_csv_dictionary <- c2p()

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("CSV --> PSQL"),
   
   tableOutput("said")
   
)

# Define server logic required to draw a histogram
server <- function(input, output) {
 

   output$said <- renderTable( my_csv_dictionary$said$my_tables$Activities[[16]] %>% head() )
   
   
}

# Run the application 
shinyApp(ui = ui, server = server)

