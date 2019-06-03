CREATE DATABASE WarehouseManagement;
USE WarehouseManagement;

--�ֿ⡾�ֿ��ţ��ֿ����ƣ��ֿ��ַ��
--STORAGE(STID CHAR(4),STNAME CHAR(20),STADRESS CHAR(200));
--����Ϊ�ֿ���
CREATE TABLE STORAGE(
STID CHAR(5) PRIMARY KEY,
STNAME VARCHAR(20) NOT NULL,
STADRESS VARCHAR(200)
);

--��Ʒ����Ʒ�š���Ʒ�����ֿ��š���Ʒ��������������ҡ�
--COMMODITY(CID CHAR(13), CNAME CHAR(50), STID CHAR(4),STORE INT,MANUFACTURER CHAR(50));
--����Ϊ��Ʒ�ţ�����Ϊ�ֿ��ţ���Ʒ�����ڵ���0
CREATE TABLE COMMODITY(
CID CHAR(13) PRIMARY KEY, 
CNAME VARCHAR(50) NOT NULL, 
STID CHAR(5),
STORE INT CHECK(STORE>=0),
MANUFACTURER VARCHAR(50),
FOREIGN KEY(STID) REFERENCES STORAGE(STID)
);

--���������������š���Ʒ�š��ֿ��š���������������ʱ�䡢�������ҡ���������
--STOCK(SID CHAR(10), CID CHAR(13), STID CHAR(4)��SNUM INT,STIME CHAR(11),MANUFACTURER CHAR(50),CHECKRESULT CHAR(1));
--����Ϊ�������ţ�����Ϊ��Ʒ�š��ֿ���,������Ϊ��Y����N��
CREATE TABLE STOCK(
SID CHAR(10) PRIMARY KEY, 
CID CHAR(13), 
STID CHAR(5),
SNUM INT,
STIME CHAR(10),
MANUFACTURER VARCHAR(50),
CHECKRESULT CHAR(1),
FOREIGN KEY(CID) REFERENCES COMMODITY(CID),
FOREIGN KEY(STID) REFERENCES STORAGE(STID)
);

--���������������š���Ʒ�š��ֿ��š���������������ʱ�䡢��������
--DELIVER(DID CHAR(10),CID CHAR(13),STID CHAR(4)��DNUM INT,DTIME CHAR(11),CHECKRESULT CHAR(1));
--����Ϊ�������ţ�����Ϊ��Ʒ�š��ֿ��ţ�������Ϊ��Y����N��
CREATE TABLE DELIVER(
DID CHAR(10) PRIMARY KEY,
CID CHAR(13),
STID CHAR(5),
DNUM INT,
DTIME CHAR(10),
CHECKRESULT CHAR(1),
FOREIGN KEY(CID) REFERENCES COMMODITY(CID),
FOREIGN KEY(STID) REFERENCES STORAGE(STID)
);

--ȱ���ǼǱ�ȱ�����š��������š���Ʒ�š��ֿ��š��Ǽ�ʱ�䡢ȱ������
--STOCKOUT(SOID CHAR(10),DID CHAR(10),CID CHAR(13),STID CHAR(4)��SOTIME CHAR(11),SONUM INT);
--����Ϊȱ�����ţ�����Ϊ�������š���Ʒ�š��ֿ���
CREATE TABLE STOCKOUT(
SOID CHAR(10) PRIMARY KEY,
DID CHAR(10),
CID CHAR(13),
STID CHAR(5),
SOTIME CHAR(10),
SONUM INT,
FOREIGN KEY(DID) REFERENCES DELIVER(DID),
FOREIGN KEY(CID) REFERENCES COMMODITY(CID),
FOREIGN KEY(STID) REFERENCES STORAGE(STID)
);

--ְ�������š��������Ա����䡢ְλ��
--EMPLOYEE(EID CHAR(10),ENAME CHAR(10),SEX CHAR(2),AGE INT,POSITION CHAR(10));
--����Ϊ���ţ����������ɫ������Ȩ�ޣ����ۡ��ɹ�����ˡ�����
CREATE TABLE EMPLOYEE(
EID CHAR(10) PRIMARY KEY,
ENAME CHAR(10) NOT NULL,
SEX CHAR(2),
AGE INT,
POSITION CHAR(10)
);

--�û����û��������롢Ȩ�ޡ�
--����Ϊ�û���������Ϊ�û�����ְԱ���ţ���Ȩ�޷�Ϊ���ࣺ����(GuanLi)������(XiaoShou)���ɹ�(CaiGou)�����(ShenHe)
CREATE TABLE DB_USER(
DB_USER_NAME CHAR(10)PRIMARY KEY,
DB_PASSWORD CHAR(6),
PERMISSION CHAR(4),
FOREIGN KEY(DB_USER_NAME) REFERENCES EMPLOYEE(EID)
);

--������½�ʻ���create login��
--��½�ʻ���Ϊ����Xiao��,��½���룺123456��,Ĭ�����ӵ������ݿ⣺��WarehouseManagement����
--��½�ʻ���Ϊ����Cai��,��½���룺123456��,Ĭ�����ӵ������ݿ⣺��WarehouseManagement����
--��½�ʻ���Ϊ����Shen��,��½���룺123456��,Ĭ�����ӵ������ݿ⣺��WarehouseManagement����
--��½�ʻ���Ϊ����Guan��,��½���룺123456��,Ĭ�����ӵ������ݿ⣺��WarehouseManagement����
create login Xiao with password='123456', default_database = WarehouseManagement;
create login Cai with password='123456', default_database = WarehouseManagement;
create login Shen with password='123456', default_database = WarehouseManagement;
create login Guan with password='123456', default_database = WarehouseManagement;

