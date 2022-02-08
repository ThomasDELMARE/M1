-- Exercice 10.7 : simulation de pannes à chaud

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
--	  Est découpé en blocs BDAx (x de 0 à N)
	  
--  . Le tampon FIV  : Contient les enregistrements venant du TIV
--	  Est découpé en blocs BDVx (x de 0 à N)
	  
-- Voici la série d'exercices à faire : Voir avec l'enseignant pour plus de consignes  	  
-- Exercice 10.7.1.1 : Simulation de trois transactions (Sans COMMIT ni ROLLBACK)
-- Exercice 10.7.1.2 : Simulation de COMMIT
-- Exercice 10.7.1.3 : Simulation de checkpoint
-- Exercice 10.7.1.4 : Simulation d'une lecture consistante
-- Exercice 10.7.1.5 :Simulation du Rollback
--------------------------------------------------------------------------------------------

-- Exercice 10.7.1 : Simulation manuelle	
--	(il suffit de reprendre ce qui a été fait dans l'exercice 9.5.1.1 jusque 9.5.1.3)

-- Exercice 10.7.1.1 : Simulation de trois transactions (Sans COMMIT ni ROLLBACK)

-- Mettre en oeuvre l'effet de trois transactions dans les différentes 
-- zones ci-dessous (pas de COMMIT)

-- Soient les trois transactions suivantes (elles ne sont  :
-- Transaction 1 (T1): 
insert into  pilote values(24, 'Hassan', '13-MAY-1957', null, '',21000.6);
select * from pilote;
insert into  avion values(13, 'A300', 400, 'Paris', 'En service');
update avion set remarq='En panne'
where av#=11;

select * from avion;

-- Transaction 2 (T2): 
insert into  vol values(360, 4,8,'Bordeaux', 'Paris', '23:00','23:55', sysdate );
delete from vol where vol#=310;
select * from vol;

-- TIA: Tampon Image Après
?

-- TIV :Tampon Image aVant
?

-- TJT: Tampon Journal des Transactions
?

-- FIA: Fichiers Image Après
?

-- FIV: Fichiers Image aVant
?

-- FJT : Fichiers Journal des Transactions
?
 
-- Exercice 10.7.1.2 : Simulation de COMMIT

-- En partant du résultat de l'exercice 10.7.1.1, faire COMMIT dans la transaction 1
-- Mettre à jour les zones en conséquence


-- Exercice 10.7.1.3 : Simulation de checkpoint

-- En partant du résultat de l'exercice 10.7.1.2 faire ce qui suit

-- a) créer une Transaction 3 (T3 elle remplace T1 commitée) : 
		insert into  pilote values(25, 'Toussaint', '13-MAY-1957', null, '',21000.6);
		update pilote set sal=sal+100 where pl#=24;

--	b) Effectuer un checkpoint 
	- Si la transaction T3 a été commité, alors la transaction apparait dans le FJT
	- Si la transaction T3 n a oas été commité, alors la transaction n apparait pas dans le FJT

--	c) Mettre à jour les zones en conséquence

	
-- Exercice 10.7.1.4 :Simulation d'une panne à chaud
 
-- En partant du résultat de l'exercice 10.7.1.3 faire 

--	a) provoquer une perte brutale des zones mémoires (TIA, TIV et TJT)
--	b) Simuler un redémarrage et Mettre à jour les zones (FIA, FIV) en conséquence
	
---------------------------------------------------------------------------------------------

-- Exercice 10.7.2 : Simulation panne à chaud avec le SGBD Oracle	
-- Activité 9.7.2.0 : 

-- Activité 9.7.2.0.1 Première connexion : TRANSACTION T1
-- définition des variable pour la première connexion
-- Il faut ouvrir une fenêtre CMD : INVITE DE COMMANDE
-- Faire cd pour aller dans le dossier ou se trouve sqlplus.exe
-- exemple : cd D:\FSGBDS\instantclient_19_6

sqlplus /nolog


define ALIASDB1=pdbtest19
define DRUSER=pdbadmin
define SCRIPTPATH=D:\1agm05092005\1Cours\13B_COURS_FSGBD\3SCRIPTS_EXERCICES\Scripts

Connect &DRUSER@&ALIASDB1


@&SCRIPTPATH\airbase.sql

-- T1 et T3 se dérouleront dans cette connexion


-- Activité 9.5.2.0.2 Deuxième connexion : TRANSACTION T2
-- définition des variable pour la première connexion
-- Il faut ouvrir une fenêtre CMD : INVITE DE COMMANDE
-- Faire cd pour aller dans le dossier ou se trouve sqlplus.exe
-- exemple : cd D:\FSGBDS\instantclient_19_6

