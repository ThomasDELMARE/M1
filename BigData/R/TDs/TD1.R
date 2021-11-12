# PERMET DE DEBUGGER
Sys.setlocale("LC_ALL", "fr_FR.UTF8"):

# On charge les données
  mydata <- read.csv2("deaths.csv", header = TRUE, sep = "", dec = ".")
  