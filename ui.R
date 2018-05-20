#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Monty Hall Simulation"),
  fluidRow(column(12, mainPanel(p("by Jordi Vilaplana")))),
  
  # Sidebar with a slider input for number of bins 
  fluidRow(
      column(4,
             wellPanel(
                 sliderInput("games",
                             "Number of games:",
                             min = 1,
                             max = 1000,
                             value = 100),
                 selectInput("strategy",
                             "Strategy",
                             choices = c("Stay" = "stay", "Change" = "change", "Random" = "random"))
             )
             ),
           column(8,
                  mainPanel(
                      plotOutput("resultChart")
                  )
      )),
    
  fluidRow(column(12, DT::dataTableOutput("resultTable")))
))
