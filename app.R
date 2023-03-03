
library(shiny)
library(tidyverse)

sleep <- read_delim("Sleep_Efficiency.csv")

ui <- fluidPage(

  tabsetPanel(
    
    tabPanel("About",
      titlePanel("Sleep Efficiency"),
      p("This app uses information about the sleep habits of people ages 9-69\n"),
      p("This includes data on habits that may effect sleep such as ", strong("caffiene, 
        alcohol, smoking,"), "and,", strong("exercise\n")),
      p("This dataset contains", nrow(sleep), " and", ncol(sleep), "columns\n"),
      p("Here is a small", em("random"), "sample of data:"),
      tableOutput("sample")
    ),
    
    tabPanel("Plot"),
    
    tabPanel("Table")
  )
  
)


server <- function(input, output) {
  
  output$sample <- renderTable({
    sleep %>% 
      sample_n(5)
  })
  
  
}

 
shinyApp(ui = ui, server = server)
