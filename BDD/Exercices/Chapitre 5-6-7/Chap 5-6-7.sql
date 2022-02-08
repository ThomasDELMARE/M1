-- Exercice 7.7.1 Prouver avec Oracle les Anomalies (utiliser les 
-- tables pilote, avion et vol contenues dans le script airbase.sql, 
-- voir le dossier du cours)
-- Mises à jour perdues (UPDATE LOSS)
-- Lectures impropres (DEARTY READ)
-- Lectures non reproductibles (INCONSISTENCY READ)
-- Lignes fantômes (GHOST UPDATE)

-----------------------------------------------------------------------
--7.7.1.1 Mises à jour perdues (UPDATE LOSS)
-- Une mise à jour perdue intervient lorsque 
-- Etape 1 : Une transaction T1 lit une donnée
-- Etape 2 : Puis une transaction T2 modififie cette donnée et la valide
-- Etape 3 : Puis T1 modifie cette donnée avec la donnée de l'étape 1
--           sans tenir compte de la mise de l'étape 2 (qui sera donc 
--           perdue)

-- Simulation
-- Transaction T1 
-- Etape 1 : Une transaction T1 lit une donnée
variable salaire number;
begin
select sal INTO :salaire from pilote where pl#=1;
end;
/
-- ? Quel est le salaire du pilote nr 1 ?

print :salaire;

Reponse : 

   SALAIRE
----------
     18009

-- Transaction T2 
-- Etape 2 : Puis une transaction T2 modififie cette donnée et la valide

select pl#, sal from pilote where pl#=1;

Reponse :

       PL#        SAL
---------- ----------
         1      18009

-- augmentation du salaire du pilote 1 de 300
update pilote set sal=sal+300 where pl#=1;
commit;
select pl#, sal from pilote where pl#=1;

Reponse :

       PL#        SAL
---------- ----------
         1      18309

-- Transaction T1
-- Etape 3 : Puis T1 modifie cette donnée avec la donnée de l'étape 1
--           sans tenir compte de la mise de l'étape 2 (qui sera donc 
--           perdue)

-- augmentation du salaire du pilote 1 de 200
begin
update pilote set sal=:salaire+100 where pl#=1;
commit;
end;
/
-- ? Quel est le nouveau salaire du pilote nr 1?
select pl#, sal from pilote where pl#=1;

Reponse : 

       PL#        SAL
---------- ----------
         1      18109

-- Comment résoudre ce problème
-- Il faudrait mettre des lockers afin d'empêcher qu'une personne puisse modifier alors qu'une autre ne puisse pas.

-- Oracle l'empêche t il ?
-- Oracle ne l'empêche pas.

-- D'autres SGBD ?

-- Réponse à donner dans 7.7.2.1

-----------------------------------------------------------------------
--7.7.1.2 Lectures impropres (DEARTY READ)
-- Une lecture impropre intervient lorsque :
-- Etape 1 : La transaction T1 lit une donnée et la modifie dans 
--           dans la base sans valider
-- Etape 2 : La transaction T2 lit la donnée modifiée par T1 et la 
--           conserve dans une variable locale

-- Etape 3 : La transaction T1 annule (Rollback)
-- Etape 4 : La transaction T2 continue d'utiliser la variable locale

-- Simulation
-- Transaction T1 
-- Etape 1 : La transaction T1 lit une donnée et la modifie dans 
--           dans la base sans valider

-- consultation du salaire du pilote 1
-- consultation du salaire du pilote 1
select sal from pilote where pl#=1;

Reponse : 

       SAL
----------
     18109

-- augmentation du salaire du pilote 1 de 300
update pilote set sal=sal+300 where pl#=1;
select sal from pilote where pl#=1;

Reponse : 

1 ligne mis à jour.


       SAL
----------
     18409

-- Transaction T2 
-- Etape 2 : La transaction T2 lit la donnée modifiée par T1 et la 
--           conserve dans une variable locale

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;

Reponse :

