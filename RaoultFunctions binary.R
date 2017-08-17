# Functions for the Ideal Vapor-Liquid Equilibrium.  Arranged for a binary (2 component) system.

# Loads the functions and data for the Antoine Equations
source("AntoineFunctions.R")

# Presicion used for iterative functions
pres <- 0.0000001

# Bubble Pressure
Pbubl <- 
  function(x1, t, IDs){
    return(x1*Psat(t,IDs[1])+(1-x1)*Psat(t,IDs[2]))
  }

# Dew Pressure
Pdew <-
  function(y1, t, IDs){
    return(1/(y1/Psat(t,IDs[1])+(1-y1)/Psat(t,IDs[2])))
  }

# Bubble vapor fraction for constant Pressure scenario
yPbubl <- 
  function(x1, t, IDs){
    x <- c(x1,1-x1)
    return(x*Psat(t, IDs)/Pbubl(x,t,IDs))
  }

# Bubble liquid fraction  for constant Pressure scenario
xPdew <-
  function(y1, t, IDs){
    y <- c(y1, 1-y1)
    return(y*Pdew(y, t, IDs)/Psat(t, IDs))
  }

# Bubble Temperature
Tbubl <- 
  function(x1, P, IDs){
    x <- c(x1,1-x1)
    # Initial iteration parameters
    t <- sum(Tsat(P,IDs)/2)
    # Sets initial alpha value
    alpha <- 1
    # Iterative loop
    while(abs(alpha-Psat(t,IDs[1])/Psat(t,IDs[2]))>pres){
      alpha <- Psat(t,IDs[1])/Psat(t,IDs[2])
      P2 <- P / (x1*alpha + 1-x1)
      t <- Tsat(P2,IDs[2])
    }
    return(t)
  }

# Dew Temperature
Tdew <-
  function(y1, P, IDs){
    # Initial iteration parameters
    t <- sum(Tsat(P,IDs)/2)
    # Sets initial alpha value
    alpha <- 1
    # Iterative loop
    while(abs(alpha-Psat(t,IDs[1])/Psat(t,IDs[2]))>pres){
        alpha <- Psat(t,IDs[1])/Psat(t,IDs[2])
        P1 <- P * (y1 + (1-y1)*alpha)
        t <- Tsat(P1,IDs[1])
    }
    return(t)
  }

# Dew liquid fraction in a constant Temperature scenario
xTdew <-
  function(y1, P, IDs){
    y <- c(y1, 1-y1)
    return(y*P/Psat(Tdew(y, P, IDs),IDs))
  }

# Dew vapor fraction in a constant Temperature scenario
yTdew <-
  function(x1, P, IDs){
    x <- c(x1, 1-x1)
    return(x*Psat(Tbubl(x,P,IDs),IDs)/P)
  }
