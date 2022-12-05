/*Creazione di un piccolo DB per la fatturazione, in questo DB avremo 3 tabelle : Cliente, Prodotto, Fattura. 
poi avremo una tabella di associazione ( dett_fatt ), che sarà la tabella di associazione, dove troveremo
id_fatt e id_prod che servono per la crazione della relazione, e avere tutti i dati necessari della fattura 
e dai prodotti associati alla fattura. per questo DB Oracle utilizzo la versione 11g, un cui non è presente 
l'auto incremento, e per ovviare a cio' ho utilizato la sequenze e il trigger, al momento la migliore soluzione 
che ho trovato. Successivamente, verra' implementata una parte in java che andra' a gestire il tutto e stampera' 
o visualizzera' la fattura, cin la possibilita' di eseguire le principali azioni sul db ( insert, udate, delete)*/


drop table dett_fatt;
drop table fattura;
drop table prodotto;
drop table cliente;
drop trigger clnt_trg;
drop trigger trg_data_upd;
drop trigger dett_trg;
drop trigger trg_data_upd_dett;
drop trigger fatt_trg;
drop trigger trg_data_upd_fatt;
drop trigger prod_trg;
drop trigger trg_data_upd_prod;
drop sequence seq_id_clnt;
drop sequence seq_id_dett;
drop sequence seq_id_fatt;
drop sequence seq_id_prod;


CREATE TABLE CLIENTE(
    id_clnt 	NUMBER(5) NOT NULL,
    piva 		VARCHAR2(11 CHAR) UNIQUE NOT NULL,
    cod_fisc 	VARCHAR2(16) UNIQUE,
    nome_clnt 	VARCHAR2(100) NOT NULL,
    via_clnt 	VARCHAR2(100) NOT NULL,
    cap_clnt 	VARCHAR2(100) NOT NULL,
    citta_clnt 	VARCHAR2(100) NOT NULL,
    data_ins 	DATE DEFAULT SYSDATE,
    data_upd 	DATE NULL,
    deleted 	CHAR (1) DEFAULT 'N',
    constraint clnt_pk PRIMARY KEY (id_clnt)
);

create or replace trigger trg_data_upd
  before insert or update on cliente
  for each row
begin
  :new.data_upd := sysdate;
end;
/

--creazione sequence
CREATE SEQUENCE  seq_id_clnt START WITH 1;

--creazione trigger 
CREATE OR REPLACE TRIGGER trg_clnt 
BEFORE INSERT ON cliente 
FOR EACH ROW

BEGIN
  SELECT seq_id_clnt.NEXTVAL
  INTO   :new.id_clnt
  FROM   dual;
END;
/



CREATE TABLE PRODOTTO(
    id_prod 	NUMBER(5) NOT NULL,
    cod_prod 	NUMBER(5) NOT NULL,
    nome_prod 	VARCHAR2(100) NOT NULL,
    desc_prod 	VARCHAR2(100),
    imponibile 	NUMBER(10,2) NOT NULL, 
    imposta 	NUMBER(5) NOT NULL,
    data_ins 	DATE DEFAULT SYSDATE,
    data_upd 	DATE NULL,
    deleted 	CHAR (1) DEFAULT 'N',
    CONSTRAINT prod_pk PRIMARY KEY (id_prod)
);
create or replace trigger trg_data_upd_prod
  before insert or update on prodotto
  for each row
begin
  :new.data_upd := sysdate;
end;
/
--creazione sequence
CREATE SEQUENCE  SEQ_ID_PROD MINVALUE 1 INCREMENT BY 1 START WITH 1;
-- creazione trigger
CREATE OR REPLACE TRIGGER trg_prod
BEFORE INSERT ON prodotto 
FOR EACH ROW

BEGIN
  SELECT seq_id_prod.NEXTVAL
  INTO   :new.id_prod
  FROM   dual;
END;
/


CREATE TABLE FATTURA(
    id_fatt 		NUMBER(5) NOT NULL,
    num_fatt 		NUMBER(6) NOT NULL ,
    data_fatt 		DATE DEFAULT SYSDATE NOT NULL,
    id_clnt 	    NUMBER(5) NOT NULL,
    piva 		    VARCHAR2(11 CHAR) UNIQUE NOT NULL,
    cod_fisc    	VARCHAR2(16) UNIQUE,
    nome_clnt   	VARCHAR2(100) NOT NULL,
    via_clnt 	    VARCHAR2(100) NOT NULL,
    cap_clnt 	    VARCHAR2(100) NOT NULL,
    citta_clnt 	    VARCHAR2(100) NOT NULL,
    id_prod 	    NUMBER(5) NOT NULL,
    cod_prod 	    NUMBER(5) NOT NULL,
    nome_prod 	    VARCHAR2(100) NOT NULL,
    desc_prod 	    VARCHAR2(100),
    quant 		    NUMBER(5) NOT NULL,
    imponibile 	    NUMBER(10,2) NOT NULL, 
    imposta 	    NUMBER(5) NOT NULL,
    imponibile_tot 	NUMBER(10,2) NOT NULL,
    imposta_tot 	NUMBER(10,2) NOT NULL,
    tot_cmpl 		NUMBER(10,2) NOT NULL,
    data_ins 		DATE DEFAULT SYSDATE,
    data_upd		DATE NULL,
    deleted 		CHAR (1) DEFAULT 'N',
    CONSTRAINT fatt_pk PRIMARY KEY (id_fatt),
    CONSTRAINT fk_fatt FOREIGN KEY (id_clnt) REFERENCES cliente(id_clnt)
);
create or replace trigger trg_data_upd_fatt
  before insert or update on fattura
  for each row
