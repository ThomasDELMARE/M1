# Exercice 1

# 1 - On charge les données et on en sélectionne 10000 afin de ne récupérer que les données utiles
nonFilteredData <- read.csv2("wines.csv", header = TRUE, sep = ",", dec = " ", na.strings = "", stringsAsFactors = FALSE)
data = nonFilteredData[sample(nrow(nonFilteredData), 100), ]

# 2 - Pour chaque colonne calculez le pourcentage de donn´ees absentes ou marqu´ees comme NA
nbRowsData = nrow(data)
nombreNaDataX = (sum(is.na(data$X))/nbRowsData)*100
nombreNaDataCountry = (sum(is.na(data$country))/nbRowsData)*100
nombreNaDataDescryption = (sum(is.na(data$description))/nbRowsData)*100
nombreNaDataDesignation = (sum(is.na(data$designation))/nbRowsData)*100
nombreNaDataPoints = (sum(is.na(data$points))/nbRowsData)*100
nombreNaDataPrice = (sum(is.na(data$price))/nbRowsData)*100
nombreNaDataProvince = (sum(is.na(data$province))/nbRowsData)*100
nombreNaDataRegion1 = (sum(is.na(data$region_1))/nbRowsData)*100
nombreNaDataRegion2 = (sum(is.na(data$region_2))/nbRowsData)*100
nombreNaDataVariety = (sum(is.na(data$variety))/nbRowsData)*100
nombreNaDataWinery = (sum(is.na(data$winery))/nbRowsData)*100

# 3 - Calculez le pourcentage de lignes contenantes une valeur vide ou NA.
count = 0
for(i in 1:nrow(data)) {
  row <- data[i,]
  if(any(is.na(row))){
    count = count + 1
  }
}

pourcentageLigneVide = (count/nrow(data))*100

# Exercice 2

# 1 - Pour toute colonne numerique, remplacez les donnéees manquantes par la valeur moyenne de la colonne.
data[is.na(data)] <- 0
moyennePoints = sum(data$points)/nrow(data)
moyennePrice = sum(as.numeric(data$price))/nrow(data)
data[data==0] <- NA

# On remplaces les donnees par les moyennes
dataFilledWithMoyennes = data

for(i in 1:nrow(dataFilledWithMoyennes)){
  if(is.na(dataFilledWithMoyennes[i,6])==TRUE){
    dataFilledWithMoyennes[i,6]=moyennePrice
  }
  else if(is.na(dataFilledWithMoyennes[i,5])==TRUE){
    dataFilledWithMoyennes[i,5]=moyennePoints
  }
}

# 2 - Une autre possibilit´e, consiste `a remplacer les valeurs manquantes par la valeur la plus fr´equente dans la colonne.

# On remplace les données par la plus grande occurence

dataFilledWithMostCommonOccurence = data

for(i in 1:nrow(dataFilledWithMostCommonOccurence)){
  if(is.na(dataFilledWithMostCommonOccurence[i,6])==TRUE){
    dataFilledWithMostCommonOccurence[i,6]=mostCommonPrice
  }
  else if(is.na(dataFilledWithMostCommonOccurence[i,5])==TRUE){
    dataFilledWithMostCommonOccurence[i,5]=mostCommonPoints
  }
}

# 3 - Pour toute colonne contenante des valeurs manquantes cr´eez une diagramme qui compare les deux strat´egies pr´ec´edentes. Qu'en d´eduisez-vous ?
# Concenrnant les points, la différence entre les deux solutions sont égales. Concernant la comparaison des prix, les données sont très différentes les unes des autres.
x1 <- dataFilledWithMostCommonOccurence
x2 <- dataFilledWithMoyennes

x = c(x1$price)
y = c(x2$price)

type = c(x1$price) 
moyennes = c(x,y) 
moyennes = matrix(moyennes,nc=length(x1$price), nr=1, byrow=T)
colnames(moyennes) = type 
barplot(as.numeric(moyennes),beside=T, main="Comparaison des deux prix", ylab="Prix", xlab="Entité", legend.text = c("Occurence","Moyenne"), col=c("red", "green")) ; box() 

x = c(x1$points)
y = c(x2$points)

type = c(x1$points) 
moyennes = c(x,y) 
moyennes = matrix(moyennes,nc=length(x1$points), nr=1, byrow=T)
colnames(moyennes) = type 
barplot(as.numeric(moyennes),beside=T, main="Comparaison des deux points", ylab="Points", xlab="Entité", legend.text = c("Occurence","Moyenne"), col=c("black", "green")) ; box() 

# Exercice 3

# 1 - Classez les colonnes de votre BD en num´eriques, textuelles, ensemblistes, ordinales.

# X = numériques
# country = ensemblistes
# description = textuelle
# designation = textuelle
# points = numérique
# price = numérique
# province = ensembliste
# region_1 = ensembliste
# region_2 = ensembliste
# variety = ensembliste
# winery = ensembliste

# 2 - Autant que possible re-encodez chaque colonne non-num´erique avec les proc´ed´es donn´es dans les paragraphes pr´ec´edents.
dataOrdered <- data.frame(dataFilledWithMoyennes, stringsAsFactors = FALSE)
dataOrdered$country<-factor(dataOrdered$country)

test <- levels(dataOrdered$country)
testframe <- data.frame(test, stringsAsFactors = FALSE)
testframe$ID <- seq.int(nrow(testframe))
View(testframe)

# on change les values selon les nouvelles values
# dataOrdered[is.na(dataOrdered)] = 0
dataOrdered$country[match(dataOrdered$country, testframe$test)] = testframe$ID
