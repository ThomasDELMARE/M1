library("graphics")
library("lubridate")
library("dplyr")

# On charge les donn�es
mydata = read.csv2("netflix_titles.csv", header = TRUE, sep = ",", dec =" ")
mydata = sample_n(mydata, 100)


# 1 - Est-ce que c'est vrai que le temps moyen entre la sortie du film et son ajout au carnet Netflix s'est raccourci ?

dateAjout = mydata[,"date_added"]
dateSortie = mydata[,"release_year"]
dateAjout = mdy(dateAjout)

# On convertit la colonne date_added de string au format data
dateAjout = as.POSIXct(dateAjout, format = "%Y/%M/%D")

# On passe du format de date complet au format ann�e
dateAjout = format(dateAjout, format="%Y")

# On passe du format string en int
dateAjout = strtoi(dateAjout)

# On calcule la diff�rence pour toutes les donn�es
diffDateAjoutDateSortie = dateAjout - dateSortie

# On remplace avec le nouveau format
mydata["date_added"]=dateAjout

# On ajoute une colonne de diff�rence dans le dataframe de base
mydata = cbind(mydata, diffDateAjoutDateSortie)


# On cr�e un nouveau dataframe avec les ann�es non-dupliqu�es
dfParAnnee = mydata$date_added
dfParAnnee<-data.frame(dfParAnnee)
dfParAnnee <- dfParAnnee %>% group_by(dfParAnnee) %>% filter (! duplicated(dfParAnnee))





Moyenne <- sum(newdata$difference)/length(newdata$difference)
Moyenne <- mean(newdata$difference)
Moyenne 

Moyenne_2008 <- mean(newdata_2008$difference)