Erreur commençant à la ligne: 1 de la commande -
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
Rapport d'erreur -
ORA-02179: options valides : ISOLATION LEVEL { SERIALIZABLE | READ COMMITTED }
02179. 00000 -  "valid options: ISOLATION LEVEL { SERIALIZABLE | READ COMMITTED }"
*Cause:    There is a syntax error in the user's statement.
*Action:   Correct the syntax as indicated.

-- Le SGBD retourn bien cette erreur, il faudrait qu'on précise l'une des deux solutions proposées ci-dessus afin que la requête marche.

variable salaire number;
begin
select sal INTO :salaire from pilote where pl#=1;
end;
/
-- ? Quel est le salaire du pilote nr 1 ?

print :salaire;

Reponse : 

   SALAIRE
----------
     18409

-- Transaction T1
-- annulation de T1
-- Etape 3 : La transaction T1 annule (Rollback)

ROLLBACK;
select pl#, sal from pilote where pl#=1;

Reponse : 

Annulation (rollback) terminée.

       PL#        SAL
---------- ----------
         1      18109

-- Transaction T2
-- Etape 4 : La transaction T2 continue d'utiliser la variable locale
print :salaire;
-- 
Reponse : 

   SALAIRE
----------
     18409

-- Oracle le permet t il ?

-- Non, il ne permet pas de gére ce cas.

-- D'autres SGBD le permettent t ils?

-- Comment corriger ?
-- Poser des locks afin d'utiliser correctement les variables.

-- Réponse à donner dans 7.7.2.2


-----------------------------------------------------------------------
--7.7.1.3 Lectures non reproductibles (INCONSISTENCY READ)
-- Une lecture non reproductible intervient lorsque :
-- Etape 1 : La transaction T1 lit une donnée D depuis la la base et
--           la conserve dans une variable locale
-- Etape 2 : La transaction T2 modifie la donnée D lue par T1 et la 
--           valide (COMMIT)

-- Etape 3 : La transaction T1 lit à nouveau la donnée D
--           et la conserve dans une 2ème variable locale
--           

-- Simulation
-- Transaction T1 
-- Etape 1 : La transaction T1 lit une donnée D depuis la la base et
--           la conserve dans une variable locale

variable salaire number;
begin
select sal INTO :salaire from pilote where pl#=1;
end;
/
-- ? Quel est le salaire du pilote nr 1 ?

print :salaire;

Reponse : 

   SALAIRE
----------
     18109

-- Transaction T2 
-- Etape 2 : La transaction T2 modifie la donnée D lue par T1 et la 
--           valide (COMMIT)

select pl#, sal from pilote where pl#=1;

Reponse :

       PL#        SAL
---------- ----------
         1      18109

update pilote set sal=sal+300 where pl#=1;
select sal from pilote where pl#=1;
commit;

Reponse :

1 ligne mis à jour.


       SAL
----------
     18409

Validation (commit) terminée.


-- Transaction T1
-- Etape 3 : La transaction T1 lit à nouveau la donnée D
--           et la conserve dans une 2ème variable locale

variable salaire2 number;
begin
select sal INTO :salaire2 from pilote where pl#=1;
end;
/
-- ? Quel est le salaire du pilote nr 2 ?

print :salaire2;

Reponse : 

  SALAIRE2
----------
     18409

-- Oracle le permet t il ?
-- Visiblement non

-- D'autres SGBD le permettent t ils?
--

-- Comment corriger ?
-- Il faudrait mettre un trigger ou prévenir l'utilisateur qu'une variable n'est plus à jour.

-- Réponse à donner dans 7.7.2.3


-----------------------------------------------------------------------
-- 7.7.1.4 Lignes fantômes (GHOST UPDATE)
-- L'anomalie de lignes fantômes intervient lorsque :
-- Etape 1 : La transaction T1 lit par exemple un ensemble de lignes setL
--           dans une table T depuis la la base de données

-- Etape 2 : La transaction T2 insère une nouvelle ligne dans la table T
--           et valide (COMMIT)

-- Etape 3 : La transaction T1 lit à nouveau l'ensemble des lignes lues
--           à l'étape 1 dans une table T depuis la la base de données
--           Il y a des lignes fantomes

