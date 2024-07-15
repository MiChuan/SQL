CREATE DATABASE WarehouseManagement;
USE WarehouseManagement;

--仓库【仓库编号，仓库名称，仓库地址】
--STORAGE(STID CHAR(4),STNAME CHAR(20),STADRESS CHAR(200));
--主码为仓库编号
CREATE TABLE STORAGE(
STID CHAR(5) PRIMARY KEY,
STNAME VARCHAR(20) NOT NULL,
STADRESS VARCHAR(200)
);

--货品表【货品号、货品名、仓库编号、货品库存量、生产厂家】
--COMMODITY(CID CHAR(13), CNAME CHAR(50), STID CHAR(4),STORE INT,MANUFACTURER CHAR(50));
--主码为货品号，外码为仓库编号，货品库存大于等于0
CREATE TABLE COMMODITY(
CID CHAR(13) PRIMARY KEY, 
CNAME VARCHAR(50) NOT NULL, 
STID CHAR(5),
STORE INT CHECK(STORE>=0),
MANUFACTURER VARCHAR(50),
FOREIGN KEY(STID) REFERENCES STORAGE(STID)
);

--进货单表【进货单号、货品号、仓库编号、进货数量、进货时间、进货厂家、审核意见】
--STOCK(SID CHAR(10), CID CHAR(13), STID CHAR(4)，SNUM INT,STIME CHAR(11),MANUFACTURER CHAR(50),CHECKRESULT CHAR(1));
--主码为进货单号，外码为货品号、仓库编号,审核意见为“Y”或“N”
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

--出货单表【出货单号、货品号、仓库编号、出货数量、出货时间、审核意见】
--DELIVER(DID CHAR(10),CID CHAR(13),STID CHAR(4)，DNUM INT,DTIME CHAR(11),CHECKRESULT CHAR(1));
--主码为出货单号，外码为货品号、仓库编号，审核意见为“Y”或“N”
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

--缺货登记表【缺货单号、出货单号、货品号、仓库编号、登记时间、缺货量】
--STOCKOUT(SOID CHAR(10),DID CHAR(10),CID CHAR(13),STID CHAR(4)，SOTIME CHAR(11),SONUM INT);
--主码为缺货单号，外码为出货单号、货品号、仓库编号
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

--职工表【工号、姓名、性别、年龄、职位】
--EMPLOYEE(EID CHAR(10),ENAME CHAR(10),SEX CHAR(2),AGE INT,POSITION CHAR(10));
--主码为工号，新增四类角色并配置权限：销售、采购、审核、管理
CREATE TABLE EMPLOYEE(
EID CHAR(10) PRIMARY KEY,
ENAME CHAR(10) NOT NULL,
SEX CHAR(2),
AGE INT,
POSITION CHAR(10)
);

--用户表【用户名、密码、权限】
--主码为用户名，外码为用户名（职员表工号），权限分为四类：管理(GuanLi)、销售(XiaoShou)、采购(CaiGou)、审核(ShenHe)
CREATE TABLE DB_USER(
DB_USER_NAME CHAR(10)PRIMARY KEY,
DB_PASSWORD CHAR(6),
PERMISSION CHAR(4),
FOREIGN KEY(DB_USER_NAME) REFERENCES EMPLOYEE(EID)
);

--创建登陆帐户（create login）
--登陆帐户名为：“Xiao”,登陆密码：123456”,默认连接到的数据库：“WarehouseManagement”。
--登陆帐户名为：“Cai”,登陆密码：123456”,默认连接到的数据库：“WarehouseManagement”。
--登陆帐户名为：“Shen”,登陆密码：123456”,默认连接到的数据库：“WarehouseManagement”。
--登陆帐户名为：“Guan”,登陆密码：123456”,默认连接到的数据库：“WarehouseManagement”。
create login Xiao with password='123456', default_database = WarehouseManagement;
create login Cai with password='123456', default_database = WarehouseManagement;
create login Shen with password='123456', default_database = WarehouseManagement;
create login Guan with password='123456', default_database = WarehouseManagement;

--为登陆账户创建数据库用户（create user）,在Movie数据库中的security中的user下可以找到
--并指定数据库用户的默认 schema 是“dbo”
create user Xiao for login Xiao with default_schema = dbo;
create user Cai for login Cai with default_schema = dbo;
create user Shen for login Shen with default_schema = dbo;
create user Guan for login Guan with default_schema = dbo;

--通过加入数据库角色
create role XiaoShou;
create role CaiGou;
create role ShenHe;
create role GuanLi;

--赋予角色权限
--销售：仓库表：查询；出货单：ALL；缺货表：查询；货物表：查询；
grant select on STORAGE to XiaoShou;
grant ALL on DELIVER to XiaoShou;
grant select on STOCKOUT to XiaoShou;
grant select on COMMODITY to XiaoShou;

