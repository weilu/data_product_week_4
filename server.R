library(shiny)
library(zoo)
library(plyr)
library(reshape2)
library(xts)
library(forecast)

options(shiny.trace=TRUE)

data <- data.frame()

getOptions <- function(col) {
  colist <- sort(unique(data[, col]))
  return(c('Any', colist))
}
shinyServer(function(input, output) {

              withProgress(message = 'Loading data', value = 0, {
                data <- read.csv("./resale-flat-prices/resale-flat-prices-based-on-registration-date-from-march-2012-onwards.csv", stringsAsFactors = FALSE)
                incProgress(0.90, detail = "Transforming data")

                ## clean data
                data$month <- as.yearmon(data$month)
                # replace block and street with address
                data <- within(data, address <- paste(block, street_name))
                data <<- data[, -which(names(data) %in% c('block', 'street_name'))]
                incProgress(1, detail = "Done")
              })

              output$town <- renderUI({
                selectInput('town', 'Neighborhood', getOptions('town'))
              })
              output$address <- renderUI({
                selectInput('address', 'Address', getOptions('address'))
              })
              output$storey_range <- renderUI({
                selectInput('storey_range', 'Storey range', getOptions('storey_range'))
              })
              output$flat_type <- renderUI({
                selectInput('flat_type', 'Flat type', getOptions('flat_type'))
              })
              output$flat_model <- renderUI({
                selectInput('flat_model', 'Flat model', getOptions('flat_model'))
              })
              output$floor_area_sqm <- renderUI({
                selectInput('floor_area_sqm', 'Floor area sqm', getOptions('floor_area_sqm'))
              })
              output$lease_commence_date <- renderUI({
                selectInput('lease_commence_date', 'OTP year', getOptions('lease_commence_date'))
              })
              output$newHist <- renderPlot({
                if (length(names(input)) == 0) {
                  return()
                }

                dataFiltered <- data
                id_vars = c('month')
                for(name in names(input)) {
                  id_vars = c(id_vars, name)
                  input_value = input[[name]]
                  if (input_value == 'Any') {
                    next
                  }
                  dataFiltered <- dataFiltered[dataFiltered[, name] == input_value, ]
                  if (length(dataFiltered) == 0) return()
                }

                datamelt <- melt(dataFiltered, value.name="resale_price", id.vars=id_vars)
                datadcast <- dcast(datamelt, month ~ variable, mean)

                datats <- xts(datadcast$resale_price, order.by=datadcast$month)
                print(head(datats))
                projection = forecast(ets(datats), 6)
                plot(projection, ylab='Resale price (SGD)', xlab="Years + 1")
              })
})