-- Simulation
-- Transaction T1 
-- Etape 1 : La transaction T1 lit par exemple un ensemble de lignes setL
--           dans une table T depuis la la base de données


select pl#, sal from pilote where adr='Paris';

Resultat : 


       PL#        SAL
---------- ----------
        10      15000
        15    17000,6
        17    21000,6
        18    21000,6
        19    21000,6
        20    21000,6

6 lignes sélectionnées. 



-- Transaction T2 
-- Etape 2 : La transaction T2 insère une nouvelle ligne dans la table T
--           et valide (COMMIT)

insert into  pilote values(24, 'Ngouabi', '13-MAY-1957', 'Paris', '000242232425',21000.6);
commit;

Reponse : 
1 ligne insérée
Validation (commit) terminée.

-- Transaction T1
-- Etape 3 : La transaction T1 lit à nouveau l'ensemble des lignes lues
--           à l'étape 1 dans une table T depuis la la base de données
--           Il y a des lignes fantomes

select pl#, sal from pilote where adr='Paris';

       PL#        SAL
---------- ----------
        10      15000
        15    17000.6
        17    21000.6
        18    21000.6
        19    21000.6
        20    21000.6
        24    21000.6  *** le fantome !!!

7 rows selected.


-- Oracle le permet t il ?
-- Non, visiblement

-- D'autres SGBD le permettent t ils?
--

-- Comment corriger ?
-- Mettre des lockers sur les requêtes utilisées actuellement.

-- Réponse à donner dans 7.7.2.3

-------------------------------------------------------------------------
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Exercice 7.7.2 Proposer des solutions aux anomalies avec Oracle 
-- en s’appuyant :
-- L’acquisition préalable des verrous pour chaque ressource
-- Sur la sérialisation grâce à la commande Set transaction isolation
-- level

-- 7.7.2.1 Mises à jour perdues (UPDATE LOSS) : Solution
-- Comment résoudre ce problème
-- Oracle l'empêche t il ?
-- D'autres SGBD ?
-- Comment corriger ?
-- Réponse à donner dans 7.7.2.1
-- ** solution 1 : concevoir la transaction  1 différemment
-- ** Solution 2 : Trouver un bon niveau de verrouillage

-- Etape 1 : Une transaction T1 lit une donnée
-- Etape 2 : Puis une transaction T2 modififie cette donnée et la valide
-- Etape 3 : Puis T1 modifie cette donnée avec la donnée de l'étape 1
--           sans tenir compte de la mise de l'étape 2 (qui sera donc 
--           perdue)

-- Simulation
-- Transaction T1 
-- Etape 1 : Une transaction T1 lit une donnée
variable salaire number;
begin
select sal INTO :salaire from pilote where pl#=1;
end;
-- ? Quel est le salaire du pilote nr 1 ?

print :salaire;

Reponse : 

   SALAIRE
----------
     18409

-- Transaction T2 
-- Etape 2 : Puis une transaction T2 modififie cette donnée et la valide

select pl#, sal from pilote where pl#=1;

Reponse :

       PL#        SAL
---------- ----------
         1      18409

-- augmentation du salaire du pilote 1 de 300
update pilote set sal=sal+300 where pl#=1;
commit;
select pl#, sal from pilote where pl#=1;

Reponse :

1 ligne mis à jour.

Validation (commit) terminée.

       PL#        SAL
---------- ----------
         1      18709

-- Transaction T1
-- Etape 3 : Puis T1 modifie cette donnée avec la donnée de l'étape 1
--           sans tenir compte de la mise de l'étape 2 (qui sera donc 
--           perdue)

-- augmentation du salaire du pilote 1 de 200
begin
-- Correction ****************************
-- au lieu de : update pilote set sal=:salaire +100 where pl#=1;
-- Que peut - on faire 
update pilote set  ? ;
-- à compléter;
update pilote set sal = sal+100 WHERE PL#=1 ;

---------------------- ** -----------------------------
commit;
end;
/
-- ? Quel est le nouveau salaire du pilote nr 1?
select pl#, sal from pilote where pl#=1;