--采购：仓库表：查询；进货单：ALL；缺货表：查询；货物表：查询；
grant select on STORAGE to CaiGou;
grant ALL on STOCK to CaiGou;
grant select on STOCKOUT to CaiGou;
grant select on COMMODITY to CaiGou;

--审核：仓库表：查询；进货单：查询、更新；出货单：查询、更新；缺货表：查询；货物表：查询
grant select on STORAGE to ShenHe;
grant select on STOCK to ShenHe;
grant update on STOCK to ShenHe;
grant select on DELIVER to ShenHe;
grant update on DELIVER to ShenHe;
grant select on STOCKOUT to ShenHe;
grant select on COMMODITY to ShenHe;

--管理：仓库表：查询；进货单：查询、删除；出货单：查询、删除；缺货表：ALL；货物表：ALL
grant select on STORAGE to GuanLi;
grant select on STOCK to GuanLi;
grant delete on STOCK to GuanLi;
grant select on DELIVER to GuanLi;
grant delete on DELIVER to GuanLi;
grant ALL on STOCKOUT to GuanLi;
grant ALL on COMMODITY to GuanLi;

--赋予数据库用户权限
exec sp_addrolemember 'XiaoShou', 'Xiao'
exec sp_addrolemember 'CaiGou', 'Cai'
exec sp_addrolemember 'ShenHe', 'Shen'
exec sp_addrolemember 'GuanLi', 'Guan'

--插入数据
--仓库表插入数据
INSERT INTO STORAGE(STID,STNAME,STADRESS) VALUES('10371','仓库1','洪山区珞喻路1037号');
INSERT INTO STORAGE(STID,STNAME,STADRESS) VALUES('10372','仓库2','洪山区珞喻路1037号');
INSERT INTO STORAGE(STID,STNAME,STADRESS) VALUES('10373','仓库3','洪山区珞喻路1037号');
select * from STORAGE

--职员表插入数据
INSERT INTO EMPLOYEE(EID,ENAME,SEX,AGE,POSITION) VALUES('2019060001','肖授','男',30,'销售');
INSERT INTO EMPLOYEE(EID,ENAME,SEX,AGE,POSITION) VALUES('2019060002','蔡构','男',30,'采购');
INSERT INTO EMPLOYEE(EID,ENAME,SEX,AGE,POSITION) VALUES('2019060003','沈河','女',30,'审核');
INSERT INTO EMPLOYEE(EID,ENAME,SEX,AGE,POSITION) VALUES('2019060004','关丽','女',30,'管理');

--用户表插入数据
INSERT INTO DB_USER(DB_USER_NAME,DB_PASSWORD,PERMISSION) VALUES('2019060001','147258','Xiao');
INSERT INTO DB_USER(DB_USER_NAME,DB_PASSWORD,PERMISSION) VALUES('2019060002','147258','CaiG');
INSERT INTO DB_USER(DB_USER_NAME,DB_PASSWORD,PERMISSION) VALUES('2019060003','147258','Shen');
INSERT INTO DB_USER(DB_USER_NAME,DB_PASSWORD,PERMISSION) VALUES('2019060004','147258','Guan');

--货物表插入数据
INSERT INTO COMMODITY(CID, CNAME, STID,STORE,MANUFACTURER) VALUES('6928804010527','可口可乐','10371',50,'湖北太古可口可乐饮料有限公司');
INSERT INTO COMMODITY(CID, CNAME, STID,STORE,MANUFACTURER) VALUES('6902083887070','氧道矿泉水','10371',100,'武汉娃哈哈恒枫饮料有限公司');
INSERT INTO COMMODITY(CID, CNAME, STID,STORE,MANUFACTURER) VALUES('6920734706303','康师傅红油爆椒牛肉面','10372',200,'长沙福满多食品有限公司');
INSERT INTO COMMODITY(CID, CNAME, STID,STORE,MANUFACTURER) VALUES('6901668004574','奥利奥巧克棒威化饼干','10372',500,'亿滋食品(北京)有限公司');
INSERT INTO COMMODITY(CID, CNAME, STID,STORE,MANUFACTURER) VALUES('9787513307338','我是你流浪过的一个地方','10373',100,'新星出版社');
INSERT INTO COMMODITY(CID, CNAME, STID,STORE,MANUFACTURER) VALUES('9787542662620','潦草','10373',50,'上海三联书店');
INSERT INTO COMMODITY(CID, CNAME, STID,STORE,MANUFACTURER) VALUES('9787201072326','日光流年','10373',200,'天津人民出版社');
INSERT INTO COMMODITY(CID, CNAME, STID,STORE,MANUFACTURER) VALUES('9787531326953','受活','10373',500,'春风文艺出版社');
select * from COMMODITY