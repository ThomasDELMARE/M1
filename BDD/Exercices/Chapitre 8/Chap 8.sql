Je n ai pas pu completer l exercice car la connexion à la base ne marchait pas.

/*
Exercice 8.6.1 : Distribution de donn�es sous Oracle

8.6.1.1 Probl�me

Supposons que nous ayant deux bases de donn�es : 
- Base1 : pdbl3mia.631174089.oraclecloud.internal : (machine host IP : 134.59.152.120 Port : 443) 
- Base2 : pdbm1inf.631174089.oraclecloud.internal : (machine host IP : 134.59.152.120 Port : 443).
Nous d�sirons permettre aux utilisateurs d�effectuer 
des transactions distribu�es sur les deux bases. 

Pour ce faire vous avez un utilisateur appel� &DRUSER 
cr�� dans chacune des bases avec un mot de passe
identique dans chacune des bases.

8.6.1.2 Travail � faire
	
1.	Dessiner la topologie de vos bases de donn�es distribu�es

2.	Organiser et mettre en oeuvre la distribution
sur les deux bases de donn�es existantes. 
Ces bases sont d�marr�es
*/

-------------------------------------------------------------------------------------------------
-- Activit� 1 : Connexion et d�finition  de variables
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
-- Activit� 1.1 : connexion sur la Base1
-- d�finition des variable de la premi�re base :  Base1 (voir la d�finition plus haut)
-- Il faut ouvrir une fen�tre CMD : INVITE DE COMMANDE
-- Faire cd pour aller dans le dossier ou se trouve sqlplus.exe
-- exemple :z cd z:\FSGBDS\instantclient_19_6
-------------------------------------------------------------------------------------------------

sqlplus /nolog


define SERVICEDB2=PDBM1INF.631174089.oraclecloud.internal
define DBLINKNAME2=pdbm1mia
define ALIASDB1=PDBM1INF

-- D�finir votre nom d'utilisateur et mot de passe sur la base 1
--define DRUSER=votreLoginOracleIci
--define DRUSERPASS=votrePasswordOracleIci
define DRUSER=DELMARE1M2122
define DRUSERPASS=DELMARE1M212201

-- definir le chemin vers les scripts du tp : chap12_demobld.sql, etc.
--define SCRIPTPATH=CheminAModifier\3SCRIPTS_EXERCICES\Scripts
define SCRIPTPATH=E:\School\MIAGE\Git\M1\BDD\Scripts

-------------------------------------------------------------------------------------------------
-- Activit� 1.2 : connexion sur la base 2
-- d�finition des variable de la deuxi�me base :  Base2 (voir la d�finition plus haut)
-- Il faut ouvrir une deuxi�me fen�tre CMD : INVITE DE COMMANDE
-- Faire cd pour aller dans le dossier ou se trouve sqlplus.exemple
-- exemple : cd D:\FSGBDS\instantclient_19_6
-------------------------------------------------------------------------------------------------

sqlplus /nolog
define SERVICEDB1=PDBM1INF.631174089.oraclecloud.internal
define DBLINKNAME1=PDBM1INF
define ALIASDB2=pdbm1mia

-- D�finir votre nom d'utilisateur et mot de passe sur la base 1
--define DRUSER=votreLoginOracleIci
--define DRUSERPASS=votrePasswordOracleIci
--A modifier !!!
define DRUSER=DELMARE1M2122
define DRUSERPASS=DELMARE1M212201


-- definir le chemin vers le script du tp appel� :chap12_demobld.sql, etc.
-- define SCRIPTPATH=CheminAModifier\3SCRIPTS_EXERCICES\Scripts
-- A modifier !!!
define SCRIPTPATH=E:\School\MIAGE\Git\M1\BDD\Scripts

-------------------------------------------------------------------------------------------------
-- Activit� 2 : Chargment des donn�es
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
-- Activit� 2.1 : Chargment des donn�es sur la base1
-------------------------------------------------------------------------------------------------

-- Charger les tables (EMP, DEPT, �) contenues dans le 
-- script chap12_demobld.sql dans le 
-- sch�ma de &DRUSER sur la base &SERVICEDB1 ou ALIASDB1
-- sur la base &SERVICEDB1 ou ALIASDB1

Connect &DRUSER@&ALIASDB1/&DRUSERPASS

@&SCRIPTPATH\chap8_demobld.sql

-------------------------------------------------------------------------------------------------
-- Activit� 2.2 : Chargment des donn�es sur la base2
-- Charger les tables (CLIENT, PRODUIT, COMMANDE) contenues dans 
-- le script chap12_clientbld.sql dans le 
-- sch�ma de &DRUSER sur la base &SERVICEDB2 ou ALIASDB2
-------------------------------------------------------------------------------------------------

-- sur la base &SERVICEDB2 ou ALIASDB2

Connect &DRUSER@&ALIASDB2/&DRUSERPASS

@&SCRIPTPATH\chap8_clientbld.sql


Je me suis bien connecté et les tables sont bien chargées

-------------------------------------------------------------------------------------------------
-- Activit� 3 .	Cr�er un database link public pour permettre � l�utilisateur &DRUSER 
-- depuis la Base1 de manipuler des objets � distance sur la Base2

-- Dans le cadre de cet exercice, le Database Link est d�j� cr�� par l'adminitrateur
-- Il est contenu dans la variable : DBLINKNAME2 (voir sa valeur)
-------------------------------------------------------------------------------------------------




-------------------------------------------------------------------------------------------------
-- Activit� 4 : Consultaions et mise � jour distante : requ�te sur 1 base distante
-------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------
-- Activit� 4.1	Effectuer des consultations distantes
-------------------------------------------------------------------------------------------------

Connect &DRUSER@&ALIASDB1/&DRUSERPASS

-- Structure des tables distantes
desc &DRUSER..produit@&DBLINKNAME2

 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 PID#                                      NOT NULL NUMBER(6)
 PNOM                                               VARCHAR2(50)
 PDESCRIPTION                                       VARCHAR2(100)
 PPRIXUNIT                                          NUMBER(7,2)

desc &DRUSER..commande@&DBLINKNAME2

 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 PCOMM#                                    NOT NULL NUMBER(6)
 CDATE                                              DATE
 PID#                                               NUMBER(6)
 CID#                                               NUMBER(6)
 PNBRE                                              NUMBER(4)
 PPRIXUNIT                                          NUMBER(7,2)
 EMPNO                                              NUMBER(4)

desc &DRUSER..client@&DBLINKNAME2

 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 CID#                                      NOT NULL NUMBER(6)
 CNOM                                               VARCHAR2(20)
 CDNAISS                                            DATE
 CADR                                               VARCHAR2(50)

select *
from &DRUSER..commande@&DBLINKNAME2;

old   2: from &DRUSER..commande@&DBLINKNAME2
new   2: from DELMARE1M2022.commande@pdbm1mia.unice.fr

    PCOMM# CDATE             PID#       CID#      PNBRE  PPRIXUNIT      EMPNO
