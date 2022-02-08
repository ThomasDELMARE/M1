-- Exercice 9.5 : simulation des techniques d'annulation

-- Considérant la structure des caches mémmoires et des fichiers d'un SGBD comme décrits ci-dessous.
-- . CMV: Cache en Mémoire Vive
--   Ensemble des tampons concourant à gérer les objets du SGBD en mémoire. TIA et TIV en font partie
-- . TIA: Tampon Image Après
--   Tampon contenant les données (lignes) APRES modification par les transactions dans la Base de Données
-- . TIV :Tampon Image aVant
--   Tampon contenant les données (lignes) AVANT modification par les transactions dans la Base de Données. Copie avant modification
-- . TJT: Tampon Journal des Transactions
--   Tampon contenant les données (lignes) AVANT et APRES  modification par les transactions dans la Base de Données
-- . FIA: Fichiers Image Après
--   Fichiers contenant les données (lignes) persistantes venant du TIA
-- . FIV: Fichiers Image aVant
--   Fichiers contenant les données (lignes) persistantes venant du TIV
-- . FJT : Fichiers Journal des Transactions
--   Fichiers de sauvegarde des contenus du TJT

-- Nous allons dans cet exercice proposer une série d'activités pour mettre en oeuvre les techniques d'annulation
-- Il s'agit de mettre en oeuvre des transactions en construisant leurs effets dans les différentes
-- zones.
-- Afin d'illustrer vos actions vous devez vous appuyer sur le script Airbase.sql qui contient
-- trois tables :
-- . PILOTE
-- . Avion 
-- . et Vol

-- Pas besoin d'être connecté pour faire ces activités pour l'insant.

