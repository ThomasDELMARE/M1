/*

MISE EN OEUVRE DE LA REPRISE SUR PANNE A FROID AVEC ORACLE.

Etape 1: V�rification du mode d'archivage et de la destination des archives
Etape 2: Faire passer la base de donn�es en mode avec archive si n�cessaire
Etape 3: Redimensionner la zone de r�cup�ration rapide si n�cessaire
Etape 4: Effectuer la sauvegarde d'une base de donn�es pluggable
Etape 5: Effectuer la sauvegarde des archives de fichiers redolog
Etape 6: Consultation des jeux de sauvegardes
Etape 7: Provoquer une activit� sur la pluggable avant de faire disparaitre des fichiers
Etape 8: Provoquer des points de sauvegarde (checkpoint) en passant d'un groupe de log � un autre
Etape 9: Sauvegarder � nouveau les fichiers d'archives y compris les nouveaux
Etape 10: Provoquer une panne disque en faisant disparaitre un fichier de la pluggable
Etape 11: Tentez d'ouvrir la pluggable apr�s la disparition d'un de ses fichiers
Etape 12: Restauration du fichier perdu depuis le backup
Etape 13: Tentez � nouveau d'ouvrir la pluggable apr�s la disparition d'un de ses fichiers
Etape 14: Recouvrez le fichier restaur� de la pluggable 
Etape 15: Tentez � nouveau d'ouvrir la pluggable apr�s le recouvrement
Etape 16: V�rifiez que les mises � jour effectu�es dans le fichier restaur� ne sont pas perdus


*/

-- Etape 1: V�rification du mode d'archivage et de la destination des archives
-- V�rifier si la base de donn�es fonctionnement en mode avec archive : LOG_MODE
-- V�rifier aussi ou sont stcok�es les archives : db_recovery_file_dest
-- V�rifier aussi la taille de la zone de r�cup�ration rapide : db_recovery_file_dest_size

set ORACLE_SID=dbtest19
rman>connect target sys
connect� � la base de donn�es cible : DBTEST19 (DBID=4259023010)

rman>Select name, LOG_MODE from v$database; 
 NAME      LOG_MODE
--------- ------------
DBTEST19  ARCHIVELOG

rman>select name, value from v$parameter where name like 'db%recovery%';
NAME							VALUE
db_recovery_file_dest			D:\app\Oracle19c\flash_recovery_area                                                                  
db_recovery_file_dest_size		53687091200 
           
rman>select dest_name, DESTINATION, process , status, ARCHIVER, target
from V$ARCHIVE_DEST 
where dest_name='LOG_ARCHIVE_DEST_1';
dest_name			DESTINATION				  process 	 status    ARCHIVER	  target
LOG_ARCHIVE_DEST_1	USE_DB_RECOVERY_FILE_DEST ARCH       VALID     ARCH       PRIMARY

-- Etape 2: Faire passer la base de donn�es en mode avec archive si n�cessaire

-- Faire passer obligatoirement la base de donn�es en mode avec archive
-- si log_mode vaut NOARCHIVELOG
-- Si log_mode vaut ARCHIVELOG, passer cette �tape.
rman>shutdown immediate;
rman>startup mount;
rman>archive log list;
rman>alter database archivelog;
rman>archive log list;
rman>alter database open;


-- Etape 3: Redimensionner la zone de r�cup�ration rapide si n�cessaire

-- Si la valeur du param�tre db_recovery_file_dest_size est inf�rieur au volumes
-- de donn�es que vous voulez stock�es dans la zone de r�cup�ration rapide,
-- augmenter sa taille.

rman> alter system set db_recovery_file_dest_size=50G;


-- Etape 4: Effectuer la sauvegarde d'une base de donn�es pluggable
-- Afin de montrer le fonctionnement de reprise sur panne � froid.
-- Il commencer par effectuer la Sauvegarde des fichiers de la base de donn�es 
-- pluggable PDBTEST19

RMAN> BACKUP PLUGGABLE DATABASE PDBTEST19 INCLUDE CURRENT CONTROLFILE;


-- ?
*
-- Etape 5: Effectuer la sauvegarde des archives de fichiers redolog

-- Afin de montrer le fonctionnement de reprise sur panne � froid.
-- Il commencer aussi sauvegarder pour leur s�curit� les fichiers d'archives 
-- Les fichiers d'archives contiennent les majs effectu�es sur les diff�rentes
-- pluggables ainsi que la CDB. Cette sauvegarde se pour cela uniquement au 
-- niveau CDB

rman> BACKUP ARCHIVELOG ALL ; ##NOT BACKED UP SINCE TIME 'SYSDATE-1';

-- ?


-- Etape 6: Consultation des jeux de sauvegardes
-- Consultation des jeux de sauvegarde (Backup set)
RMAN> list backup;

-- ?

-- Etape 7: Provoquer une activit� sur la pluggable avant de faire disparaitre des fichiers
-- Provoquer de l�activit� sur la base de donn�es pluggable 
-- Cr�ation d'une table dans le sch�ma d'un utilisateur
-- et insertion de lignes.
-- Changer au moins 6 fois de groupe de fichiers redolog
-- Pour provoquer l'archivage des fichiers redolog
-- Pour provoquer cette activit� nous devons �tre connect�s au niveau
-- de la pluggable.
rman> exit;
rman> connect target sys@pdbtest19
rman> drop table pdbadmin.employe2;
rman> create table pdbadmin.employe2(
empno number(5),
ename varchar2(20),
sal   number(8,2)
)
segment creation immediate
tablespace  users;

