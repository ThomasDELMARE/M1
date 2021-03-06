# 1 - On charge les donn�es
mydata <- read.csv2("deaths.csv", header = TRUE, sep = "", dec = " ")

# 2 - Afficher structure + noms colonnes premiere ligne
head(mydata, 1)

# 3 - Calcul de la somme totale des morts
sommeMorts <- sum(mydata$Total)

# 4 - Calcul de nombre total de morts en 1900
data1900 <- mydata[mydata[,"Year"]==1900,]
data1900 <- subset(mydata,Year==1900)

sommeMorts1900 <- sum(data1900$Total)

# 5 - Calculez la moyenne d'age des morts en 1900, 1943, 1960, 1980 et 1990
data1900 <- subset(mydata,Year==1900)
data1943 <- subset(mydata,Year==1943)
data1960 <- subset(mydata,Year==1960)
data1980 <- subset(mydata,Year==1980)
data1990 <- subset(mydata,Year==1990)

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

# 7 - Probabilit�s
data1899 <- mydata[mydata[,"Year"]==1899,]

data0an1899 <- data1899[data1899[,"Age"]==0,]
data0an1990 <- data1990[data1990[,"Age"]==0,]

proba1899 <- round(((sum(data0an1899$Total)/sum(data1899$Total))*100),2)
proba1990 <- round(((sum(data0an1990$Total)/sum(data1990$Total))*100),2)


# Exercice 2

# 1, 2, 3
x1 <- subset(mydata, Year==1990)
x = c(x1$Total)
y = c(x1$Age)

type = c(x1$Age)
moyennes = c(x,y)

moyennes = matrix(moyennes,nc=length(x1$Age), nr=1,byrow=T)
colnames(moyennes) = type
barplot(moyennes, xlab="Age", ylab = "Morts en France en 1900", main="Nombre de morts en 1900 par rapport � leur age", beside=T, args.legend=list(x="topright"))
box()

# 4, 5
x1 <- subset(mydata, Year==1900)
x2 <- subset(mydata, Year==1990)

x = c(x1$Total)
y = c(x2$Total)

moyennes = c(x,y)
moyennes = matrix(moyennes,nc=2, nr=length(x1$Age),byrow=T)
barplot(moyennes, main="Comparaison entre les morts en France en 1900
et 1990 par rapport � leur age.", ylab="Nombre de morts", xlab="Age", beside=T,legend.text = c("1900","1990"), col=c("black", "green"), args.legend=list(x="topright"))
box()

# 6
x1 <- subset(mydata, Year==1900 & Age!=0)
x2 <- subset(mydata, Year==1990 & Age!=0)

x = c(x1$Total)
y = c(x2$Total)

moyennes = c(x,y)
moyennes = matrix(moyennes,nc=2, nr=length(x2$Age),byrow=T)
barplot(moyennes, main="Comparaison entre les morts en France en 1900
et 1990 par rapport � leur age.", ylab="Nombre de morts", xlab="Age", beside=T,legend.text = c("1900","1990"), col=c("black", "green"), args.legend=list(x="topright"))
box()

# 7
x1 <- subset(mydata, Year==1900 & Age>=10)
x2 <- subset(mydata, Year==1990 & Age>=10)

x = c(x1$Total)
y = c(x2$Total)

type = c(x1$Age)

moyennes = c(x,y)
moyennes = matrix(moyennes,nc=length(x1$Age), nr=2,byrow=T)
colnames(moyennes) = type
barplot(moyennes, main="Comparaison entre les morts en France en 1900
et 1990 par rapport � leur age.", ylab="Nombre de morts", xlab="Age", beside=T,legend.text = c("1900","1990"), col=c("black", "green"), args.legend=list(x="topright"))
box()

# Mise � jour des esp�rances

# 7 - Calculez la moyenne d'age des morts en 1900, 1943, 1960, 1980 et 1990 en enlevant les 
truncateddata1900 <- subset(mydata,Year==1900 & Age>=10)
truncateddata1943 <- subset(mydata,Year==1943 & Age>=10)
truncateddata1960 <- subset(mydata,Year==1960 & Age>=10)
truncateddata1980 <- subset(mydata,Year==1980 & Age>=10)
truncateddata1990 <- subset(mydata,Year==1990 & Age>=10)

truncatedmoyenneAgeMorts1900 <- sum(truncateddata1900$Age*truncateddata1900$Total)/sum(truncateddata1900$Total)
truncatedmoyenneAgeMorts1943 <- sum(truncateddata1943$Age*truncateddata1943$Total)/sum(truncateddata1943$Total)
truncatedmoyenneAgeMorts1960 <- sum(truncateddata1960$Age*truncateddata1960$Total)/sum(truncateddata1960$Total)
truncatedmoyenneAgeMorts1980 <- sum(truncateddata1980$Age*truncateddata1980$Total)/sum(truncateddata1980$Total)
truncatedmoyenneAgeMorts1990 <- sum(truncateddata1990$Age*truncateddata1990$Total)/sum(truncateddata1990$Total)

truncatedmoyenneAgeMorts1900 <- round(truncatedmoyenneAgeMorts1900, 2)
truncatedmoyenneAgeMorts1943 <- round(truncatedmoyenneAgeMorts1943, 2)
truncatedmoyenneAgeMorts1960 <- round(truncatedmoyenneAgeMorts1960, 2)
truncatedmoyenneAgeMorts1980 <- round(truncatedmoyenneAgeMorts1980, 2)
truncatedmoyenneAgeMorts1990 <- round(truncatedmoyenneAgeMorts1990, 2)

truncatedmoyenneAgeMorts1900 <- format(truncatedmoyenneAgeMorts1900,decimal.mark = ",")
truncatedmoyenneAgeMorts1943 <- format(truncatedmoyenneAgeMorts1943,decimal.mark = ",")
truncatedmoyenneAgeMorts1960 <- format(truncatedmoyenneAgeMorts1960,decimal.mark = ",")
truncatedmoyenneAgeMorts1980 <- format(truncatedmoyenneAgeMorts1980,decimal.mark = ",")
truncatedmoyenneAgeMorts1990 <- format(truncatedmoyenneAgeMorts1990,decimal.mark = ",")