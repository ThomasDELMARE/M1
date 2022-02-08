ACT 1 : 

sqlplus /nolog

define SERVICEDB2=PDBM1INF.631174089.oraclecloud.internal
define DBLINKNAME2=pdbm1mia
define ALIASDB1=PDBM1INF

define DRUSER=DELMARE1M2122
define DRUSERPASS=DELMARE1M212201

define SCRIPTPATH=E:\School\MIAGE\Git\M1\BDD\Scripts

Connect &DRUSER@&ALIASDB1/&DRUSERPASS

@&SCRIPTPATH\chap8_demobld.sql

desc &DRUSER..produit@&DBLINKNAME2
desc &DRUSER..commande@&DBLINKNAME2
desc &DRUSER..client@&DBLINKNAME2

select *
from &DRUSER..commande@&DBLINKNAME2;

set linesize 200
col CADR format A20
select * from &DRUSER..client@&DBLINKNAME2;

set linesize 200
col pnom format A30
col pdescription format A40

select * from &DRUSER..produit@&DBLINKNAME2;

Update &DRUSER..commande@&DBLINKNAME2
Set empno= 7369;

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

Commit;

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

commit ;

Select c.pcomm#, c.pid#, e.empno , c.PPRIXUNIT
from &DRUSER..commande@&DBLINKNAME2  c, 
&DRUSER..produit@&DBLINKNAME2 p, 
emp e
where c.pid#=p.pid# and c.empno=e.Empno;

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

commit ;

set serveroutput on
BEGIN
insert into &DRUSER..commande@&DBLINKNAME2 (pcomm#, cdate,pid#,  cid#, pnbre, pprixunit, empno) 
values(6, sysdate, 1000,1, 9, 2, 7369);

update emp
set comm= nvl(comm, 0) + 2 
WHERE EMPNO=7369;
END ;
/

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

commit ;-- commit � 2 phases

-- ACTIVITE 6 DEBUT

-- drop  synonym commande;
Create  synonym commande for &DRUSER..commande@&DBLINKNAME2;


BEGIN
insert into commande (pcomm#, cdate,pid#,  cid#, pnbre, pprixunit, empno) 
values(7, sysdate, 1000,1, 9, 2, 7369);

update emp
set comm= nvl(comm, 0) + 2 
WHERE EMPNO=7369;

commit ;
END ;
/

select * from commande;

select * from emp where empno=7369;

Connect &DRUSER@&ALIASDB1/&DRUSERPASS

select * from commande;

select * from emp where empno=7369;

BEGIN
insert into commande (pcomm#, cdate,pid#,  cid#, pnbre, pprixunit, empno) 
values(8, sysdate, 1000,1, 9, 2, 7369);


END ;
/

select * from commande;

select * from emp where empno=7369;

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

commit ;

Connect &DRUSER@&ALIASDB1/&DRUSERPASS

select empno, ename, sal from emp where empno=7369;
col pdescription format a40

select pid#, pdescription from &DRUSER..produit@&DBLINKNAME2
where pid#=1000;

update emp 
set sal=sal*1.1
where empno=7369;

update &DRUSER..produit@&DBLINKNAME2
set pdescription =pdescription||'BravoBravo'
where PID#=1000;

COMMIT COMMENT 'ORA-2PC-CRASH-TEST-6';

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





































ACT 2 :

sqlplus /nolog
define SERVICEDB1=PDBM1INF.631174089.oraclecloud.internal
define DBLINKNAME1=PDBM1INF
define ALIASDB2=pdbm1mia

define DRUSER=DELMARE1M2122
define DRUSERPASS=DELMARE1M212201

define SCRIPTPATH=E:\School\MIAGE\Git\M1\BDD\Scripts

Connect &DRUSER@&ALIASDB2/&DRUSERPASS

@&SCRIPTPATH\chap8_clientbld.sql

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

-- ACTIVITE 6 DEBUT

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