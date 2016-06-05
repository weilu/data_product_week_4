library(shiny)
shinyUI(pageWithSidebar(
                        # Application title
                        headerPanel("Singapore HDB Resale Price"),
                        sidebarPanel(
                                     uiOutput("town"),
                                     uiOutput("address"),
                                     uiOutput("storey_range"),
                                     uiOutput("flat_type"),
                                     uiOutput("flat_model"),
                                     uiOutput("floor_area_sqm"),
                                     uiOutput("lease_commence_date"),
                                     submitButton('Submit')
                                     ),
                        mainPanel(h3('Predicted price trend of the next 6 months'),
                                  plotOutput('newHist')
                                  )
                        )
        )