Reponse : 

       PL#        SAL
---------- ----------
         1      18909


-----------------------------------------------------------------------
--7.7.2.2 Lectures impropres (DEARTY READ): Solution

-- Oracle le permet t il ?
-- D'autres SGBD le permettent t ils?
-- Comment corriger ?
-- Réponse à donner dans 7.7.2.2

-- Fixer le niveau d'isolation au début des transactions à 
-- read commited

-- Correction lecture impropre:
-- Etape 0 : fixer le niveau d'isolation à read commited
-- Etape 1 : La transaction T1 lit une donnée et la modifie dans 
--           dans la base sans valider
-- Etape 2 : La transaction T2 lit la donnée modifiée par T1 et la 
--           conserve dans une variable locale

-- Etape 3 : La transaction T1 annule (Rollback)
-- Etape 4 : La transaction T2 continue d'utiliser la variable locale

-- Simulation
-- Transaction 1
-- Etape 0.1

-- Transaction 2
-- Etape 0.2
-- set transaction isolation level ?;
-- Est ce utile avec Oracle ?
-- 


-- Transaction T1 
-- Etape 1 : La transaction T1 lit une donnée et la modifie dans 
--           dans la base sans valider

-- consultation du salaire du pilote 1
-- consultation du salaire du pilote 1
select sal from pilote where pl#=1;

Reponse :

       SAL
----------
     18909

-- augmentation du salaire du pilote 1 de 300
update pilote set sal=sal+300 where pl#=1;
select sal from pilote where pl#=1;

Reponse :

1 ligne mis à jour.


       SAL
----------
     19209

-- Transaction T2 
-- Etape 2 : La transaction T2 lit la donnée modifiée par T1 et la 
--           conserve dans une variable locale

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;

Reponse :

Rapport d'erreur -

ORA-02179: options valides : ISOLATION LEVEL { SERIALIZABLE | READ COMMITTED }
02179. 00000 -  "valid options: ISOLATION LEVEL { SERIALIZABLE | READ COMMITTED }"
*Cause:    There is a syntax error in the user's statement.
*Action:   Correct the syntax as indicated.

variable salaire number;
begin
select sal INTO :salaire from pilote where pl#=1;
end;
/
-- ? Quel est le salaire du pilote nr 1 ?

print :salaire;

Reponse :

   SALAIRE
----------
     19209

-- Transaction T1
-- annulation de T1
-- Etape 3 : La transaction T1 annule (Rollback)

ROLLBACK;
select pl#, sal from pilote where pl#=1;

Reponse : 

Annulation (rollback) terminée.

       PL#        SAL
---------- ----------
         1      18909

-- Transaction T2
-- Etape 4 : La transaction T2 continue d'utiliser la variable locale
print :salaire;
-- 

Reponse :

   SALAIRE
----------
     19209

-----------------------------------------------------------------------
--7.7.2.3 Lectures non reproductibles (INCONSISTENCY READ): Solution
-- Oracle le permet t il ?
-- D'autres SGBD le permettent t ils?
-- Comment corriger ?
-- Réponse à donner dans 7.7.2.3

-- Solution au problème de lecture non reproductible intervient lorsque :
-- Etape 0 : fixer le niveau de serialisation à :serializable 
-- ou poser verrou approprié
-- Ou poser un verrou exclusif 
-- Etape 1 : La transaction T1 lit une donnée D depuis la la base et
--           la conserve dans une variable locale
-- Etape 2 : La transaction T2 modifie la donnée D lue par T1 et la 
--           valide (COMMIT)

-- Etape 3 : La transaction T1 lit à nouveau la donnée D
--           et la conserve dans une 2ème variable locale
--           

-- Simulation
-- Simulation
-- Transaction 1
-- Etape 0.1
set transaction isolation level ?;

Reponse :

Je n''ai pas su quoi répondre. J''hésitais à mettre SET TRANSACTION ISOLATION LEVEL READ COMMITED;

-- Transaction T1 
-- Etape 1 : La transaction T1 lit une donnée D depuis la la base et
--           la conserve dans une variable locale

