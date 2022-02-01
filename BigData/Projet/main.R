library("graphics")
library("lubridate")
library("dplyr")

# On charge les données
mydata = read.csv2("netflix_titles.csv", header = TRUE, sep = ",", dec =" ")
mydata = sample_n(mydata, 100)


# 1 - Est-ce que c'est vrai que le temps moyen entre la sortie du film et son ajout au carnet Netflix s'est raccourci ?

dateAjout = mydata[,"date_added"]
dateSortie = mydata[,"release_year"]
dateAjout = mdy(dateAjout)

# On convertit la colonne date_added de string au format data
dateAjout = as.POSIXct(dateAjout, format = "%Y/%M/%D")

# On passe du format de date complet au format année
dateAjout = format(dateAjout, format="%Y")

# On passe du format string en int
dateAjout = strtoi(dateAjout)

# On calcule la différence pour toutes les données
diffDateAjoutDateSortie = dateAjout - dateSortie

# On remplace avec le nouveau format
mydata["date_added"]=dateAjout

# On ajoute une colonne de différence dans le dataframe de base
mydata = cbind(mydata, diffDateAjoutDateSortie)


# On crée un nouveau dataframe avec les années non-dupliquées
dfParAnnee = mydata$date_added
dfParAnnee<-data.frame(dfParAnnee)
dfParAnnee <- dfParAnnee %>% group_by(dfParAnnee) %>% filter (! duplicated(dfParAnnee))





Moyenne <- sum(newdata$difference)/length(newdata$difference)
Moyenne <- mean(newdata$difference)
Moyenne 

Moyenne_2008 <- mean(newdata_2008$difference)