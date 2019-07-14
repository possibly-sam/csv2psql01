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

# my_csv_dictionary <- c2p()

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  tags$head(tags$script(src = "message-handler.js")),
   
   # Application title
   titlePanel("CSV --> PSQL"),
   textInput("some_file", "Some File", "~/Desktop/XIX/wk-26/Hackathon 3.0/oxford university/challenge 9,10/said business school/2016/Activities.csv" ),
   textInput("table_name", "Table Name", "Activities16"),
  actionButton("go", "Go!"),
   
   tableOutput("said")
   
)




m_stuff <- "silly"

# /home/phillip/Desktop/XIX/wk-26/Hackathon 3.0/oxford university/challenge 9,10/said business school/2016/Activities.csv
# Define server logic required to draw a histogram
server <- function(input, output, session) {
 
  
  
  x0 <- reactive({
    result <- read.csv(input$some_file)
    result <- result %>% psql_sanitize()
    result %>% write.csv("out.csv")
    result

  })
  
  x1 <- reactive( {
    result <- psql_meta(x0(), input$table_name)
    result
  })
  
   output$said <- renderTable(  { 
     x1() 
   }     ) 
   
   observeEvent(input$go, {

     x0 <- read.csv(input$some_file)
     x0 <- psql_sanitize(x0)
     x0 %>% write.csv("out.csv")
     
     x1 <- psql_meta(x0, input$table_name)
     m_stuff <- x1$x0

     session$sendCustomMessage(type = 'testmessage',
                               message = 'Thank you for clicking')
   })   
   
}

# Run the application 
shinyApp(ui = ui, server = server)

