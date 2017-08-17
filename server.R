library(shiny)
library(plotly)
library(shinyBS)

source("RaultFunctions binary.R")

# Starting x values for plot
x.y <- 1:100/100

# Server logic
shinyServer(function(input, output, session) {
# Observes for changes to enable/disable Temperature and Pressure fields  
  observe({
    if(input$systemType == "cP") {
      session$sendCustomMessage(type="jsCode",
                                list(code= "$('#Temp').prop('disabled',true)"))
      session$sendCustomMessage(type="jsCode",
                                list(code= "$('#Pres').prop('disabled',false)"))
    } else {
      session$sendCustomMessage(type="jsCode",
                                list(code= "$('#Temp').prop('disabled',false)"))
      session$sendCustomMessage(type="jsCode",
                                list(code= "$('#Pres').prop('disabled',true)"))
    }
  })

# Plotly graph logic. One graph for constant T and another for constant P  
  output$VLEplot <- renderPlotly({
    comps <- c(CompID(input$Comp1name), CompID(input$Comp2name))
    if(input$systemType == "cP") {
      tf <- as.data.frame(
        cbind("Fraction" = x.y, "Dew.Temperature" = Tdew(x.y,input$Pres,comps),
              "Bubble.Temperature" = Tbubl(x.y,input$Pres,comps)))
      plot_ly(tf, x = ~Fraction) %>% 
      add_lines(y = ~Dew.Temperature, name = "Dew Temperature", line = list(color = 'rgb(204,0,0)')) %>% 
      add_lines(y = ~Bubble.Temperature, name = "Bubble Temperature", line = list(color = 'rgb(0,0,153)')) %>% 
      layout(yaxis=list(title = "Temperature (ÂºC)"))
    } else {
      tf <- as.data.frame(
        cbind("Fraction" = x.y, "Dew.Pressure" = Pdew(x.y,input$Temp,comps),
              "Bubble.Pressure" = Pbubl(x.y,input$Temp,comps)))
      plot_ly(tf, x = ~Fraction) %>% 
        add_lines(y = ~Dew.Pressure, name = "Dew Pressure", line = list(color = 'rgb(204,0,0)')) %>% 
        add_lines(y = ~Bubble.Pressure, name = "Bubble Pressure", line = list(color = 'rgb(0,0,153)')) %>% 
        layout(yaxis=list(title = "Pressure (mmHg)"))
    }
  })
  
})