-- Note :
--	. Les tampons : TIA et TIV sont découpés en pages ou blocs (dans 1 bloc on peut trouver 
--    0, 1 ou plusieurs lignes.
--		. Blocs TIA : BDAx (x de 0 à N), exemple : BDA0:1, Miranda, 2000
--		. Blocs TIV : BDVx (x de 0 à N), exemple : BDV0:1, Miranda, 2000

--  . Le tampon TJT  : Contient les enregistrements des transactions courantes. Voici 
--    leur structure : Id Transaction, Timestamp, IdBloc: enregistrement
--                     T0, D0, BDA0:1, Miranda, 2000
--                     T0, D0+1, COMMIT

--  . Le tampon FJT  : Contient les enregistrements venant du TJT
 
--  . Le tampon FIA  : Contient les enregistrements venant du TIA
	  Est découpé en blocs BDAx (x de 0 à N)
	  
--  . Le tampon FIV  : Contient les enregistrements venant du TIV
	  Est découpé en blocs BDVx (x de 0 à N)
	  
-- Voici la série d'exercices à faire : Voir avec l'enseignant pour plus de consignes  	  
-- Exercice 9.5.1.1 : Simulation de deux transactions (Sans COMMIT ni ROLLBACK)
-- Exercice 9.5.1.2 : Simulation de COMMIT
-- Exercice 9.5.1.3 : Simulation d'une lecture consistante
-- Exercice 9.5.1.4 : Simulation du Rollback
--------------------------------------------------------------------------------------------

-- Exercice 9.5.1 : Simulation manuelle	

-- Exercice 9.5.1.1 : Simulation de deux transactions (Sans COMMIT ni ROLLBACK)

-- Mettre en oeuvre l'effet de deux transactions dans les différentes 
-- zones ci-dessous (pas de COMMIT)

-- Soient les deux transactions suivantes (elles ne sont  :
-- Transaction 1 (T1): 
insert into  pilote values(24, 'Hassan', '13-MAY-1957', null, '',21000.6);

-- TIA (ONLY LOCK HERE)
	BDA0:24, 'Hassan', '13-MAY-1957', null, '',21000.6
-- TIV
-- TJT
	T1, D0, BDA0:24, 'Hassan', '13-MAY-1957', null, '',21000.6
-- FIA
-- FIV
-- FJT

select * from pilote;

--TIA (ONLY LOCK HERE)
    BDA0 : 24, 'Hassan', '13-MAY-1957', null, '',21000 (LOCK X T1)
    BDA1 : pilote.*
--TIV
--TJT
    T1,D0,BDA0(24, 'Hassan', '13-MAY-1957', null, '',21000)
--FIA
    FIA0 : pilote.*
--FIV
--FJT

insert into  avion values(13, 'A300', 400, 'Paris', 'En service');

--TIA (ONLY LOCK HERE)
    BDA0 : 24, 'Hassan', '13-MAY-1957', null, '',21000 (LOCK X T1)
    BDA1 : pilote.*
	BDA1: 13, 'A300', 400, 'Paris', 'En service' (LOCK X T1)
--TIV
--TJT
    T1,D0,BDA0(24, 'Hassan', '13-MAY-1957', null, '',21000)
	T1,D1,BDA1: 13, 'A300', 400, 'Paris', 'En service'
--FIA
    FIA0 : pilote.*
--FIV
--FJT

update avion set remarq='En panne'
where av#=11;

--TIA (ONLY LOCK HERE)
    BDA0 : 24, 'Hassan', '13-MAY-1957', null, '',21000 (LOCK X T1)
    BDA1 : pilote.*
	BDA2: 13, 'A300', 400, 'Paris', 'En service' (LOCK X T1)
	BDA3: 11, 'A300', 400, 'Paris', 'En panne' (LOCK X T1)
--TIV
	BDV3: 11, 'A300', 400, 'Paris', 'En service'
--TJT
    T1,D0,BDA0(24, 'Hassan', '13-MAY-1957', null, '',21000)
    FIA0 : pilote.*
	BDA1: 13, 'A300', 400, 'Paris', 'En service'
	BDA3: 11, 'A300', 400, 'Paris', 'En panne'
	BDV3: 11, 'A300', 400, 'Paris', 'En service'
--FIA
    FIA0 : pilote.*
	FIA1: 11, 'A300', 400, 'Paris', 'En service'

--FIV
--FJT


select * from avion;

--TIA (ONLY LOCK HERE)
    BDA0 : 24, 'Hassan', '13-MAY-1957', null, '',21000 (LOCK X T1)
    BDA1 : pilote.*
	BDA2 : 13, 'A300', 400, 'Paris', 'En service' (LOCK X T1)
	BDA3 : 11, 'A300', 400, 'Paris', 'En panne' (LOCK X T1)
	BDA4 : avion *
--TIV  JAMAIS DE LOCK
	BDV3: 11, 'A300', 400, 'Paris', 'En service'
--TJT
    T1,D0,BDA0(24, 'Hassan', '13-MAY-1957', null, '',21000)
    FIA0 : pilote.*
	BDA1: 13, 'A300', 400, 'Paris', 'En service'
	BDA3: 11, 'A300', 400, 'Paris', 'En panne'
	BDV3: 11, 'A300', 400, 'Paris', 'En service'
--FIA JAMAIS DE LOCK
    FIA0 : pilote.*
	FIA1: 11, 'A300', 400, 'Paris', 'En service'
	FIA2 : avion *
--FIV
--FJT


-- Transaction 2 (T2): 
insert into  vol values(360, 4,8,'Bordeaux', 'Paris', '23:00','23:55', sysdate );

--TIA (ONLY LOCK HERE)
    BDA0 : 24, 'Hassan', '13-MAY-1957', null, '',21000 (LOCK X T1)
    BDA1 : pilote.*
	BDA2 : 13, 'A300', 400, 'Paris', 'En service' (LOCK X T1)
	BDA3 : 11, 'A300', 400, 'Paris', 'En panne' (LOCK X T1)
	BDA4 : avion *
	BDA5: 360, 4,8,'Bordeaux', 'Paris', '23:00','23:55', sysdate (LOCK X T2)
--TIV  JAMAIS DE LOCK
	BDV3: 11, 'A300', 400, 'Paris', 'En service'
--TJT
    T1,D0,BDA0(24, 'Hassan', '13-MAY-1957', null, '',21000)
    FIA0 : pilote.*
	BDA1: 13, 'A300', 400, 'Paris', 'En service'
	BDA3: 11, 'A300', 400, 'Paris', 'En panne'
	BDV3: 11, 'A300', 400, 'Paris', 'En service'
	T2, D1, BDA5:24, 'Hassan', '13-MAY-1957', null, '',21000.6
--FIA JAMAIS DE LOCK
    FIA0 : pilote.*
	FIA1: 11, 'A300', 400, 'Paris', 'En service'
	FIA2 : avion *
--FIV
--FJT

delete from vol where vol#=310;

--TIA (ONLY LOCK HERE)
    BDA0 : 24, 'Hassan', '13-MAY-1957', null, '',21000 (LOCK X T1)
    BDA1 : pilote.*
	BDA2 : 13, 'A300', 400, 'Paris', 'En service' (LOCK X T1)
	BDA3 : 11, 'A300', 400, 'Paris', 'En panne' (LOCK X T1)
	BDA4 : avion *
	BDA5: 360, 4,8,'Bordeaux', 'Paris', '23:00','23:55', sysdate (LOCK X T2)
	BDA6 : vol#=310 (LOCK X T2)
--TIV  JAMAIS DE LOCK
	BDV3: 11, 'A300', 400, 'Paris', 'En service'
	BDV4 : vol#=310
--TJT
    T1,D0,BDA0(24, 'Hassan', '13-MAY-1957', null, '',21000)
    FIA0 : pilote.*
	BDA1: 13, 'A300', 400, 'Paris', 'En service'
	BDA3: 11, 'A300', 400, 'Paris', 'En panne'
	BDV3: 11, 'A300', 400, 'Paris', 'En service'
	T2, D1, BDA5:24, 'Hassan', '13-MAY-1957', null, '',21000.6
--FIA JAMAIS DE LOCK
    FIA0 : pilote.*
	FIA1: 11, 'A300', 400, 'Paris', 'En service'
	FIA2 : avion *
	FIA3 : vol#=310
--FIV
	FIV0 : vol#=310
--FJT

select * from vol;

--TIA (ONLY LOCK HERE)
    BDA0 : 24, 'Hassan', '13-MAY-1957', null, '',21000 (LOCK X T1)
    BDA1 : pilote.*
	BDA2 : 13, 'A300', 400, 'Paris', 'En service' (LOCK X T1)
	BDA3 : 11, 'A300', 400, 'Paris', 'En panne' (LOCK X T1)
	BDA4 : avion *
	BDA5: 360, 4,8,'Bordeaux', 'Paris', '23:00','23:55', sysdate (LOCK X T2)
	BDA6 : vol#=310 (LOCK X T2)
	BDA7 : vol *
--TIV  JAMAIS DE LOCK
	BDV3: 11, 'A300', 400, 'Paris', 'En service'
	BDV4 : vol#=310
--TJT
    T1,D0,BDA0(24, 'Hassan', '13-MAY-1957', null, '',21000)
    FIA0 : pilote.*
	BDA1: 13, 'A300', 400, 'Paris', 'En service'
	BDA3: 11, 'A300', 400, 'Paris', 'En panne'
	BDV3: 11, 'A300', 400, 'Paris', 'En service'
	T2, D1, BDA5:24, 'Hassan', '13-MAY-1957', null, '',21000.6
	FIA4 : vol *
--FIA JAMAIS DE LOCK
    FIA0 : pilote.*
	FIA1: 11, 'A300', 400, 'Paris', 'En service'
	FIA2 : avion *
	FIA3 : vol#=310
	FIA4 : vol *
--FIV
	FIV0 : vol#=310
--FJT


-- TIA: Tampon Image Après
-- BDA0:1, Miranda, 2000
?

-- TIV :Tampon Image aVant
-- BDV0:1, Miranda, 2000
?

-- TJT: Tampon Journal des Transactions
-- T0, D0, BDA0:1, Miranda, 2000
?

-- FIA: Fichiers Image Après
-- BDA0:1, Miranda, 2000
?

-- FIV: Fichiers Image aVant
-- BDV0:1, Miranda, 2000
?

-- FJT : Fichiers Journal des Transactions
-- T0, D0, BDA0:1, Miranda, 2000
?
 
-- Exercice 9.5.1.2 : Simulation de COMMIT

-- En partant du résultat de l'exercice 9.5.1.1, faire COMMIT dans la transaction 1
-- Mettre à jour les zones en conséquence

--TIA (ONLY LOCK HERE)
    BDA0 : 24, 'Hassan', '13-MAY-1957', null, '',21000
    BDA1 : pilote.*
	BDA2 : 13, 'A300', 400, 'Paris', 'En service' 
	BDA3 : 11, 'A300', 400, 'Paris', 'En panne'
	BDA4 : avion *
	BDA5: 360, 4,8,'Bordeaux', 'Paris', '23:00','23:55', sysdate (LOCK X T2)
	BDA6 : vol#=310 (LOCK X T2)
	BDA7 : vol *
--TIV  JAMAIS DE LOCK
	BDV3: 11, 'A300', 400, 'Paris', 'En service'
	BDV4 : vol#=310
--TJT
    T1,D0,BDA0(24, 'Hassan', '13-MAY-1957', null, '',21000)
    FIA0 : pilote.*
	BDA1: 13, 'A300', 400, 'Paris', 'En service'
	BDA3: 11, 'A300', 400, 'Paris', 'En panne'
	BDV3: 11, 'A300', 400, 'Paris', 'En service'
	T2, D1, BDA5:24, 'Hassan', '13-MAY-1957', null, '',21000.6
	FIA4 : vol *
--FIA JAMAIS DE LOCK
    FIA0 : pilote.*
	FIA1: 11, 'A300', 400, 'Paris', 'En service'
	FIA2 : avion *
	FIA3 : vol#=310
	FIA4 : vol *
--FIV
	FIV0 : vol#=310
--FJT
	T1,D0,BDA0(24, 'Hassan', '13-MAY-1957', null, '',21000)
    FIA0 : pilote.*
	BDA1: 13, 'A300', 400, 'Paris', 'En service'
	BDA3: 11, 'A300', 400, 'Paris', 'En panne'
	BDV3: 11, 'A300', 400, 'Paris', 'En service'
	T2, D1, BDA5:24, 'Hassan', '13-MAY-1957', null, '',21000.6
	FIA4 : vol *

-- Exercice 9.5.1.3 : Simulation d'une lecture consistante

-- En partant du résultat de l'exercice 9.5.1.1 faire ce qui suit

--	a) A partir de la Transaction 2 (T2) effectuer une lecture consistante: 
--	Quel est le salaire du pilote Nr 24 ? (lecture consistante)

--TIA (ONLY LOCK HERE)
    BDA0 : 24, 'Hassan', '13-MAY-1957', null, '',21000
    BDA1 : pilote.*
	BDA2 : 13, 'A300', 400, 'Paris', 'En service' 
	BDA3 : 11, 'A300', 400, 'Paris', 'En panne'
	BDA4 : avion *
	BDA5: 360, 4,8,'Bordeaux', 'Paris', '23:00','23:55', sysdate (LOCK X T2)
	BDA6 : vol#=310 (LOCK X T2)
	BDA7 : vol *
    BDA8 : pilote 24
--TIV  JAMAIS DE LOCK
	BDV3: 11, 'A300', 400, 'Paris', 'En service'
	BDV4 : vol#=310
--TJT
    T1,D0,BDA0(24, 'Hassan', '13-MAY-1957', null, '',21000)
    FIA0 : pilote.*
	BDA1: 13, 'A300', 400, 'Paris', 'En service'
	BDA3: 11, 'A300', 400, 'Paris', 'En panne'
	BDV3: 11, 'A300', 400, 'Paris', 'En service'
	T2, D1, BDA5:24, 'Hassan', '13-MAY-1957', null, '',21000.6
	FIA4 : vol *
--FIA JAMAIS DE LOCK
    FIA0 : pilote.*
	FIA1: 11, 'A300', 400, 'Paris', 'En service'
	FIA2 : avion *
	FIA3 : vol#=310
	FIA4 : vol *
    BDA8 : pilote 24
--FIV
	FIV0 : vol#=310
--FJT
	T1,D0,BDA0(24, 'Hassan', '13-MAY-1957', null, '',21000)
    FIA0 : pilote.*
	BDA1: 13, 'A300', 400, 'Paris', 'En service'
	BDA3: 11, 'A300', 400, 'Paris', 'En panne'
	BDV3: 11, 'A300', 400, 'Paris', 'En service'
	T2, D1, BDA5:24, 'Hassan', '13-MAY-1957', null, '',21000.6
	FIA4 : vol *

Le salaire du pilote nr 24 est de : 21000.6
	
-- Exercice 9.5.1.4 :Simulation du Rollback
 
-- En partant du résultat de l'exercice 9.5.1.3 faire 

--	a) Un rollack de la transaction T2
--	b) Mettre à jour les zones en conséquence