---------- ----------- ---------- ---------- ---------- ---------- ----------
         1 29-NOV-2021       1000          1          4          2       7369
         2 29-NOV-2021       1000          1         10          2       7369
         3 29-NOV-2021       1000          1          9          2       7369

set linesize 200
col CADR format A20
select * from &DRUSER..client@&DBLINKNAME2;

old   1: select * from &DRUSER..client@&DBLINKNAME2
new   1: select * from DELMARE1M2022.client@pdbm1mia.unice.fr

      CID# CNOM                 CDNAISS     CADR
---------- -------------------- ----------- --------------------
         1 Akim                 12-DEC-1972 Washington
         2 Erzulie              12-DEC-1942 Artibonite

set linesize 200
col pnom format A30
col pdescription format A40

select * from &DRUSER..produit@&DBLINKNAME2;

old   1: select * from &DRUSER..produit@&DBLINKNAME2
new   1: select * from DELMARE1M2022.produit@pdbm1mia.unice.fr

      PID# PNOM                           PDESCRIPTION                              PPRIXUNIT
---------- ------------------------------ ---------------------------------------- ----------
      1000 Coca cola 2 litres             Coca cola 2 litres avec caf?in                    2
      1001 orangina pack de 6 bouteilles  orangina pack de 6 bouteilles de 1,5 lit          6
           de 1,5 litres                  res

-------------------------------------------------------------------------------------------------
-- Activit� 4.2	Effectuer des mises � jour distantes sur la Base1
-------------------------------------------------------------------------------------------------

-- Modification des donn�es d'une table distante sur la Base1 uniquement
Update &DRUSER..commande@&DBLINKNAME2
Set empno= 7369;

old   1: Update &DRUSER..commande@&DBLINKNAME2
new   1: Update DELMARE1M2022.commande@pdbm1mia.unice.fr

3 rows updated.

-- Consultation des informations sur la transaction sur la Base1 et la Base2
col pdb_name format a10
col username format a12
col segment_name format a22
col status format A7

select ps.pdb_name, 
vs.username, 
rs.segment_name, 
vt.addr "Id trans", 
vt.status, 
vt.start_time,
vt.START_SCNB "START SCN",
vt.USED_UBLK "Block RBS"
from v$transaction vt, v$session vs, dba_rollback_segs rs, dba_pdbs ps
where vt.SES_ADDR=vs.saddr
and vt.con_id=ps.con_id
and vt.XIDUSN=rs.segment_id;

-- R�sultat sur la Base1

PDB_NAME   USERNAME     SEGMENT_NAME           Id trans         STATUS  START_TIME            START SCN  Block RBS
---------- ------------ ---------------------- ---------------- ------- -------------------- ---------- ----------
PDBL3MIA   DELMARE1M202 _SYSSMU7_3911517261$   00007FFA29C83A80 ACTIVE  11/29/21 17:46:53      48783705          1
           2

-- R�sultat sur la Base2

PDB_NAME   USERNAME     SEGMENT_NAME           Id trans         STATUS
---------- ------------ ---------------------- ---------------- -------
START_TIME            START SCN  Block RBS
-------------------- ---------- ----------
PDBM1MIA   DELMARE1M202 _SYSSMU10_2250472353$  00007FFA29BA43A8 ACTIVE
           2

-- Consultation des informations sur les verrous DML sur la Base1 et la Base2
set linesize 200
col OWNER format a12
col NAME  format a15
col BLOCKING_OTHERS format a15

select 
SESSION_ID,
OWNER, 
NAME,
MODE_HELD,
MODE_REQUESTED,
LAST_CONVERT,
BLOCKING_OTHERS
from dba_dml_locks;

-- R�sultat sur la Base1

no rows selected

-- R�sultat sur la Base2

SESSION_ID OWNER        NAME            MODE_HELD     MODE_REQUESTE LAST_CONVERT BLOCKING_OTHERS
---------- ------------ --------------- ------------- ------------- ------------ ---------------
       400 DELMARE1M202 COMMANDE        Row-X (SX)    None                   190 Not Blocking
           2



-- Validation sur la Base 1 uniquement
Commit;

Commit complete;

-- Insertion d'une ligne dans une table distante : Base 1

