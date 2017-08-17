# Loads data
AntoineCoef <- read.table("AntoineCoef_SmithVanNessAbbott.txt", sep = "\t", header = TRUE)
AntoineCoef$formula <- as.character(AntoineCoef$formula)
AntoineCoef$compound.name <- as.character(AntoineCoef$compound.name)

AllComps <- 
  function(){
    return(AntoineCoef$compound.name)
  }

CompName <-
  function(ID){
    return(AntoineCoef$compound.name[ID])
  }

CompID <-
  function(name){
    return(AntoineCoef$ID[AntoineCoef$compound.name == name])
  }

CompFormula <-
  function(ID){
    return(AntoineCoef$formula[ID])
  }

Psat <-
  function(temp, ID){
    pres <- exp(AntoineCoef$A[ID]-(AntoineCoef$B[ID]/(temp + AntoineCoef$C[ID])))
    return(pres)
  }

Tsat <-
  function(pres, ID){
    temp <- AntoineCoef$B[ID]/(AntoineCoef$A[ID]-log(pres)) - AntoineCoef$C[ID]
    return(temp)
  }