--TIA (ONLY LOCK HERE)
    BDA0 : 24, 'Hassan', '13-MAY-1957', null, '',21000
    BDA1 : pilote.*
	BDA2 : 13, 'A300', 400, 'Paris', 'En service' 
	BDA3 : 11, 'A300', 400, 'Paris', 'En panne'
	BDA4 : avion *
	-- DEBUT T2
	BDA5: 360, 4,8,'Bordeaux', 'Paris', '23:00','23:55', sysdate
	BDA6 : vol#=310
	BDA7 : vol *
    BDA8 : pilote 24
	BDA9 : 360, 4,8,'Bordeaux', 'Paris', '23:00','23:55', sysdate
	BDA10 : 310, 4,8,'Bordeaux', 'Paris', '23:00','23:55', sysdate 
--TIV  JAMAIS DE LOCK
	BDV3: 11, 'A300', 400, 'Paris', 'En service'
	-- T2
	BDV4 : vol#=310
	BDV5 : 360, 4,8,'Bordeaux', 'Paris', '23:00','23:55', sysdate
	BDV6 : vol#=310;
--TJT
    T1,D0,BDA0(24, 'Hassan', '13-MAY-1957', null, '',21000)
    FIA0 : pilote.*
	BDA1: 13, 'A300', 400, 'Paris', 'En service'
	BDA3: 11, 'A300', 400, 'Paris', 'En panne'
	BDV3: 11, 'A300', 400, 'Paris', 'En service'
	-- T2
	T2, D1, BDA5:24, 'Hassan', '13-MAY-1957', null, '',21000.6
	FIA4 : vol *
	BDV5 : 360, 4,8,'Bordeaux', 'Paris', '23:00','23:55', sysdate
	BDV6 : vol#=310;
	BDA10 : 310, 4,8,'Bordeaux', 'Paris', '23:00','23:55', sysdate