--Ϊ��½�˻��������ݿ��û���create user��,��Movie���ݿ��е�security�е�user�¿����ҵ�
--��ָ�����ݿ��û���Ĭ�� schema �ǡ�dbo��
create user Xiao for login Xiao with default_schema = dbo;
create user Cai for login Cai with default_schema = dbo;
create user Shen for login Shen with default_schema = dbo;
create user Guan for login Guan with default_schema = dbo;

--ͨ���������ݿ��ɫ
create role XiaoShou;
create role CaiGou;
create role ShenHe;
create role GuanLi;

--�����ɫȨ��
--���ۣ��ֿ����ѯ����������ALL��ȱ������ѯ���������ѯ��
grant select on STORAGE to XiaoShou;
grant ALL on DELIVER to XiaoShou;
grant select on STOCKOUT to XiaoShou;
grant select on COMMODITY to XiaoShou;

--�ɹ����ֿ����ѯ����������ALL��ȱ������ѯ���������ѯ��
grant select on STORAGE to CaiGou;
grant ALL on STOCK to CaiGou;
grant select on STOCKOUT to CaiGou;
grant select on COMMODITY to CaiGou;

--��ˣ��ֿ����ѯ������������ѯ�����£�����������ѯ�����£�ȱ������ѯ���������ѯ
grant select on STORAGE to ShenHe;
grant select on STOCK to ShenHe;
grant update on STOCK to ShenHe;
grant select on DELIVER to ShenHe;
grant update on DELIVER to ShenHe;
grant select on STOCKOUT to ShenHe;
grant select on COMMODITY to ShenHe;

--�����ֿ����ѯ������������ѯ��ɾ��������������ѯ��ɾ����ȱ����ALL�������ALL
grant select on STORAGE to GuanLi;
grant select on STOCK to GuanLi;
grant delete on STOCK to GuanLi;
grant select on DELIVER to GuanLi;
grant delete on DELIVER to GuanLi;
grant ALL on STOCKOUT to GuanLi;
grant ALL on COMMODITY to GuanLi;

--�������ݿ��û�Ȩ��
exec sp_addrolemember 'XiaoShou', 'Xiao'
exec sp_addrolemember 'CaiGou', 'Cai'
exec sp_addrolemember 'ShenHe', 'Shen'
exec sp_addrolemember 'GuanLi', 'Guan'

--��������
--�ֿ���������
INSERT INTO STORAGE(STID,STNAME,STADRESS) VALUES('10371','�ֿ�1','��ɽ������·1037��');
INSERT INTO STORAGE(STID,STNAME,STADRESS) VALUES('10372','�ֿ�2','��ɽ������·1037��');
INSERT INTO STORAGE(STID,STNAME,STADRESS) VALUES('10373','�ֿ�3','��ɽ������·1037��');
select * from STORAGE

--ְԱ���������
INSERT INTO EMPLOYEE(EID,ENAME,SEX,AGE,POSITION) VALUES('2019060001','Ф��','��',30,'����');
INSERT INTO EMPLOYEE(EID,ENAME,SEX,AGE,POSITION) VALUES('2019060002','�̹�','��',30,'�ɹ�');
INSERT INTO EMPLOYEE(EID,ENAME,SEX,AGE,POSITION) VALUES('2019060003','���','Ů',30,'���');
INSERT INTO EMPLOYEE(EID,ENAME,SEX,AGE,POSITION) VALUES('2019060004','����','Ů',30,'����');

--�û����������
INSERT INTO DB_USER(DB_USER_NAME,DB_PASSWORD,PERMISSION) VALUES('2019060001','147258','Xiao');
INSERT INTO DB_USER(DB_USER_NAME,DB_PASSWORD,PERMISSION) VALUES('2019060002','147258','CaiG');
INSERT INTO DB_USER(DB_USER_NAME,DB_PASSWORD,PERMISSION) VALUES('2019060003','147258','Shen');
INSERT INTO DB_USER(DB_USER_NAME,DB_PASSWORD,PERMISSION) VALUES('2019060004','147258','Guan');

--������������
INSERT INTO COMMODITY(CID, CNAME, STID,STORE,MANUFACTURER) VALUES('6928804010527','�ɿڿ���','10371',50,'����̫�ſɿڿ����������޹�˾');
INSERT INTO COMMODITY(CID, CNAME, STID,STORE,MANUFACTURER) VALUES('6902083887070','������Ȫˮ','10371',100,'�人�޹�������������޹�˾');
INSERT INTO COMMODITY(CID, CNAME, STID,STORE,MANUFACTURER) VALUES('6920734706303','��ʦ�����ͱ���ţ����','10372',200,'��ɳ������ʳƷ���޹�˾');
INSERT INTO COMMODITY(CID, CNAME, STID,STORE,MANUFACTURER) VALUES('6901668004574','�������ɿ˰���������','10372',500,'����ʳƷ(����)���޹�˾');
INSERT INTO COMMODITY(CID, CNAME, STID,STORE,MANUFACTURER) VALUES('9787513307338','���������˹���һ���ط�','10373',100,'���ǳ�����');
INSERT INTO COMMODITY(CID, CNAME, STID,STORE,MANUFACTURER) VALUES('9787542662620','�ʲ�','10373',50,'�Ϻ��������');
INSERT INTO COMMODITY(CID, CNAME, STID,STORE,MANUFACTURER) VALUES('9787201072326','�չ�����','10373',200,'������������');
INSERT INTO COMMODITY(CID, CNAME, STID,STORE,MANUFACTURER) VALUES('9787531326953','�ܻ�','10373',500,'�������ճ�����');
select * from COMMODITY