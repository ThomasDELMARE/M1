library(help="graphics")

# 1 - On charge les données
mydata <- read.csv2("deaths.csv", header = TRUE, sep = "", dec = " ")

# 2 - Afficher structure + noms colonnes premiere ligne
head(mydata, 1)

# 3 - Calcul de la somme totale des morts
sommeMorts <- sum(mydata$Total)

# 4 - Calcul de nombre total de morts en 1900
data1900 <- mydata[mydata[,"Year"]==1900,]

sommeMorts1900 <- sum(data1900$Total)

# 5 - Calculez la moyenne d'age des morts en 1900, 1943, 1960, 1980 et 1990
data1900 <- mydata[mydata[,"Year"]==1900,]
data1943 <- mydata[mydata[,"Year"]==1943,]
data1960 <- mydata[mydata[,"Year"]==1960,]
data1980 <- mydata[mydata[,"Year"]==1980,]
data1990 <- mydata[mydata[,"Year"]==1990,]

moyenneAgeMorts1900 <- sum(data1900$Age*data1900$Total)/sum(data1900$Total)
moyenneAgeMorts1943 <- sum(data1943$Age*data1943$Total)/sum(data1943$Total)
moyenneAgeMorts1960 <- sum(data1960$Age*data1960$Total)/sum(data1960$Total)
moyenneAgeMorts1980 <- sum(data1980$Age*data1980$Total)/sum(data1980$Total)
moyenneAgeMorts1990 <- sum(data1990$Age*data1990$Total)/sum(data1990$Total)

moyenneAgeMorts1900 <- round(moyenneAgeMorts1900, 2)
moyenneAgeMorts1943 <- round(moyenneAgeMorts1943, 2)
moyenneAgeMorts1960 <- round(moyenneAgeMorts1960, 2)
moyenneAgeMorts1980 <- round(moyenneAgeMorts1980, 2)
moyenneAgeMorts1990 <- round(moyenneAgeMorts1990, 2)

# 6 - Arrondies + virgule
moyenneAgeMorts1900 <- format(moyenneAgeMorts1900,decimal.mark = ",")
moyenneAgeMorts1943 <- format(moyenneAgeMorts1943,decimal.mark = ",")
moyenneAgeMorts1960 <- format(moyenneAgeMorts1960,decimal.mark = ",")
moyenneAgeMorts1980 <- format(moyenneAgeMorts1980,decimal.mark = ",")
moyenneAgeMorts1990 <- format(moyenneAgeMorts1990,decimal.mark = ",")

# 7 - Probabilités
data1899 <- mydata[mydata[,"Year"]==1899,]

data0an1899 <- data1899[data1899[,"Age"]==0,]
data0an1990 <- data1990[data1990[,"Age"]==0,]

proba1899 <- round(((sum(data0an1899$Total)/sum(data1899$Total))*100),2)
proba1990 <- round(((sum(data0an1990$Total)/sum(data1990$Total))*100),2)