--FIA JAMAIS DE LOCK
    FIA0 : pilote.*
	FIA1: 11, 'A300', 400, 'Paris', 'En service'
	FIA2 : avion *
	-- T2
	FIA3 : vol#=310
	FIA4 : vol *
    BDA8 : pilote 24
--FIV
	-- T2
	FIV0 : vol#=310
	FIV1 : 360, 4,8,'Bordeaux', 'Paris', '23:00','23:55', sysdate
	FIV2 : vol#=310;
--FJT
	T1,D0,BDA0(24, 'Hassan', '13-MAY-1957', null, '',21000)
    FIA0 : pilote.*
	BDA1: 13, 'A300', 400, 'Paris', 'En service'
	BDA3: 11, 'A300', 400, 'Paris', 'En panne'
	BDV3: 11, 'A300', 400, 'Paris', 'En service'
	-- T2
	T2, D1, BDA5:24, 'Hassan', '13-MAY-1957', null, '',21000.6
	FIA4 : vol *
	BDV5 : 360, 4,8,'Bordeaux', 'Paris', '23:00','23:55', sysdate
	BDV6 : vol#=310;
	BDA10 : 310, 4,8,'Bordeaux', 'Paris', '23:00','23:55', sysdate

	
---------------------------------------------------------------------------------------------