rman> insert into pdbadmin.employe2
values (1, 'King', 10000);

rman> insert into pdbadmin.employe2
values (2, 'Li', 10000);

rman> insert into pdbadmin.employe2
values (3, 'Wong', 12000);
rman> commit;


-- Etape 8: Provoquer des points de sauvegarde (checkpoint) en passant d'un groupe de 
-- log � un autre

-- Provoquer de fa�on forc� l'archivage des fichiers redolog
-- Cette op�ration n'est possible qu'au niveau de la Container database (CDB)

rman>exit;
rman> connect target sys
rman> alter system switch logfile;
rman> alter system switch logfile;

rman> alter system switch logfile;

rman> alter system switch logfile;

rman> alter system switch logfile;

rman> alter system switch logfile;


-- Etape 9: Sauvegarder � nouveau les fichiers d'archives y compris les nouveaux

-- Sauvegarder les fichiers d'archives y compris les nouveaux : Uniquement 
-- au niveau CDB

rman> backup archivelog all;

-- Etape 10: Provoquer une panne disque en faisant disparaitre un fichier de la pluggable
-- Provoquer une panne disque. Par exemple la perte du fichier USERS01.DBF
-- du tablespace USERS dans la pluggable. Ou r�side la table PDBADMIN.EMPLOYE2



-- Pour cela il faut : Arr�ter la base pluggable avant de faire disparaitre le 
-- fichier USERS01.DBF
rman> alter pluggable database pdbtest19 close;


-- Ouvrir un invite de Commandes : CMD
-- Faire disparaitre le fichier USERS01.DBF

-- Fixer le chemin vers les fichiers de la pluggable pdbtest19
set PDBPATH=D:\app\Oracle19c\oradata\DBTEST19\pdbtest19

cd %PDBPATH%

mkdir sauvUser

move users01.dbf sauvUser

-- Etape 11: Tentez d'ouvrir la pluggable apr�s la disparition d'un de ses fichiers
-- Apr�s avoir fait disparaitre le fichier, il faut tenter red�marrer la base pluggable 
rman> alter pluggable database pdbtest19 open;

-- Erreurs ?
RMAN-00571: ===========================================================
RMAN-00569: =============== ERROR MESSAGE STACK FOLLOWS ===============
RMAN-00571: ===========================================================
RMAN-03002: �chec de la commande sql statement � 05/16/2021 16:13:17
ORA-01157: impossible d'identifier ou de verrouiller le fichier de donn�es 12 - voir le fichier trace DBWR
ORA-01110: fichier de donn�es 12 : 'D:\APP\ORACLE19C\ORADATA\DBTEST19\PDBTEST19\USERS01.DBF'


-- Etape 12: Restauration du fichier perdu depuis le backup
-- Restaurer le fichier users01.dbf depuis le backup
-- La restauration repositionne le fichier USERS01.DBF dans son r�pertoire d'Origine
-- Il s'agit par contre d'une ancienne version.

RMAN> restore pluggable database pdbtest19;


-- Etape 13: Tentez � nouveau d'ouvrir la pluggable apr�s la disparition d'un de ses fichiers
-- Apr�s avoir restaur� le fichier users01.dbf tentez d'ouvrir la base de donn�es
-- pluggable.
-- Impossible d'ouvrir la pluggable car le fichier users01.dbf a besoin d'�tre recouvr�.
rman> alter pluggable database pdbtest19 open;

RMAN-00571: ===========================================================
RMAN-00569: =============== ERROR MESSAGE STACK FOLLOWS ===============
RMAN-00571: ===========================================================
RMAN-03002: �chec de la commande sql statement � 05/16/2021 16:15:54
ORA-01113: le fichier 13 n�cessite une restauration physique
ORA-01110: fichier de donn�es 13 : 'D:\APP\ORACLE19C\ORADATA\DBTEST19\PDBTEST19\TS_AIRBASE_01.DBF'


-- Etape 14: Recouvrez le fichier restaur� de la pluggable 

-- Apr�s avoir restaur� le fichier users01.dbf il faut d'abord Recouvrez le fichier restor�

RMAN> recover pluggable database pdbtest19;

?

-- Etape 15: Tentez � nouveau d'ouvrir la pluggable apr�s le recouvrement
-- Apr�s avoir recouvr� le fichier users01.dbf il est maintenant possible d'ouvrir la 
-- la pluggable database

rman> alter pluggable database pdbtest19 open;


-- Etape 16: V�rifiez que les mises � jour effectu�es dans le fichier restaur� ne sont pas perdus
-- Apr�s avoir ouvert avec succ�s la pluggable database, il faut v�rifier que la table
-- PDBADMIN.EMPLOYE2 et ses lignes n'ont pas �t� perdues.
rman> exit;
rman> connect target sys@pdbtest19
rman> describe pdbadmin.employe2;


 -- ?

 rman> select * from pdbadmin.employe2;

-- ?


