begin
  :new.data_upd := sysdate;
end;
/
--creazione sequence
CREATE SEQUENCE  SEQ_ID_fatt MINVALUE 1 INCREMENT BY 1 START WITH 1;
-- creazione trigger
CREATE OR REPLACE TRIGGER trg_fatt
BEFORE INSERT ON fattura 
FOR EACH ROW

BEGIN
  SELECT seq_id_fatt.NEXTVAL
  INTO   :new.id_fatt
  FROM   dual;
END;
/

CREATE SEQUENCE  SEQ_num_fatt MINVALUE 1 INCREMENT BY 1 START WITH 1;
-- creazione trigger
CREATE OR REPLACE TRIGGER trg_fatt
BEFORE INSERT ON fattura 
FOR EACH ROW

BEGIN
  SELECT seq_num_fatt.NEXTVAL
  INTO   :new.num_fatt
  FROM   dual;
END;
/




CREATE TABLE DETT_FATT(
    id_dett 	NUMBER(5) NOT NULL,
    id_fatt		NUMBER(5) NOT NULL,
    id_prod 	NUMBER(11) NOT NULL,
    quantita    NUMBER(6) NOT NULL,
    data_ins	DATE DEFAULT SYSDATE,
    data_upd	DATE NULL,
    deleted 	CHAR (1) DEFAULT 'N', 
    CONSTRAINT dett_pk PRIMARY KEY (id_dett),
    CONSTRAINT fk_fattura FOREIGN KEY (id_fatt) REFERENCES fattura(id_fatt),
    CONSTRAINT fk_prod FOREIGN KEY (id_prod) REFERENCES prodotto(id_prod)
);
create or replace trigger trg_data_upd_dett
  before insert or update on dett_fatt
  for each row
begin
  :new.data_upd := sysdate;
end;
/
--creazione sequence
CREATE SEQUENCE  SEQ_ID_DETT MINVALUE 1 INCREMENT BY 1 START WITH 1;
-- creazione trigger
CREATE OR REPLACE TRIGGER trg_dett
BEFORE INSERT ON dett_fatt 
FOR EACH ROW

BEGIN
  SELECT seq_id_dett.NEXTVAL
  INTO   :new.id_dett
  FROM   dual;
END;
/



select* from cliente;
INSERT INTO cliente (piva, nome_clnt, via_clnt, cap_clnt, citta_clnt)
VALUES(01236547898,'nome coliente1', 'piazza la bomba e scappa, snc','74014', 'laterza' );
INSERT INTO cliente (piva, nome_clnt, via_clnt, cap_clnt, citta_clnt)
VALUES(21236547898,'nome coliente2', 'via monte procinto,2','74005', 'viareggio' );
INSERT INTO cliente (piva, nome_clnt, via_clnt, cap_clnt, citta_clnt)
VALUES(31236547898,'nome coliente3', 'via monte sumbra,54','74005', 'viareggio' );
INSERT INTO cliente (piva, nome_clnt, via_clnt, cap_clnt, citta_clnt)
VALUES(41236547898,'nome coliente4', 'via cappuccini,10','84005', 'poggio' );


select * from prodotto;
INSERT INTO prodotto (cod_prod, nome_prod, desc_prod, imponibile, imposta)
VALUES(123,'penna blu', 'penna a sfera', 0.20, 22);
INSERT INTO prodotto (cod_prod, nome_prod, desc_prod, imponibile, imposta)
VALUES(124,'penna rossa', 'penna a sfera', 0.20, 22);
INSERT INTO prodotto (cod_prod, nome_prod, desc_prod, imponibile, imposta)
VALUES(125,'gomma grande', 'gomma per cancellare ', 0.50, 22);
INSERT INTO prodotto (cod_prod, nome_prod, desc_prod, imponibile, imposta)
VALUES(520,'detersivo profumato', 'detersivo profumato orchidea', 1.50, 10);


select * from fattura;
INSERT INTO fattura ()
VALUES(123,'penna blu', 'penna a sfera', 0.20, 22);


select * from dett_fatt;
INSERT INTO dett_fatt (id_fatt)
VALUES();