-- Exercice 9.5.2 : Simulation avec le SGBD Oracle	
-- 

-- Activité 9.5.2.0 : 

-- Activité 9.5.2.0.1 Première connexion
-- définition des variable pour la première connexion
-- Il faut ouvrir une fenêtre CMD : INVITE DE COMMANDE
-- Faire cd pour aller dans le dossier ou se trouve sqlplus.exe
-- exemple : cd D:\FSGBDS\instantclient_19_6

sqlplus /nolog


define ALIASDB1=pdbm1inf
define DRUSER=votreNomUserOracle
define DRUSERPASS=votrePassWordOracle
define SCRIPTPATH=CHEMIN\3SCRIPTS_EXERCICES\Scripts

Connect &DRUSER@&ALIASDB1/&DRUSERPASS

@&SCRIPTPATH\airbase.sql

-- T1 et T3 se dérouleront dans cette connexion


-- Activité 9.5.2.0.2 Deuxième connexion
-- définition des variable pour la première connexion
-- Il faut ouvrir une fenêtre CMD : INVITE DE COMMANDE
-- Faire cd pour aller dans le dossier ou se trouve sqlplus.exe
-- exemple : cd D:\FSGBDS\instantclient_19_6

sqlplus /nolog

define ALIASDB1=pdbm1inf
define DRUSER=votreNomUserOracle
define DRUSERPASS=votrePassWordOracle

Connect &DRUSER@&ALIASDB1/&DRUSERPASS
	
-- T2 se déroulera dans cette connexion

	
-- Exercice 9.5.2.1 : Simulation deux transactions (Sans COMMIT ni ROLLBACK)
-- reprendre les activités de 9.5.1.1

-- Exercice 9.5.2.2 : Simulation de COMMIT
-- reprendre les activités de 9.5.1.2


-- Exercice 9.5.2.3 : Simulation d'une lecture consistante
-- reprendre les activités de 9.5.1.3

-- Exercice 9.5.2.4 :Simulation du Rollback
-- reprendre les activités de 9.5.1.4
