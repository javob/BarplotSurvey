# BarplotSurvey app.R
rm(list = ls())


# Libraries
library(survey)
library(shiny)

# Get data and function
source("https://raw.githubusercontent.com/javob/BarplotSurvey/master/data/PrepareData.R", encoding = "UTF-8")
source("https://raw.githubusercontent.com/javob/BarplotSurvey/master/data/BarplotSurvey.R", encoding = "UTF-8")


ui <- fluidPage(
  headerPanel('Posiciones ideológicas'),
  sidebarPanel(
    selectInput("variable", "Seleccione una pregunta:",
                dataQuestions3),
    checkboxGroupInput("q1", "Género:",
                       c("Hombre" = 1,"Mujer" = 2),
                       c(1:2)),
    checkboxGroupInput("ur", "Población:",
                       c("Urbano" = 1,"Rural" = 2),
                       c(1:2)),
    checkboxGroupInput("etid", "Etnicidad:",
                       c("Mestiza" = 1,"Indígena" = 2,"Otra" = 3),
                       c(1:3)),
    checkboxGroupInput("q2", "Edad:",
                       c("De 18 a 25" = 1,"De 26 a 35" = 2,
                         "De 36 a 47" = 3,"De 48 a 91" = 4),
                       c(1:4))
  ),
  mainPanel(
    plotOutput('plot1')
  )
)

server <- function(input, output) {

  mainVar <- reactive({
    dataVars[as.numeric(strsplit(input$variable, "\\.")[[1]][1])]
  })
  
  selectedData <- reactive({
    list(q2 = as.numeric(input$q2),
         q1 = as.numeric(input$q1),
         etid = as.numeric(input$etid),
         ur = as.numeric(input$ur))
  })
  
  output$plot1 <- renderPlot({
    
    validate(
      need(suppressWarnings(input$q2 != "" & 
                              input$q1 != "" & 
                              input$etid != "" & 
                              input$ur != ""), 
           "Por favor seleccione al menos una característica." )
    )
    
    BarplotSurvey(variable = mainVar(), 
                  selected = selectedData())
  })

}


shinyApp(ui = ui, server = server)
