
drop table commande;
drop table produit;
drop table client;

CREATE TABLE CLIENT(
	cid# 	number(6) primary key,
	cnom	varchar2(20),
	cdnaiss date,
	cadr	varchar2(50)
);

alter session set nls_language=american;

insert into client
values (1, 'Akim', to_date('12-DEC-1972','DD-MON-YYYY'), 'Washington');
insert into client
values (2, 'Erzulie', to_date('12-DEC-1942','DD-MON-YYYY'), 'Artibonite');

create table produit(
	pid# 	number(6) primary key,
	pnom	varchar2(50),
	pdescription	varchar2(100),
	pprixunit	number(7,2) unique
);

insert into produit values(1000, 'Coca cola 2 litres', 'Coca cola 2 litres avec caféin', 2);
insert into produit values(1001, 'orangina pack de 6 bouteilles de 1,5 litres', 'orangina pack de 6 bouteilles de 1,5 litres', 6);

create table commande(
	pcomm# 	number(6) primary key,
	cdate	date,
	pid#	number(6) 
		references produit(pid#),
	cid#	number(6) 
		references client(cid#),
	pnbre	number(4),
	pprixunit	number(7,2)references produit(pprixunit),
	empno	number(4)
);

insert into commande (pcomm#, cdate,pid#,  cid#, pnbre, pprixunit, empno) 
values(1, sysdate, 1000,1, 4, 2, 7369 );
insert into commande (pcomm#, cdate,pid#,  cid#, pnbre, pprixunit, empno) 
values(2, sysdate, 1000,1, 10, 2, 7369 );
insert into commande (pcomm#, cdate,pid#,  cid#, pnbre, pprixunit, empno) 
values(3, sysdate, 1000,1, 9, 2, 7369);

commit;