sqlplus /nolog

define ALIASDB1=pdbtest19
define DRUSER=pdbadmin
define SCRIPTPATH=D:\1agm05092005\1Cours\13B_COURS_FSGBD\3SCRIPTS_EXERCICES\Scripts

Connect &DRUSER@&ALIASDB1
	
-- T2 se déroulera dans cette connexion
 	  
-- Exercice 10.7.2.1 : Simulation deux transactions (Sans COMMIT ni ROLLBACK)
-- reprendre les activités de 10.7.1.1
-- Transaction 1 (T1):

spool &SCRIPTPATH\LOG\exercices_chap10_techniques_de_reprise_sur_panne_a_chaud_T1.log
 
insert into  pilote values(24, 'Hassan', '13-MAY-1957', null, '',21000.6);
select * from pilote order by pl#;
insert into  avion values(13, 'A300', 400, 'Paris', 'En service');
update avion set remarq='En panne'
where av#=11;

set linesize 200
set pagesize 100

select * from avion order by av#;

-- Transaction 2 (T2): 
spool &SCRIPTPATH\LOG\exercices_chap10_techniques_de_reprise_sur_panne_a_chaud_T2.log


set linesize 200
set pagesize 100

insert into  vol values(360, 4,8,'Bordeaux', 'Paris', '2300','2355', sysdate );
delete from vol where vol#=310;
select * from vol order by vol#;

-- Exercice 10.7.2.2 : Simulation de COMMIT
-- reprendre les activités de 10.7.1.2

-- Transaction 1 (T1): 
commit;

-- Transaction 3 (T3) remplace T1: 

insert into  pilote values(25, 'Toussaint', '13-MAY-1957', null, '',21000.6);

update pilote set sal=sal+100 where pl#=24;

select * from pilote order by pl#;


-- Exercice 10.7.2.3 : Simulation de checkpoint
-- reprendre les activités de 10.7.1.3

-- Transaction 3 (T3) remplace T1: 

alter system checkpoint;


-- Exercice 10.7.2.4 :Simulation d'une panne à chaud

-- vérification avant l'arrêt

-- Données disponibles avant la panne à chaud au niveau de la transaction 
-- Transaction 3 (T3) qui se substitue à T1 : 
select * from pilote order by pl#;

-- ?

select * from avion order by av# ;

-- ?

Select * from vol order by vol#;

-- ?


-- Données disponibles avant la panne à chaud au niveau de la transaction 
-- Transaction 2 (T2) : 
select * from pilote order by pl#;

--?

select * from avion order by av# ;

--?

Select * from vol order by vol#;

?
-- Arrêt brutal de la machine serveur


-- En partant du résultat de l'exercice 10.7.1.3 faire 

--	a) provoquer une perte brutale des zones mémoires 


--	b) Simuler un redémarrage et Mettre à jour les zones en conséquence

-- Voici ce qui va être perdu
insert into  vol values(360, 4,8,'Bordeaux', 'Paris', '23:00','23:55', sysdate );
delete from vol where vol#=310;
insert into  pilote values(25, 'Toussaint', '13-MAY-1957', null, '',21000.6);

update pilote set sal=sal+100 where pl#=24;

-- Voici ce qui va être conservé
insert into  pilote values(24, 'Hassan', '13-MAY-1957', null, '',21000.6);
insert into  avion values(13, 'A300', 400, 'Paris', 'En service');
update avion set remarq='En panne'
where av#=11;

-- Données disponibles après réparation de la panne à chaud  
-- Transaction 4 (T4) : 


SQL> Select * from vol order by vol#;
Select * from vol order by vol#
*
ERREUR a la ligne 1 :
ORA-03113: end-of-file on communication channel
ID de processus : 23136
ID de session : 508,  Numero de serie : 42628

sqlplus /nolog


define ALIASDB1=pdbtest19
define DRUSER=pdbadmin
define SCRIPTPATH=D:\1agm05092005\1Cours\13B_COURS_FSGBD\3SCRIPTS_EXERCICES\Scripts

Connect &DRUSER@&ALIASDB1

spool &SCRIPTPATH\LOG\exercices_chap10_techniques_de_reprise_sur_panne_a_chaud_T4.log

select * from pilote order by pl#;

-- ?
set linesize 200
select * from avion order by av# ;

-- ?

Select * from vol order by vol#;

?
spool off;