variable salaire number;
begin
select sal INTO :salaire from pilote where pl#=1;
end;
/
-- ? Quel est le salaire du pilote nr 1 ?

print :salaire;

Reponse :

   SALAIRE
----------
     18909

-- Transaction T2 
-- Etape 2 : La transaction T2 modifie la donnée D lue par T1 et la 
--           valide (COMMIT)

select pl#, sal from pilote where pl#=1;

Reponse :

       PL#        SAL
---------- ----------
         1      18909

update pilote set sal=sal+300 where pl#=1;
commit;
select sal from pilote where pl#=1;

Reponse :

1 ligne mis à jour.

Validation (commit) terminée.

       SAL
----------
     19209

-- Transaction T1
-- Etape 3 : La transaction T1 lit à nouveau la donnée D
--           et la conserve dans une 2ème variable locale

variable salaire2 number;
begin
select sal INTO :salaire2 from pilote where pl#=1;
end;
/
-- ? Quel est le salaire du pilote nr 1 ?

print :salaire2;

Reponse :

  SALAIRE2
----------
     19209

-----------------------------------------------------------------------
--7.7.2.4 Lignes fantômes (GHOST UPDATE): Solution
-- Oracle le permet t il ?
-- D'autres SGBD le permettent t ils?
-- Comment corriger ?
-- Réponse à donner dans 7.7.2.4

-- Solution à L'anomalie de lignes fantômes intervient lorsque :
-- Etape 0 : fixer le niveau de serialisation à :serializable 
-- ou poser verrou approprié

-- Etape 1 : La transaction T1 lit par exemple un ensemble de lignes setL
--           dans une table T depuis la la base de données

-- Etape 2 : La transaction T2 insère une nouvelle ligne dans la table T
--           et valide (COMMIT)

-- Etape 3 : La transaction T1 lit à nouveau l'ensemble des lignes lues
--           à l'étape 1 dans une table T depuis la la base de données
--           Il y a des lignes fantomes

-- Simulation

-- Transaction T1
-- Etape 0.1
set transaction isolation level ?;

Reponse :

Je n''ai pas su quoi répondre. J''hésitais à mettre SET TRANSACTION ISOLATION LEVEL READ COMMITED;

-- alternative
--lock table pilote in share mode;

-- Etape 1 : La transaction T1 lit par exemple un ensemble de lignes setL
--           dans une table T depuis la la base de données


select pl#, sal from pilote where adr='Paris';

Reponse :


       PL#        SAL
---------- ----------
        10      15000
        15    17000,6
        17    21000,6
        18    21000,6
        19    21000,6
        20    21000,6
        24    21000,6

7 lignes sélectionnées. 

-- Transaction T2 
-- Etape 2 : La transaction T2 insère une nouvelle ligne dans la table T
--           et valide (COMMIT)

insert into  pilote values(25, 'Gregory', '13-MAY-1957', 'Paris', '000242232425',21000.6);
commit;

Reponse :

1 ligne inséré.

Validation (commit) terminée.

-- Transaction T1
-- Etape 3 : La transaction T1 lit à nouveau l'ensemble des lignes lues
--           à l'étape 1 dans une table T depuis la la base de données
--           Il y a des lignes fantomes

select pl#, sal from pilote where adr='Paris';

Reponse :


       PL#        SAL
---------- ----------
        10      15000
        15    17000,6
        17    21000,6
        18    21000,6
        19    21000,6
        20    21000,6
        24    21000,6
        25    21000,6

8 lignes sélectionnées. 

set transaction isolation level read COMMITTED;

Reponse :

Succès de l''élément transaction ISOLATION.

-- Exercice 7.7.3 Mettre en œuvre un deadlock (organiser deux 
-- transactions avec les table PILOTE, AVION et VOL)

-----------------------------------------------------------------------
-- Simulation du deadlock 
-----------------------------------------------------------------------
-- *** Transaction 1

UPDATE pilote set sal = 12000.9
where adr = 'Paris';

Reponse :

8 lignes mis à jour.

