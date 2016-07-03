library(shiny)
shinyUI(pageWithSidebar(
                        headerPanel("Singapore Public Housing Resale Price"),
                        sidebarPanel(p('You may narrow your search by specifying one or more of the dimensions below, or leave all of them as "Any" for the aggregated results.'),
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
                                  h5('based on transaction prices available since March 2012 (solid black line)'),
                                  plotOutput('newHist')
                                  )
                        )
        )
