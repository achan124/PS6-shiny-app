
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
    
    tabPanel("Plot",
             sidebarLayout(
               sidebarPanel(
                 p("Here we can see the changes in sleep duration based on a person's exercise frequency and age"),
                 sliderInput("range", "Select age range:",
                             min = 9, 
                             max = 69,
                             value = c(9, 69)),
                 checkboxGroupInput("frequency", "Select number days exercised per week:",
                                    choices = c(0.0, 1.0, 2.0, 3.0, 4.0, 5.0),
                                    selected = 0),
                 radioButtons("color", "Select color palette:",
                              choices = c("Set1", "Set2", "Set3"))
               ),
               mainPanel(
                 plotOutput("plot")
               )
             )
    ),
    
    tabPanel("Table",
             sidebarLayout(
               
               sidebarPanel(
                 p("Here, we can see the effect that different substances have on a person's sleep quality"),
                 radioButtons("substance", "Select a habit:",
                              choices = c("Caffeine consumption", "Alcohol consumption", "Smoking status"),
                              selected = "Caffeine consumption")
               ),
               
               mainPanel(
                 tableOutput("table")
               )
               
             )
             
    )
    
    
  )
)


server <- function(input, output) {
  
  output$sample <- renderTable({
    sleep %>% 
      sample_n(5)
  })
  
  plotSample <- reactive({
    sleep[input$range[1]:input$range[2], ] %>% 
      filter(`Exercise frequency` %in% input$frequency)
  })
  
  output$plot <- renderPlot({
    plotSample() %>%  
      ggplot(aes(`Age`, `Sleep duration`, col = as.factor(`Sleep duration`))) +
      geom_point() +
      labs(col = "Hours") +
      scale_color_brewer(palette = input$color)
  })
  
  tableSample <- reactive({
    sleep %>% 
      filter(!is.na(`Awakenings`), !is.na(`Caffeine consumption`), !is.na(`Alcohol consumption`)) %>% 
      select(`Awakenings`, input$substance) %>% 
      arrange(`Awakenings`)
  })
  
  output$table <- renderTable({
    tableSample()
  })
  
}


shinyApp(ui = ui, server = server)
