library(shiny)
library(plotly)
library(shinyBS)
source("RaoultFunctions binary.R")

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  tags$head(tags$script(HTML('
                             Shiny.addCustomMessageHandler("jsCode",
                             function(message) {
                             eval(message.code);
                             }
  );
                             '))),
  
  # Application title
  titlePanel("Vapor-Liquid Equilibrium, Ideal state"),
  h4("A simple Vapor-Liquid Equilibrium calculator for a binary system."),
  p("It uses the Raoult's Law's equations with Antoine's Vapor Pressure formula.", br(),
    "App by ", strong("René Marves, ChE"), "for the Cousera Data Products class, August 2017."),
  # Sidebar inputs
  sidebarLayout(
    sidebarPanel(
      selectInput("Comp1name", label = "Component 1:",
                  choices = sort(AntoineCoef$compound.name),
                  selected = "ethanol"),
      bsTooltip(id = "Comp1name",
                title = "Select the first component of the binary system here", 
                placement = "right", trigger = "hover"),
      selectInput("Comp2name", label = "Component 2:",
                  choices = sort(AntoineCoef$compound.name),
                  selected = "water"),
      bsTooltip(id = "Comp2name",
                title = "Select the second component of the binary system here", 
                placement = "right", trigger = "hover"),
      radioButtons("systemType", label = NULL,
                   choiceNames = c("Constant Pressure", "Constant Temperature"),
                   choiceValues = c("cP", "cT"),
                   selected = "cP"),
      bsTooltip(id = "systemType",
                title = "Choose either constant temperature or constante pressure.", 
                placement = "right", trigger = "hover"),
      numericInput("Pres", "Enter Pressure (in kPa):", 
                   value = 101, min = 1, max = 101*5, step = 1),
      bsTooltip(id = "Pres", title = "Enter the pressure here. 101kPa is 1 atmosphere.",
                placement = "right", trigger = "hover"),
      numericInput("Temp", "Enter Temperature (in ºC):", 
                   value = 25, min = -273, max = 2000, step = 1),
      bsTooltip(id = "Temp", title = "Enter the TEmperature here, in degree Celcius. 25ºC is standard room temp.",
                placement = "right", trigger = "hover")
    ),
    
    # Show the VLE plot
    mainPanel(
      plotlyOutput("VLEplot")
    )
  ),
  p("Background theory:"),
  p('Whenever there is a liquid, part of that liquid evaporates, creating that liquid\'s vapor on the space 
    above it.  This vapor will exert a pressure in its environment. Whenever the pressure exerted by a 
    liquid\'s vapor is the same as the current atmospheric pressure, that liquid will boil and fully evaporate.
    This point where the pressure of the vapor is the same as the atmospheric pressure is called the "Bubble point".'),
  p('The "Dew Point" is the point where a vapor starts to condensate and become a liquid again.  For a pure 
    compound, the Dew Point and Bubble Points are always the same, but when a there is a mixture of liquids,
    these points deviate one from the other, giving a range of temperature or pressure over which the mixture
    is a combination of liquid and vapor.  This occurence is called the "Vapor-Liquid Equilibrium". It\'s this 
    phenomenon that allows for liquid combinations to be distilled and pure compounds obtained from a solution.'),
  p('The default system for this example is one of the most common ones there is: ethanol (also called rubbing
    alcohol or drinking alcohol) and water.  The model presented is an ideal one, which doesn\'t take into
    account the peculiarities of molecular interaction due to the each component\'s nature.  There are more
    exact models, but this is still the beginner\'s model for understanding the Equilibrium between liquids and
    vapors.'),
  p('Play around with this app to examine how diferent systems would behave.  The Plotly graph will allow you
    examine particular data points.  Keep in mind the units that are required and that standard conditions are
    101 kPa and 25ºC.  101 kPa equal the same pressure the atmosphere has at sea level and 25ºC is the standard
    room temperature.'),
  p("To learn more about Vapor-Liquid equilibrium in general, you can check out this article:", br(),
  HTML('<a href="https://en.wikibooks.org/wiki/Introduction_to_Chemical_Engineering_Processes/Vapor-Liquid_equilibrium">
         Introduction to Chemical Engineering Process/Vapor-Liquid equilibrium</a>')),
  p("More on Antoine's equation at:", HTML('<a href="https://en.wikipedia.org/wiki/Antoine_equation">Wikipedia: Antoine equation</a>')),
  p("More on Raoult's Law at:", HTML('<a href="https://en.wikipedia.org/wiki/Raoult%27s_law">Wikipedia: Raoult\'s Law</a>')),
  p("Reference to construct this app (Raoult's Law equations, Antoine equations and Antoine coefficients):", br(),
  em("Introduction to Thermodynamics in Chemical Engineering, 6th edition. Smith, Van Ness and Abbott.")),
  p('Source code in ', HTML('<a href="https://github.com/rfmarves/IdealVLEcalc">GitHub</a>'))
))