-- *** Transaction 2

UPDATE VOL SET VD='Nice'
WHERE VOL#=310; 

-- *** Transaction 2

UPDATE pilote set sal = 12000.9
where adr = 'Paris';

-- (attente de T1)

-- *** Transaction 1

UPDATE VOL
SET VD='Toulouse'
WHERE VOL#=310;

--(ATTENTE de T2) 

-- *** Transaction 2
-- 37
(attente verrou mortel)

-- ***  Transaction 2
-- 38
(dead lock détecté,
Transaction la plus récente est arrêtée)
                  *
ERROR at line 1:
ORA-00060: deadlock detected while waiting for resource
ROLLBACK; 


-- Exercice 7.7.4 corriger le problème de deadlock de 7.7.3
-- correction pose de verrous préventifs 
-- *** Transaction 1
select * from pilote where adr='Paris' for update;
select * from VOL where VOL#=310 for update;

UPDATE pilote set sal = 12000.9
where adr = 'Paris';

Reponse :


       PL# PLNOM        DNAISS      ADR                  TEL                 SAL
---------- ------------ ----------- -------------------- ------------ ----------
        10 Math         12-AUG-1938 Paris                23548254        12000,9
        15 Vernes       04-NOV-1935 Paris                                12000,9
        17 Concorde     04-AUG-1966 Paris                                12000,9
        18 Foudil       04-AUG-1966 Paris                                12000,9
        19 Foudelle     04-AUG-1966 Paris                                12000,9
        20 Zembla       04-AUG-1966 Paris                                12000,9
        24 Ngouabi      13-MAY-1957 Paris                000242232425    12000,9
        25 Gregory      13-MAY-1957 Paris                000242232425    12000,9

8 lignes sélectionnées. 


      VOL#    PILOTE#     AVION# VD                   VA                           HD         HA DAT        
---------- ---------- ---------- -------------------- -------------------- ---------- ---------- -----------
       310         19          8 Toulouse             Marseille                  1230       1425 09-MAR-1989


8 lignes mis à jour.



-- *** Transaction 2
select * from pilote where adr='Paris' for update;
select * from VOL where VOL#=310 for update;

UPDATE VOL SET VD='Nice'
WHERE VOL#=310; 

Reponse :


       PL# PLNOM        DNAISS      ADR                  TEL                 SAL
---------- ------------ ----------- -------------------- ------------ ----------
        10 Math         12-AUG-1938 Paris                23548254        12000,9
        15 Vernes       04-NOV-1935 Paris                                12000,9
        17 Concorde     04-AUG-1966 Paris                                12000,9
        18 Foudil       04-AUG-1966 Paris                                12000,9
        19 Foudelle     04-AUG-1966 Paris                                12000,9
        20 Zembla       04-AUG-1966 Paris                                12000,9
        24 Ngouabi      13-MAY-1957 Paris                000242232425    12000,9
        25 Gregory      13-MAY-1957 Paris                000242232425    12000,9

8 lignes sélectionnées. 


      VOL#    PILOTE#     AVION# VD                   VA                           HD         HA DAT        
---------- ---------- ---------- -------------------- -------------------- ---------- ---------- -----------
       310         19          8 Toulouse             Marseille                  1230       1425 09-MAR-1989


1 ligne mis à jour.


-- *** Transaction 2

UPDATE pilote set sal = 12000.9
where adr = 'Paris';
-- (attente de T1)

-- *** Transaction 1

UPDATE VOL
SET VD='Toulouse'
WHERE VOL#=310;

--Exercice 7.7.5 Mettre en œuvre les techniques de verrouillage avec Oracle, 
--profiter pour visualiser les informations sur verrous

--Nota : 
--pour visualiser les Verrous vous pouvez consulter les tables 
--dynamqies : v$transaction, v$lock, dba_lock, dba_dml_lock, 
--dba_ddl_lock, V$LOCKED_OBJECT; , sys.obj$ (colonne obj# et name)…
-- Liste des objets verrouillées
select * from dba_dml_locks;

-- liste des transactions actives
 
seledct * from v$transaction;