insert into &DRUSER..commande@&DBLINKNAME2 (pcomm#, cdate,pid#,  cid#, pnbre, pprixunit, empno) 
values(4, sysdate, 1000,1, 9, 2, 7369);

-- Consultation des informations sur la transaction sur la Base1 et la Base2
col pdb_name format a10
col username format a12
col segment_name format a22
col status format A7

select ps.pdb_name, 
vs.username, 
rs.segment_name, 
vt.addr "Id trans", 
vt.status, 
vt.start_time,
vt.START_SCNB "START SCN",
vt.USED_UBLK "Block RBS"
from v$transaction vt, v$session vs, dba_rollback_segs rs, dba_pdbs ps
where vt.SES_ADDR=vs.saddr
and vt.con_id=ps.con_id
and vt.XIDUSN=rs.segment_id;

-- R�sultat sur la Base1

PDB_NAME   USERNAME     SEGMENT_NAME           Id trans         STATUS  START_TIME            START SCN  Block RBS
---------- ------------ ---------------------- ---------------- ------- -------------------- ---------- ----------
PDBL3MIA   PARIZET1M202 _SYSSMU8_3558373158$   00007FFA29CF2470 ACTIVE  11/29/21 17:52:00      48785643          1
           2

PDBL3MIA   CHENG1M2022  _SYSSMU2_2386332601$   00007FFA29C167E0 ACTIVE  11/29/21 17:52:12      48785665          1
PDBL3MIA   DELMARE1M202 _SYSSMU3_1537070598$   00007FFA29C83A80 ACTIVE  11/29/21 17:52:31      48785721          1
           2

-- R�sultat sur la Base2

PDB_NAME   USERNAME     SEGMENT_NAME           Id trans         STATUS  START_TIME            START SCN  Block RBS
---------- ------------ ---------------------- ---------------- ------- -------------------- ---------- ----------
PDBM1MIA   PARIZET1M202 _SYSSMU18_2761161926$  00007FFA29BA8998 ACTIVE  11/29/21 17:52:00      48785870          1
           2

PDBM1MIA   DELMARE1M202 _SYSSMU25_3470042831$  00007FFA29BA43A8 ACTIVE  11/29/21 17:52:31      48785721          1
           2


-- Consultation des informations sur les verrous DML sur la Base1 et la Base2
set linesize 200
col OWNER format a12
col NAME  format a15
col BLOCKING_OTHERS format a15

select 
SESSION_ID,
OWNER, 
NAME,
MODE_HELD,
MODE_REQUESTED,
LAST_CONVERT,
BLOCKING_OTHERS
from dba_dml_locks;
-- R�sultat sur la Base1

no rows selected

-- R�sultat sur la Base2

SESSION_ID OWNER        NAME            MODE_HELD     MODE_REQUESTE LAST_CONVERT BLOCKING_OTHERS
---------- ------------ --------------- ------------- ------------- ------------ ---------------
       400 DELMARE1M202 CLIENT          Row-X (SX)    None                   143 Not Blocking
           2

       400 DELMARE1M202 PRODUIT         Row-X (SX)    None                   143 Not Blocking
           2

       400 DELMARE1M202 COMMANDE        Row-X (SX)    None                   143 Not Blocking
           2

       281 PARIZET1M202 COMMANDE        Row-X (SX)    None                    58 Not Blocking
           2

SESSION_ID OWNER        NAME            MODE_HELD     MODE_REQUESTE LAST_CONVERT BLOCKING_OTHERS

-- Validation sur la Base1 uniquement
commit ;

commit complete


-------------------------------------------------------------------------------------------------
-- Activit� 5 : Consultaions et mises � jour distribu�es : requ�tes impliquant 
-- plusieurs bases de donn�es(ici Base1 et Base2)
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
-- Activit� 5.1 Effectuer des consultations distribu�es : ici jointure ... sur la base 1
-------------------------------------------------------------------------------------------------

Select c.pcomm#, c.pid#, e.empno , c.PPRIXUNIT
from &DRUSER..commande@&DBLINKNAME2  c, 
&DRUSER..produit@&DBLINKNAME2 p, 
emp e
where c.pid#=p.pid# and c.empno=e.Empno;



old   2: from &DRUSER..commande@&DBLINKNAME2  c,
new   2: from DELMARE1M2022.commande@pdbm1mia.unice.fr  c,
old   3: &DRUSER..produit@&DBLINKNAME2 p,
new   3: DELMARE1M2022.produit@pdbm1mia.unice.fr p,

    PCOMM#       PID#      EMPNO  PPRIXUNIT
---------- ---------- ---------- ----------
         4       1000       7369          2
         1       1000       7369          2
         2       1000       7369          2
         3       1000       7369          2


-- Consultation des informations sur la transaction sur la Base1 et la Base2
col pdb_name format a10
col username format a12
col segment_name format a22
col status format A7

select ps.pdb_name, 
vs.username, 
rs.segment_name, 
vt.addr "Id trans", 
vt.status, 
vt.start_time,
vt.START_SCNB "START SCN",
vt.USED_UBLK "Block RBS"
from v$transaction vt, v$session vs, dba_rollback_segs rs, dba_pdbs ps
where vt.SES_ADDR=vs.saddr
and vt.con_id=ps.con_id
and vt.XIDUSN=rs.segment_id;

-- R�sultat sur la Base1

PDB_NAME   USERNAME     SEGMENT_NAME           Id trans         STATUS  START_TIME            START SCN  Block RBS
---------- ------------ ---------------------- ---------------- ------- -------------------- ---------- ----------
PDBL3MIA   PARIZET1M202 _SYSSMU2_2386332601$   00007FFA29CF2470 ACTIVE  11/29/21 17:57:11      48787341          1
           2

PDBL3MIA   CORBIERE1M20 _SYSSMU9_406156152$    00007FFA29C61360 ACTIVE  11/29/21 17:54:19      48785890          1
           22

PDBL3MIA   ALCARAZ1M202 _SYSSMU4_2142506228$   00007FFA29CEEA28 ACTIVE  11/29/21 17:55:30      48786480          1
           2

PDBL3MIA   CHENG1M2022  _SYSSMU8_3558373158$   00007FFA29C5B620 ACTIVE  11/29/21 17:57:06      48787334          1
PDBL3MIA   DELMARE1M202 _SYSSMU3_1537070598$   00007FFA29C83A80 ACTIVE  11/29/21 17:56:42      48786939          1

PDB_NAME   USERNAME     SEGMENT_NAME           Id trans         STATUS  START_TIME            START SCN  Block RBS
---------- ------------ ---------------------- ---------------- ------- -------------------- ---------- ----------
           2

PDBL3MIA   AGREBI1M2022 _SYSSMU5_1968394564$   00007FFA29C17388 ACTIVE  11/29/21 17:53:18      48785799          1
PDBL3MIA   DESLANDES1M2 _SYSSMU12_1087701674$  00007FFA29CEF5D0 ACTIVE  11/29/21 17:53:19      48785818          1
           022

PDBL3MIA   LEMOINE1M202 _SYSSMU10_2250472353$  00007FFA29CCE600 ACTIVE  11/29/21 17:52:35      48785734          1
           2


8 rows selected.

-- R�sultat sur la Base2

PDB_NAME   USERNAME     SEGMENT_NAME           Id trans         STATUS  START_TIME            START SCN  Block RBS
---------- ------------ ---------------------- ---------------- ------- -------------------- ---------- ----------
PDBM1MIA   AGREBI1M2022 _SYSSMU17_1586838508$  00007FFA29CF3018 ACTIVE  11/29/21 17:53:18      48786930          1
PDBM1MIA   PARIZET1M202 _SYSSMU2_2386332601$   00007FFA29BA8998 ACTIVE  11/29/21 17:57:11      48787341          1
           2

-- Consultation des informations sur les verrous DML sur la Base1 et la Base2
set linesize 200
col OWNER format a12
col NAME  format a15
col BLOCKING_OTHERS format a15

select 
SESSION_ID,
OWNER, 
NAME,
MODE_HELD,
MODE_REQUESTED,
LAST_CONVERT,
BLOCKING_OTHERS
from dba_dml_locks;
-- R�sultat sur la Base1

no rows selected;

-- R�sultat sur la Base2

SESSION_ID OWNER        NAME            MODE_HELD     MODE_REQUESTE LAST_CONVERT BLOCKING_OTHERS
---------- ------------ --------------- ------------- ------------- ------------ ---------------
       156 AGREBI1M2022 COMMANDE        Row-X (SX)    None                   114 Not Blocking
       281 PARIZET1M202 CLIENT          Row-X (SX)    None                    74 Not Blocking
           2

       281 PARIZET1M202 PRODUIT         Row-X (SX)    None                    74 Not Blocking
           2

       281 PARIZET1M202 COMMANDE        Row-X (SX)    None                    74 Not Blocking
           2

-- Validation sur la Base1 uniquement
commit ;

Commit completed

-------------------------------------------------------------------------------------------------
-- Activit� 5.2 Effectuer des mises � distribu�es sur la Base1
-------------------------------------------------------------------------------------------------

-- Sur la Base1 : Ins�rer une nouvelle commande pour l'employ� 7369 
-- Sur la Base1 : Augmenter la commission de l'employ� 7369 de 2 Euros.
-- V�rifier les informations sur la transactions
-- V�rifier les informations sur les verrous
-- Effectuer un Commit: Ce commit sera un commit � deux phase
set serveroutput on
BEGIN
insert into &DRUSER..commande@&DBLINKNAME2 (pcomm#, cdate,pid#,  cid#, pnbre, pprixunit, empno) 
values(6, sysdate, 1000,1, 9, 2, 7369);

update emp
set comm= nvl(comm, 0) + 2 
WHERE EMPNO=7369;
END ;
/

old   2: insert into &DRUSER..commande@&DBLINKNAME2 (pcomm#, cdate,pid#,  cid#, pnbre, pprixunit, empno)
new   2: insert into DELMARE1M2022.commande@pdbm1mia.unice.fr (pcomm#, cdate,pid#,  cid#, pnbre, pprixunit, empno)

PL/SQL procedure successfully completed.

-------------------------------------------------------------------------------------------------
-- Activit� 5.3 : Consultation des informations sur la transaction sur les Base1 et Base2
-------------------------------------------------------------------------------------------------

col pdb_name format a10
col username format a12
col segment_name format a22
col status format A7

select ps.pdb_name, 
vs.username, 
rs.segment_name, 
vt.addr "Id trans", 
vt.status, 
vt.start_time,
vt.START_SCNB "START SCN",
vt.USED_UBLK "Block RBS"
from v$transaction vt, v$session vs, dba_rollback_segs rs, dba_pdbs ps
where vt.SES_ADDR=vs.saddr
and vt.con_id=ps.con_id
and vt.XIDUSN=rs.segment_id;

-- R�sultat sur la Base1

PDB_NAME   USERNAME     SEGMENT_NAME           Id trans         STATUS  START_TIME            START SCN  Block RBS
---------- ------------ ---------------------- ---------------- ------- -------------------- ---------- ----------
PDBL3MIA   PARIZET1M202 _SYSSMU2_2386332601$   00007FFA29CF2470 ACTIVE  11/29/21 17:57:11      48787341          1
           2

PDBL3MIA   CORBIERE1M20 _SYSSMU9_406156152$    00007FFA29C61360 ACTIVE  11/29/21 17:54:19      48785890          1
           22

PDBL3MIA   ALCARAZ1M202 _SYSSMU4_2142506228$   00007FFA29CEEA28 ACTIVE  11/29/21 17:55:30      48786480          1
           2

PDBL3MIA   KLEIN1M2022  _SYSSMU3_1537070598$   00007FFA29CC9468 ACTIVE  11/29/21 17:59:12      48788249          1
PDBL3MIA   CHENG1M2022  _SYSSMU8_3558373158$   00007FFA29C5B620 ACTIVE  11/29/21 17:57:06      48787334          1

PDB_NAME   USERNAME     SEGMENT_NAME           Id trans         STATUS  START_TIME            START SCN  Block RBS
---------- ------------ ---------------------- ---------------- ------- -------------------- ---------- ----------
PDBL3MIA   AGREBI1M2022 _SYSSMU5_1968394564$   00007FFA29C17388 ACTIVE  11/29/21 17:53:18      48785799          1
PDBL3MIA   DESLANDES1M2 _SYSSMU12_1087701674$  00007FFA29CEF5D0 ACTIVE  11/29/21 17:53:19      48785818          1
           022

PDBL3MIA   DELMARE1M202 _SYSSMU6_932124528$    00007FFA29C15090 ACTIVE  11/29/21 18:02:07      48788961          2
           2

PDBL3MIA   RETHERS1M202 _SYSSMU7_3911517261$   00007FFA29BF2970 ACTIVE  11/29/21 18:03:15      48789020          1
           2

PDBL3MIA   LEMOINE1M202 _SYSSMU10_2250472353$  00007FFA29CCE600 ACTIVE  11/29/21 17:52:35      48785734          1

PDB_NAME   USERNAME     SEGMENT_NAME           Id trans         STATUS  START_TIME            START SCN  Block RBS
---------- ------------ ---------------------- ---------------- ------- -------------------- ---------- ----------
           2


10 rows selected.

-- R�sultat sur la Base2

PDB_NAME   USERNAME     SEGMENT_NAME           Id trans         STATUS  START_TIME            START SCN  Block RBS
---------- ------------ ---------------------- ---------------- ------- -------------------- ---------- ----------
PDBM1MIA   CORBIERE1M20 _SYSSMU3_1537070598$   00007FFA29B833D8 ACTIVE  11/29/21 17:54:19      48789006          1
           22

PDBM1MIA   DESLANDES1M2 _SYSSMU1_3450900144$   00007FFA29C11648 ACTIVE  11/29/21 17:53:19      48788321          1
           022

PDBM1MIA   AGREBI1M2022 _SYSSMU17_1586838508$  00007FFA29CF3018 ACTIVE  11/29/21 17:53:18      48786930          1
PDBM1MIA   LEMOINE1M202 _SYSSMU18_2761161926$  00007FFA29B810E0 ACTIVE  11/29/21 17:52:35      48787652          1
           2

PDBM1MIA   PARIZET1M202 _SYSSMU2_2386332601$   00007FFA29BA8998 ACTIVE  11/29/21 17:57:11      48787341          1

PDB_NAME   USERNAME     SEGMENT_NAME           Id trans         STATUS  START_TIME            START SCN  Block RBS
---------- ------------ ---------------------- ---------------- ------- -------------------- ---------- ----------
           2

PDBM1MIA   ALCARAZ1M202 _SYSSMU7_3911517261$   00007FFA29CA8498 ACTIVE  11/29/21 17:55:30      48788297          1
           2

PDBM1MIA   DELMARE1M202 _SYSSMU23_2915182771$  00007FFA29C167E0 ACTIVE  11/29/21 18:02:07      48788971          1
           2


7 rows selected.

-------------------------------------------------------------------------------------------------
-- Activit� 5.4 : Consultation des informations sur les verrous DML sur les Base1 et Base2
-------------------------------------------------------------------------------------------------

set linesize 200
col OWNER format a12
col NAME  format a15
col BLOCKING_OTHERS format a15

select 
SESSION_ID,
OWNER, 
NAME,
MODE_HELD,
MODE_REQUESTED,
LAST_CONVERT,
BLOCKING_OTHERS
from dba_dml_locks;

-- R�sultat sur la Base1

SESSION_ID OWNER        NAME            MODE_HELD     MODE_REQUESTE LAST_CONVERT BLOCKING_OTHERS
---------- ------------ --------------- ------------- ------------- ------------ ---------------
       397 DELMARE1M202 EMP             Row-X (SX)    None                     1 Not Blocking
           2

-- R�sultat sur la Base2

SESSION_ID OWNER        NAME            MODE_HELD     MODE_REQUESTE LAST_CONVERT BLOCKING_OTHERS
---------- ------------ --------------- ------------- ------------- ------------ ---------------
       156 AGREBI1M2022 COMMANDE        Row-X (SX)    None                   683 Not Blocking
       282 ALCARAZ1M202 COMMANDE        Row-X (SX)    None                   503 Not Blocking
           2

        25 CHENG1M2022  CLIENT          Row-X (SX)    None                    96 Not Blocking
        25 CHENG1M2022  PRODUIT         Row-X (SX)    None                    96 Not Blocking
        25 CHENG1M2022  COMMANDE        Row-X (SX)    None                    96 Not Blocking
        13 CORBIERE1M20 COMMANDE        Row-X (SX)    None                   301 Not Blocking
           22

       407 DELMARE1M202 CLIENT          Row-X (SX)    None                    27 Not Blocking

SESSION_ID OWNER        NAME            MODE_HELD     MODE_REQUESTE LAST_CONVERT BLOCKING_OTHERS
---------- ------------ --------------- ------------- ------------- ------------ ---------------
           2

       407 DELMARE1M202 PRODUIT         Row-X (SX)    None                    27 Not Blocking
           2

       407 DELMARE1M202 COMMANDE        Row-X (SX)    None                    27 Not Blocking
           2

        19 DESLANDES1M2 COMMANDE        Row-X (SX)    None                   471 Not Blocking
           022


SESSION_ID OWNER        NAME            MODE_HELD     MODE_REQUESTE LAST_CONVERT BLOCKING_OTHERS
---------- ------------ --------------- ------------- ------------- ------------ ---------------
       405 KLEIN1M2022  COMMANDE        Row-X (SX)    None                   120 Not Blocking
       266 LEMOINE1M202 COMMANDE        Row-X (SX)    None                   538 Not Blocking
           2

       281 PARIZET1M202 CLIENT          Row-X (SX)    None                   643 Not Blocking
           2

       281 PARIZET1M202 PRODUIT         Row-X (SX)    None                   643 Not Blocking
           2

       281 PARIZET1M202 COMMANDE        Row-X (SX)    None                   643 Not Blocking

SESSION_ID OWNER        NAME            MODE_HELD     MODE_REQUESTE LAST_CONVERT BLOCKING_OTHERS
---------- ------------ --------------- ------------- ------------- ------------ ---------------
           2


15 rows selected.

-- Validation sur la Base1 uniquement
commit ;-- commit � 2 phases

-------------------------------------------------------------------------------------------------
-- Activit� 6: Transparence vis � vis de la localisation via les synonymes
-- Rendre transparent l�acc�s aux donn�es distantes gr�ce au synonymes, 
-- R�gle 4 de Chris DATE
-------------------------------------------------------------------------------------------------

drop synonym commande;
Create synonym commande for &DRUSER..commande@&DBLINKNAME2;


BEGIN
insert into commande (pcomm#, cdate,pid#,  cid#, pnbre, pprixunit, empno) 
values(7, sysdate, 1000,1, 9, 2, 7369);

update emp
set comm= nvl(comm, 0) + 2 
WHERE EMPNO=7369;

commit ;
END ;
/
-- v�rification sur Base1
select * from commande;

    PCOMM# CDATE             PID#       CID#      PNBRE  PPRIXUNIT      EMPNO
---------- ----------- ---------- ---------- ---------- ---------- ----------
         1 05-FEB-2022       1000          1          4          2       7369
         2 05-FEB-2022       1000          1         10          2       7369
         3 05-FEB-2022       1000          1          9          2       7369
         7 05-FEB-2022       1000          1          9          2       7369

-- v�rification sur Base1
select * from emp where empno=7369;

     EMPNO ENAME      JOB              MGR HIREDATE           SAL       COMM     DEPTNO
---------- ---------- --------- ---------- ----------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 17-DEC-1980        800          2         20

-------------------------------------------------------------------------------------------------
-- Activit� 7 .	Cr�er un database link public pour permettre � l�utilisateur &DRUSER 
-- depuis la Base2 de manipuler des objets � distance sur la Base1

-- Dans le cadre de cet exercice, le Database Link est d�j� cr�� par l'adminitrateur
-- Il est contenu dans la variable : DBLINKNAME1 (voir sa valeur plus haut)
-------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------
-- Activit� 8.	sur la Base2 cr�er un trigger sur la table COMMANDE qui met � jour la 
-- commission de l'employ� (qui g�re la commande) � 2 EUROS � chaque fois qu�une 
-- commande est ins�r�e ou supprim�e. 
-------------------------------------------------------------------------------------------------

-- Se connecter sur la Base2
connect &DRUSER/&DRUSERPASS@&ALIASDB2


CREATE OR REPLACE TRIGGER update_employe_comm
	AFTER DELETE OR INSERT ON commande FOR EACH ROW
	DECLARE 

BEGIN
	IF INSERTING THEN
		UPDATE &DRUSER..emp@&DBLINKNAME1 e 
SET e.comm = nvl(e.comm, 0) + 2 
WHERE empno= :new.empno;
	END IF;

	IF DELETING THEN
		UPDATE &DRUSER..emp@&DBLINKNAME1 e 
SET e.comm = decode(e.comm, null, 0, e.comm - 2)
WHERE empno= :old.empno;
	END IF;


END;
/


-------------------------------------------------------------------------------------------------
-- Activit� 9.	sur la Base1 v�rifier le fonctionnement du trigger
-------------------------------------------------------------------------------------------------

Connect &DRUSER@&ALIASDB1/&DRUSERPASS
-- v�rification du fonctionnement du trigrer sur la Base1
select * from commande;

    PCOMM# CDATE           PID#       CID#      PNBRE  PPRIXUNIT      EMPNO
---------- --------- ---------- ---------- ---------- ---------- ----------
         1 05-FEB-22       1000          1          4          2       7369
         2 05-FEB-22       1000          1         10          2       7369
         3 05-FEB-22       1000          1          9          2       7369

select * from emp where empno=7369;

     EMPNO ENAME      JOB              MGR HIREDATE         SAL       COMM     DEPTNO
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 17-DEC-80        800         10         20

BEGIN
insert into commande (pcomm#, cdate,pid#,  cid#, pnbre, pprixunit, empno) 
values(8, sysdate, 1000,1, 9, 2, 7369);


END ;
/

-- v�rification du fonctionnement du trigrer sur Base1
select * from commande;

    PCOMM# CDATE           PID#       CID#      PNBRE  PPRIXUNIT      EMPNO
---------- --------- ---------- ---------- ---------- ---------- ----------
         8 05-FEB-22       1000          1          9          2       7369
         1 05-FEB-22       1000          1          4          2       7369
         2 05-FEB-22       1000          1         10          2       7369
         3 05-FEB-22       1000          1          9          2       7369

select * from emp where empno=7369;

     EMPNO ENAME      JOB              MGR HIREDATE         SAL       COMM     DEPTNO
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 17-DEC-80        800         12         20

-- Consultation des informations sur la transaction sur la Base1 et la Base2
col pdb_name format a10
col username format a12
col segment_name format a22
col status format A7

select ps.pdb_name, 
vs.username, 
rs.segment_name, 
vt.addr "Id trans", 
vt.status, 
vt.start_time,
vt.START_SCNB "START SCN",
vt.USED_UBLK "Block RBS"
from v$transaction vt, v$session vs, dba_rollback_segs rs, dba_pdbs ps
where vt.SES_ADDR=vs.saddr
and vt.con_id=ps.con_id
and vt.XIDUSN=rs.segment_id;

-- R�sultat sur la Base1

PDB_NAME   USERNAME     SEGMENT_NAME           Id trans         STATUS  START_TIME            START SCN  Block RBS
---------- ------------ ---------------------- ---------------- ------- -------------------- ---------- ----------
PDBM1INF   DELMARE1M212 _SYSSMU2_3035727479$   000000007A223130 ACTIVE  02/05/22 10:14:38     263799229          2
           2

-- R�sultat sur la Base2

PDB_NAME   USERNAME     SEGMENT_NAME           Id trans         STATUS  START_TIME            START SCN  Block RBS
---------- ------------ ---------------------- ---------------- ------- -------------------- ---------- ----------
PDBM1MIA   DELMARE1M212 _SYSSMU2_3035727479$   000000007A173808 ACTIVE  02/05/22 10:14:38     263799445          1
           2

-- Consultation des informations sur les verrous DML sur la Base1 et la Base2
set linesize 200
col OWNER format a12
col NAME  format a15
col BLOCKING_OTHERS format a15

select 
SESSION_ID,
OWNER, 
NAME,
MODE_HELD,
MODE_REQUESTED,
LAST_CONVERT,
BLOCKING_OTHERS
from dba_dml_locks;
-- R�sultat sur la Base1

SESSION_ID OWNER        NAME            MODE_HELD     MODE_REQUESTE LAST_CONVERT BLOCKING_OTHERS
---------- ------------ --------------- ------------- ------------- ------------ ---------------
       312 DELMARE1M212 EMP             Row-X (SX)    None                   121 Not Blocking
           2

-- R�sultat sur la Base2

SESSION_ID OWNER        NAME            MODE_HELD     MODE_REQUESTE LAST_CONVERT BLOCKING_OTHERS
---------- ------------ --------------- ------------- ------------- ------------ ---------------
        31 DELMARE1M212 CLIENT          Row-X (SX)    None                   119 Not Blocking
           2

        31 DELMARE1M212 PRODUIT         Row-X (SX)    None                   119 Not Blocking
           2

        31 DELMARE1M212 COMMANDE        Row-X (SX)    None                   119 Not Blocking
           2


-- Validation sur la Base1 uniquement
commit ;

-------------------------------------------------------------------------------------------------
-- Activit� 10 : Simulation de pannes d'une transaction distribu�es

-- En cas de COMMIT distribu�, il est extr�mement compliqu� pour mettre en �vidence des 
-- pannes.
-- Il ne reste plus que la simulation.
-- On utilise pour cela l'ordre SQL :
-- COMMIT COMMENT 'ORA-2PC-CRASH-TEST-N (N �tant un des 10 num�ros de pannes)
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
-- Activit� 10.1 : Comprendre la Liste des Num�ros de Pannes
-- 1	panne d'un site en transaction (commit point site) apr�s collecte 
-- 2	panne d'un site non en transaction apr�s collecte 
-- 3	panne avant la phase de pr�paration
-- 4	panne apr�s la phase de pr�paration
-- 5	panne du commit point site avant la phase de validation 
-- 6	panne d'un site en transaction apr�s le Commit
-- 7	panne d'un site non en transaction avant le Commit*
-- 8	panne d'un site non en transaction apr�s la phase de validation
-- 9	panne d'un site en transaction apr�s la phase ignorer
-- 10	panne d'un site non en transaction avant la phase ignorer
-------------------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------------------
-- Activit� 10.2 :informations sur les transactions distribu�es 
--               Comprendre le r�le des vues DBA_2PC_PENDING et DBA_2PC_NEIGHBORS
-- Deux vues Oracle contiennent les informations sur les transactions distribu�es
-- DBA_2PC_PENDING :
-- 	. Cette vue d�crit les informations sur les transactions distribu�es en attente 
--    de recouvrement suite � une panne.
-- DBA_2PC_NEIGHBORS
--  . Cette vue d�crit les informations sur les connexions entrantes ou sortantes  des 
--    transactions distribu�es douteuses.
-------------------------------------------------------------------------------------------------



-- Se connecter sur la Base1 si ce n'est d�j� fait
Connect &DRUSER@&ALIASDB1/&DRUSERPASS


-- DBA_2PC_PENDING :
-- 	. Cette vue d�crit les informations sur les transactions distribu�es en attente 
--    de recouvrement suite � une panne.

desc DBA_2PC_PENDING


Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 LOCAL_TRAN_ID                             NOT NULL VARCHAR2(22)
 GLOBAL_TRAN_ID                                     VARCHAR2(169)
 STATE                                     NOT NULL VARCHAR2(16)
 MIXED                                              VARCHAR2(3)
 ADVICE                                             VARCHAR2(1)
 TRAN_COMMENT                                       VARCHAR2(255)
 FAIL_TIME                                 NOT NULL DATE
 FORCE_TIME                                         DATE
 RETRY_TIME                                NOT NULL DATE
 OS_USER                                            VARCHAR2(64)
 OS_TERMINAL                                        VARCHAR2(255)
 HOST                                               VARCHAR2(128)
 DB_USER                                            VARCHAR2(128)
 COMMIT#                                            VARCHAR2(16)


-- DBA_2PC_NEIGHBORS
--  . Cette vue d�crit les informations sur les connexions entrantes ou sortantes  des 
--    transactions distribu�es douteuses.

-- noeud impliqu� dans des transactions douteuses
desc DBA_2PC_NEIGHBORS

Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 LOCAL_TRAN_ID                                      VARCHAR2(22)
 IN_OUT                                             VARCHAR2(3)
 DATABASE                                           VARCHAR2(128)
 DBUSER_OWNER                                       VARCHAR2(128)
 INTERFACE                                          VARCHAR2(1)
 DBID                                               VARCHAR2(16)
 SESS#                                              NUMBER(38)
 BRANCH                                             VARCHAR2(128)

-------------------------------------------------------------------------------------------------
-- Activit� 10.3 : Consultation des informations sur les transactions douteuses
-- sur les Base1 et Base2 SANS DESACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
-- Activit� 10.3.1 : simulation de panne en cas de transaction distribu�es
-- Simulation de la panne 6 sur la Base1 SANS DESACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
-------------------------------------------------------------------------------------------------

-- Se connecter sur la Base1 si ce n'est d�j� fait
CONNECT &DRUSER@&ALIASDB1/&DRUSERPASS


select empno, ename, sal from emp where empno=7369;
col pdescription format a40

     EMPNO ENAME             SAL
---------- ---------- ----------
      7369 SMITH             800
 
select pid#, pdescription from &DRUSER..produit@&DBLINKNAME2
where pid#=1000;

      PID# PDESCRIPTION
---------- ----------------------------------------
      1000 Coca cola 2 litres avec caf?in

update emp 
set sal=sal*1.1
where empno=7369;

update &DRUSER..produit@&DBLINKNAME2
set pdescription =pdescription||'BravoBravo'
where PID#=1000;

COMMIT COMMENT 'ORA-2PC-CRASH-TEST-6';

-- Mettre le r�sultat de l'ex�cution ici
ORA-02054: transaction 6.17.26568 in-doubt
ORA-02053: transaction 6.26.12846 committed, some remote DBs may be in-doubt
ORA-02059: ORA-2PC-CRASH-TEST-6 in commit comment
ORA-02063: preceding 2 lines from PDBM1MIA



select empno, ename, sal from emp where empno=7369;

     EMPNO ENAME             SAL
---------- ---------- ----------
      7369 SMITH             880
 
select pid#, pdescription from &DRUSER..produit@&DBLINKNAME2
where pid#=1000;

      PID# PDESCRIPTION
---------- ----------------------------------------
      1000 Coca cola 2 litres avec caf?inBravoBravo

-------------------------------------------------------------------------------------------------
-- Activit� 10.3.2 : Consultation des informations sur les transactions en attente 
-- de recouvrement sur la Base1 SANS DESACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
-------------------------------------------------------------------------------------------------

set linesize 200
col GLOBAL_TRAN_ID format a12
col LOCAL_TRAN_ID format a12
col STATE format a10
col TRAN_COMMENT format a30
col OS_USER format a10
col OS_TERMINAL format a15
col HOST format a15
col DB_USER format a15
col COMMIT# format a10

select GLOBAL_TRAN_ID,
LOCAL_TRAN_ID, 
state ,
ADVICE,
TRAN_COMMENT,
FAIL_TIME,
FORCE_TIME,
RETRY_TIME,
OS_USER,
OS_TERMINAL,
HOST,
DB_USER,
COMMIT#  
from DBA_2PC_PENDING;


No row selected;

-- Que constatez vous ?

Il n y a pas de résultats 

-------------------------------------------------------------------------------------------------
-- Activit� 10.3.3 : Consultation des informations sur les noeuds impliqu�s dans des 
-- transactions douteuses sur la Base1 SANS DESACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
-------------------------------------------------------------------------------------------------

COL LOCAL_TRAN_ID FORMAT A13
COL IN_OUT FORMAT A6
COL DATABASE FORMAT A25
COL DBUSER_OWNER FORMAT A15
COL INTERFACE FORMAT A3
col SESS# format 999999
col BRANCH format A15
SELECT LOCAL_TRAN_ID, IN_OUT, DATABASE, DBUSER_OWNER, INTERFACE, SESS#, BRANCH
   FROM DBA_2PC_NEIGHBORS
/

no rows selected

-------------------------------------------------------------------------------------------------
-- Activit� 10.3.4 : Consultation des informations sur les transactions douteuses
-- sur la Base2 SANS DESACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
-------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------
-- Activit� 10.3.4.1 : Consultation des informations sur les transactions en attente 
-- de recouvrement sur la Base2 SANS DESACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
-------------------------------------------------------------------------------------------------

set linesize 200
col GLOBAL_TRAN_ID format a12
col LOCAL_TRAN_ID format a12
col STATE format a10
col TRAN_COMMENT format a30
col OS_USER format a10
col OS_TERMINAL format a15
col HOST format a15
col DB_USER format a15
col COMMIT# format a10

select GLOBAL_TRAN_ID,
LOCAL_TRAN_ID, 
state ,
ADVICE,
TRAN_COMMENT,
FAIL_TIME,
FORCE_TIME,
RETRY_TIME,
OS_USER,
OS_TERMINAL,
HOST,
DB_USER,
COMMIT#  
from DBA_2PC_PENDING;

no rows selected;

-- Que constatez vous ?

IL n y a pas de resultats

-------------------------------------------------------------------------------------------------
-- Activit� 10.3.4.2 : Consultation des informations sur les noeuds impliqu�s dans des 
-- transactions douteuses sur la Base2 SANS DESACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
-------------------------------------------------------------------------------------------------

COL LOCAL_TRAN_ID FORMAT A13
COL IN_OUT FORMAT A6
COL DATABASE FORMAT A25
COL DBUSER_OWNER FORMAT A15
COL INTERFACE FORMAT A3
col SESS# format 999999
col BRANCH format A15
SELECT LOCAL_TRAN_ID, IN_OUT, DATABASE, DBUSER_OWNER, INTERFACE, SESS#, BRANCH
   FROM DBA_2PC_NEIGHBORS
/

no rows selected

-- Que constatez vous ?

Il n y a pas de résultats

----------------------------------------------------------------------------

A partir de là je n ai pas pu continuer car nous n avons pas l acces (la machine distante UCA n etait pas dispo )

-------------------------------------------------------------------------------------------------
-- Activit� 10.4 : Consultation des informations sur les transactions douteuses
-- sur les Base1 et Base2 AVEC DESACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
-------------------------------------------------------------------------------------------------

-- Activit� 10.4.0 : DESACTIVATION DU RECOUVREMENT DISTRIBUE PAR L'ADMINISTRATEUR (ENSEIGNANT)
sqlplus /nolog
connect system@AliasRootDB/passwordCompteSystem
ALTER SYSTEM DISABLE DISTRIBUTED RECOVERY;

-- Activit� 10.4.1 : simulation de panne en cas de transaction distribu�es
-- Simulation de la panne 6 sur la Base1 AVEC DESACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6

-- Se connecter sur la Base1 si ce n'est d�j� fait
CONNECT &DRUSER@&ALIASDB1/&DRUSERPASS


select empno, ename, sal from emp where empno=7369;
col pdescription format a40

?
 
select pid#, pdescription from &DRUSER..produit@&DBLINKNAME2
where pid#=1000;

?

update emp 
set sal=sal*1.1
where empno=7369;

update &DRUSER..produit@&DBLINKNAME2
set pdescription =pdescription||'BravoBravo'
where PID#=1000;

COMMIT COMMENT 'ORA-2PC-CRASH-TEST-6';

-- Mettre le r�sultat de l'ex�cution ici
?



select empno, ename, sal from emp where empno=7369;

?
 
select pid#, pdescription from &DRUSER..produit@&DBLINKNAME2
where pid#=1000;

?

-------------------------------------------------------------------------------------------------
-- Activit� 10.4.2 : Consultation des informations sur les transactions en attente 
-- de recouvrement sur la Base1 AVEC DESACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
-------------------------------------------------------------------------------------------------

set linesize 200
col GLOBAL_TRAN_ID format a12
col LOCAL_TRAN_ID format a12
col STATE format a10
col TRAN_COMMENT format a30
col OS_USER format a10
col OS_TERMINAL format a15
col HOST format a15
col DB_USER format a15
col COMMIT# format a10

select GLOBAL_TRAN_ID,
LOCAL_TRAN_ID, 
state ,
ADVICE,
TRAN_COMMENT,
FAIL_TIME,
FORCE_TIME,
RETRY_TIME,
OS_USER,
OS_TERMINAL,
HOST,
DB_USER,
COMMIT#  
from DBA_2PC_PENDING;


?
-- Que constatez vous ?

-------------------------------------------------------------------------------------------------
-- Activit� 10.4.3 : Consultation des informations sur les noeuds impliqu�s dans des 
-- transactions douteuses sur la Base1 AVEC DESACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
-------------------------------------------------------------------------------------------------

COL LOCAL_TRAN_ID FORMAT A13
COL IN_OUT FORMAT A6
COL DATABASE FORMAT A25
COL DBUSER_OWNER FORMAT A15
COL INTERFACE FORMAT A3
col SESS# format 999999
col BRANCH format A15
SELECT LOCAL_TRAN_ID, IN_OUT, DATABASE, DBUSER_OWNER, INTERFACE, SESS#, BRANCH
   FROM DBA_2PC_NEIGHBORS
/

?


-------------------------------------------------------------------------------------------------
-- Activit� 10.4.4 : Consultation des informations sur les transactions douteuses
-- sur la Base2 AVEC DESACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
-------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------
-- Activit� 10.4.4.1 : Consultation des informations sur les transactions en attente 
-- de recouvrement sur la Base2 AVEC DESACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
------------------------------------------------------------------------------------------------


set linesize 200
col GLOBAL_TRAN_ID format a12
col LOCAL_TRAN_ID format a12
col STATE format a10
col TRAN_COMMENT format a30
col OS_USER format a10
col OS_TERMINAL format a15
col HOST format a15
col DB_USER format a15
col COMMIT# format a10

select GLOBAL_TRAN_ID,
LOCAL_TRAN_ID, 
state ,
ADVICE,
TRAN_COMMENT,
FAIL_TIME,
FORCE_TIME,
RETRY_TIME,
OS_USER,
OS_TERMINAL,
HOST,
DB_USER,
COMMIT#  
from DBA_2PC_PENDING;


?
-- Que constatez vous ?

------------------------------------------------------------------------------------------------
-- Activit� 10.4.4.2 : Consultation des informations sur les noeuds impliqu�s dans des 
-- transactions douteuses sur la Base2 AVEC DESACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
------------------------------------------------------------------------------------------------

COL LOCAL_TRAN_ID FORMAT A13
COL IN_OUT FORMAT A6
COL DATABASE FORMAT A25
COL DBUSER_OWNER FORMAT A15
COL INTERFACE FORMAT A3
col SESS# format 999999
col BRANCH format A15
SELECT LOCAL_TRAN_ID, IN_OUT, DATABASE, DBUSER_OWNER, INTERFACE, SESS#, BRANCH
   FROM DBA_2PC_NEIGHBORS
/
?
-- Que constatez vous ?




------------------------------------------------------------------------------------------------
-- Activit� 10.5 : Consultation des informations sur les transactions douteuses
-- sur les Base1 et Base2 AVEC REACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------
-- Activit� 10.5.0 : REACTIVATION DU RECOUVREMENT DISTRIBUE PAR L'ADMINISTRATEUR (ENSEIGNANT)
------------------------------------------------------------------------------------------------

connect system@AliasRootDB/passwordCompteSystem

-- activer deux fois !!!
ALTER SYSTEM ENABLE DISTRIBUTED RECOVERY;
ALTER SYSTEM ENABLE DISTRIBUTED RECOVERY;
------------------------------------------------------------------------------------------------
-- Activit� 10.5.1 : Consultation des donn�es modifi�es en cas de transaction distribu�es
-- et de Simulation de la panne 6 sur la Base1 AVEC REACTIVATION DU RECOUVREMENT DISTRIBUE
------------------------------------------------------------------------------------------------

-- Se connecter sur la Base1 si ce n'est d�j� fait
CONNECT &DRUSER@&ALIASDB1/&DRUSERPASS


select empno, ename, sal from emp where empno=7369;
col pdescription format a40

?
 
select pid#, pdescription from &DRUSER..produit@&DBLINKNAME2
where pid#=1000;

?



------------------------------------------------------------------------------------------------
-- Activit� 10.5.2 : Consultation des informations sur les transactions en attente 
-- de recouvrement sur la Base1 AVEC REACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
------------------------------------------------------------------------------------------------

set linesize 200
col GLOBAL_TRAN_ID format a12
col LOCAL_TRAN_ID format a12
col STATE format a10
col TRAN_COMMENT format a30
col OS_USER format a10
col OS_TERMINAL format a15
col HOST format a15
col DB_USER format a15
col COMMIT# format a10

select GLOBAL_TRAN_ID,
LOCAL_TRAN_ID, 
state ,
ADVICE,
TRAN_COMMENT,
FAIL_TIME,
FORCE_TIME,
RETRY_TIME,
OS_USER,
OS_TERMINAL,
HOST,
DB_USER,
COMMIT#  
from DBA_2PC_PENDING;


?
-- Que constatez vous ?

------------------------------------------------------------------------------------------------
-- Activit� 10.5.3 : Consultation des informations sur les noeuds impliqu�s dans des 
-- transactions douteuses sur la Base1 AVEC REACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
------------------------------------------------------------------------------------------------

COL LOCAL_TRAN_ID FORMAT A13
COL IN_OUT FORMAT A6
COL DATABASE FORMAT A25
COL DBUSER_OWNER FORMAT A15
COL INTERFACE FORMAT A3
col SESS# format 999999
col BRANCH format A15
SELECT LOCAL_TRAN_ID, IN_OUT, DATABASE, DBUSER_OWNER, INTERFACE, SESS#, BRANCH
   FROM DBA_2PC_NEIGHBORS
/



------------------------------------------------------------------------------------------------
-- Activit� 10.5.4 : Consultation des informations sur les transactions douteuses
-- sur la Base2 AVEC REACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------
-- Activit� 10.5.4.1 : Consultation des informations sur les transactions en attente 
-- de recouvrement sur la Base2 AVEC REACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
------------------------------------------------------------------------------------------------

set linesize 200
col GLOBAL_TRAN_ID format a12
col LOCAL_TRAN_ID format a12
col STATE format a10
col TRAN_COMMENT format a30
col OS_USER format a10
col OS_TERMINAL format a15
col HOST format a15
col DB_USER format a15
col COMMIT# format a10

select GLOBAL_TRAN_ID,
LOCAL_TRAN_ID, 
state ,
ADVICE,
TRAN_COMMENT,
FAIL_TIME,
FORCE_TIME,
RETRY_TIME,
OS_USER,
OS_TERMINAL,
HOST,
DB_USER,
COMMIT#  
from DBA_2PC_PENDING;


?
-- Que constatez vous ?

------------------------------------------------------------------------------------------------
-- Activit� 10.5.4.2 : Consultation des informations sur les noeuds impliqu�s dans des 
-- transactions douteuses sur la Base2 AVEC REACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
------------------------------------------------------------------------------------------------

COL LOCAL_TRAN_ID FORMAT A13
COL IN_OUT FORMAT A6
COL DATABASE FORMAT A25
COL DBUSER_OWNER FORMAT A15
COL INTERFACE FORMAT A3
col SESS# format 999999
col BRANCH format A15
SELECT LOCAL_TRAN_ID, IN_OUT, DATABASE, DBUSER_OWNER, INTERFACE, SESS#, BRANCH
   FROM DBA_2PC_NEIGHBORS
/
?
-- Que constatez vous ?




------------------------------------------------------------------------------------------------
-- Activit� 11 : REPRENDRE LES ACTIVITES 10. avec une autre panne par exemple : PANNE 3
------------------------------------------------------------------------------------------------
