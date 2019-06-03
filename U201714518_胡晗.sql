--1 软件功能学习部分（各教师可适当调整）

--    完成下列1~2题,并在实践报告中叙述过程,可适当辅以插图（控制在A4三页篇幅以内）
--1）练习sqlserver的两种完全备份方式：数据和日志文件的脱机备份、系统的备份功能。

--脱机备份：
--①选中需要备份的数据库后,选中“任务”->“脱机”
--②进入数据库所在文件夹,选中要备份的数据库和日志文件（.mdf和.ldf）
--③复制文件到目标文件夹进行保存,完成备份

--系统的备份：
--①在对象资源管理器选中需要备份的数据库,选中“任务”->“备份”
--②在备份菜单中选中备份方式为“完整”,选择保存路径,输入备份文件名
--③点击确定,完成备份

--2）练习在新增的数据库上增加用户并配置权限的操作。

--创建登陆帐户（create login）
--登陆帐户名为：“test”,登陆密码：123456”,默认连接到的数据库：“Movie”。
create login test with password='123456', default_database=Movie

--为登陆账户创建数据库用户（create user）,在Movie数据库中的security中的user下可以找到新创建的test
--并指定数据库用户“tset” 的默认 schema 是“dbo”
create user test for login test with default_schema=dbo

--通过加入数据库角色,赋予数据库用户“db_owner”权限
exec sp_addrolemember 'db_owner', 'test'

--删除数据库用户：
drop user test

--删除 SQL Server登陆帐户：
drop login test

--2 Sql练习部分（各教师每年可适当调整）

--2.1 建表
--1）创建下列跟电影相关的关系,包括主码和外码的说明

--新建数据库Movie
CREATE DATABASE Movie

--电影表【电影编号,电影名称,电影类型,导演姓名,电影时长（以分钟计）,是否3D,用户评分】
--FILM(FID int, FNAME char(30), FTYPE char(40), DNAME char(30), length int, IS3D char(1),GRADE int)。
--主码为电影编号,IS3D取值为’Y’表示是3D电影,’N’表示不是,用户评分规定为0~100分之间或者为空值。
CREATE TABLE FILM(
FID INT NOT NULL PRIMARY KEY,
FNAME CHAR(30) NOT NULL,
FTYPE CHAR(40) NOT NULL,
DNAME CHAR(30) NOT NULL,
FLENGTH INT,
IS3D CHAR(1),
GRADE INT CHECK(GRADE>=0 AND GRADE <= 100)
);

--演员表【演员编号,演员姓名,性别,出生年份】
--ACTOR(ACTID int, ANAME char(30), SEX char(2), BYEAR int)
--主码为演员编号
CREATE TABLE ACTOR(
ACTID INT NOT NULL PRIMARY KEY,
ANAME CHAR(30) NOT NULL,
SEX CHAR(2),
BYEAR INT
);

--参演表【演员编号,电影编号,是否主角,用户对该演员在该电影中的评分】
--ACTIN(ACTID int, FID int, ISLEADING char(1), GRADE int)
--主码、外码请依据应用背景合理定义。ISLEADING取值为’Y’表示是,’N’表示不是主角,也可能取空值,表示不太确定该演员在该电影中是否主角。GRADE规定为0~100分之间或者为空值。
CREATE TABLE ACTIN(
ACTID int NOT NULL, 
FID int NOT NULL, 
ISLEADING char(1), 
GRADE int,
PRIMARY KEY(ACTID,FID),
FOREIGN KEY(FID)REFERENCES FILM(FID),
FOREIGN KEY(ACTID)REFERENCES ACTOR(ACTID)
);

--电影院表【电影院编号,电影院名字,影院所在行政区,影院地址】
--THEATER (TID int, TNAME char(100), TAREA char(20), ADDRESS char(200))
--主码为电影院编号,影院所在行政区取值如“洪山区”、“武昌区”等等。
CREATE TABLE THEATER(
TID int NOT NULL PRIMARY KEY, 
TNAME char(100), 
TAREA char(20), 
ADDRESS char(200)
);

--上映表【电影编号,影院编号,上映年份,上映月份】
--SHOW(FID int, TID int , PRICE int, YEAR int , MONTH int)
--假定一部电影在一家影院只上映一次,主码、外码请依据应用背景合理定义。
CREATE TABLE SHOW(
FID int, 
TID int , 
PRICE int, 
YEAR int , 
MONTH int
PRIMARY KEY(TID,FID),
FOREIGN KEY(FID)REFERENCES FILM(FID),
FOREIGN KEY(TID)REFERENCES THEATER(TID)
);

--2）观察性实验
--验证在建立外码时是否一定要参考被参照关系的主码,并在实验报告中简述过程和结果。
--创建一个测试表TEST,主码TestID参照表FILM的主码FID,电影名FNAME参照表FILM的FNAME（非主码）
--执行报错:在被引用表 'FILM' 中没有与外键 'FK__TEST__FNAME__4AB81AF0' 中的引用列列表匹配的主键或候选键。
CREATE TABLE TEST(
TestID int PRIMARY KEY,
FNAME CHAR(30),
FOREIGN KEY(TestID)REFERENCES FILM(FID),
FOREIGN KEY(FNAME)REFERENCES FILM(FNAME)
);

--3）数据准备
--依据后续实验的要求,向上述表格中录入适当数量的实验数据,从而对相关的实验任务能够起到验证的作用。
insert into FILM(FID,FNAME,FTYPE,DNAME,FLENGTH,IS3D,GRADE) values (1,'红海行动','动作/剧情','林超贤',138,'Y',92);
insert into FILM(FID,FNAME,FTYPE,DNAME,FLENGTH,IS3D,GRADE) values (2,'无问西东','剧情/爱情/战争','李芳芳',138,'N',71);
insert into FILM(FID,FNAME,FTYPE,DNAME,FLENGTH,IS3D,GRADE) values (3,'捉妖记2','喜剧/奇幻/动作','许诚毅',110,'N',59);
insert into FILM(FID,FNAME,FTYPE,DNAME,FLENGTH,IS3D,GRADE) values (4,'捉妖记','喜剧/奇幻/动作','许诚毅',118,'Y',72);
insert into FILM(FID,FNAME,FTYPE,DNAME,FLENGTH,IS3D,GRADE) values (5,'唐人街探案2','喜剧/动作/悬疑','陈思诚',120,'N',71);
insert into FILM(FID,FNAME,FTYPE,DNAME,FLENGTH,IS3D,GRADE) values (6,'美人鱼','喜剧/奇幻/爱情','周星驰',93,'Y',74);
insert into FILM(FID,FNAME,FTYPE,DNAME,FLENGTH,IS3D,GRADE) values (7,'风暴','动作/犯罪/剧情','袁锦麟',109,'N',66);
insert into FILM(FID,FNAME,FTYPE,DNAME,FLENGTH,IS3D,GRADE) values (8,'太平轮（上）','爱情/剧情/战争','吴宇森',128,'N',58);
insert into FILM(FID,FNAME,FTYPE,DNAME,FLENGTH,IS3D,GRADE) values (9,'太平轮·彼岸','爱情/剧情/战争','吴宇森',126,'N',62);
insert into FILM(FID,FNAME,FTYPE,DNAME,FLENGTH,IS3D,GRADE) values (10,'战狼','动作/战争','吴京',90,'N',82);
insert into FILM(FID,FNAME,FTYPE,DNAME,FLENGTH,IS3D,GRADE) values (11,'战狼2','动作/战争','吴京',123,'Y',92);
insert into FILM(FID,FNAME,FTYPE,DNAME,FLENGTH,IS3D,GRADE) values (12,'疯狂的石头','犯罪/喜剧','宁浩',98,'N',91);
insert into FILM(FID,FNAME,FTYPE,DNAME,FLENGTH,IS3D,GRADE) values (13,'追捕','动作/剧情','吴宇森',106,'N',65);
insert into FILM(FID,FNAME,FTYPE,DNAME,FLENGTH,IS3D,GRADE) values (14,'幸福马上来','喜剧','冯巩',100,'N',66);
insert into ACTOR(ACTID,ANAME,SEX,BYEAR) values (1,'张译','男',1978);
insert into ACTOR(ACTID,ANAME,SEX,BYEAR) values (2,'黄景瑜','男',1992);
insert into ACTOR(ACTID,ANAME,SEX,BYEAR) values (3,'海清','女',1978);
insert into ACTOR(ACTID,ANAME,SEX,BYEAR) values (4,'杜江','男',1985);
insert into ACTOR(ACTID,ANAME,SEX,BYEAR) values (5,'章子怡','女',1979);
insert into ACTOR(ACTID,ANAME,SEX,BYEAR) values (6,'张震','男',1976);
insert into ACTOR(ACTID,ANAME,SEX,BYEAR) values (7,'黄晓明','男',1977);
insert into ACTOR(ACTID,ANAME,SEX,BYEAR) values (8,'王力宏','男',1976);
insert into ACTOR(ACTID,ANAME,SEX,BYEAR) values (9,'梁朝伟','男',1962);
insert into ACTOR(ACTID,ANAME,SEX,BYEAR) values (10,'白百何','女',1984);
insert into ACTOR(ACTID,ANAME,SEX,BYEAR) values (11,'井柏然','男',1989);
insert into ACTOR(ACTID,ANAME,SEX,BYEAR) values (12,'曾志伟','男',1953);
insert into ACTOR(ACTID,ANAME,SEX,BYEAR) values (13,'柳岩','女',1980);
insert into ACTOR(ACTID,ANAME,SEX,BYEAR) values (14,'吴君如','女',1965);
insert into ACTOR(ACTID,ANAME,SEX,BYEAR) values (15,'刘德华','男',1961);
insert into ACTOR(ACTID,ANAME,SEX,BYEAR) values (16,'姚晨','女',1979);
insert into ACTOR(ACTID,ANAME,SEX,BYEAR) values (17,'宋慧乔','女',1982);
insert into ACTOR(ACTID,ANAME,SEX,BYEAR) values (18,'金城武','男',1973);
insert into ACTOR(ACTID,ANAME,SEX,BYEAR) values (19,'吴京','男',1974);
insert into ACTOR(ACTID,ANAME,SEX,BYEAR) values (20,'卢靖姗','女',1985);
insert into ACTOR(ACTID,ANAME,SEX,BYEAR) values (21,'余男','女',1978);
insert into ACTOR(ACTID,ANAME,SEX,BYEAR) values (22,'李自己','男',1998);
insert into ACTOR(ACTID,ANAME,SEX,BYEAR) values (23,'吴磊','男',1999);
insert into ACTOR(ACTID,ANAME,SEX,BYEAR) values (24,'张雪迎','男',1997);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (1,1,'Y',81);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (2,1,'Y',72);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (3,1,'Y',84);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (4,1,'Y',64);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (5,1,'Y',67);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (6,2,'Y',84);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (7,2,'Y',49);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (8,2,'Y',88);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (9,3,'Y',92);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (10,3,'Y',73);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (10,4,'Y',73);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (11,3,'Y',67);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (11,4,'Y',67);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (12,3,'Y',80);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (12,4,'Y',80);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (13,3,'Y',62);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (14,3,'Y',83);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (14,4,'Y',83);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (15,7,'Y',91);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (16,7,'Y',78);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (17,8,'Y',90);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (17,9,'Y',90);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (18,8,'Y',85);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (18,9,'Y',85);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (19,8,'Y',92);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (19,9,'Y',92);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (20,10,'Y',78);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (20,11,'Y',70);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (21,11,'Y',85);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (22,8,'Y',75);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (22,9,'Y',75);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (22,10,'Y',75);
insert into ACTIN(ACTID,FID,ISLEADING,GRADE) values (22,13,'Y',75);
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values (1,'金逸国际影城南湖店','洪山区','武昌区丁字桥南路518号南国南湖城市广场3楼');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values (2,'洪山天河影城','洪山区','湖北省洪山区珞瑜路6号');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(3,'光谷正华银兴影城','洪山区','洪山区民族大道158号光谷时间广场3楼');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(4,'华谊兄弟光谷天地影院','洪山区','洪山区关山大道光谷天地F1区三楼');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(5,'巨幕影城光谷广场资本大厦店','洪山区','洪山区光谷广场光谷资本大厦四楼');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(6,'CGV星聚汇影院光谷店','洪山区','东湖新技术开发区光谷步行街4期德国风情街8号楼3F');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(7,'华夏国际影城鲁广店','洪山区','东湖高新技术开发区珞喻路 726 号');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(8,'CGV国际影城','洪山区','湖北青山区和平大道809号奥山世纪广场3楼');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(9,'天河欢乐汇影城','洪山区','书城路18号欢乐汇大楼5层');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(10,'银兴菲林佰港城店','洪山区','北港村文治街武昌府维佳佰港城广场四楼');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(11,'幸福蓝海国际影城雄楚店','洪山区','雄楚大道888号金地中心城雄楚一号4楼');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(12,'耀莱成龙国际影城','洪山区','珞喻路889号融众国际大厦6-7层');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(13,'万达影城春树里店','武昌区','武昌区中北路166号岳家嘴东湖春树里购物中心四层');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(14,'洪山礼堂','武昌区','武昌区洪山路81号');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(15,'洪山礼堂银兴电影城','武昌区','水果湖洪山路81号洪山礼堂');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(16,'金逸国际影城店','武昌区','湖北省武昌徐东大街18号销品茂5楼');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(17,'湖北剧院银兴影城','武昌区','武昌区阅马场湖北剧院一楼、四楼');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(18,'江汉环球电影城','武昌区','武昌区司门口解放路464号原江汉剧场户部巷对面');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(19,'亚贸兴汇影城','武昌区','武昌区武珞路628号亚贸广场购物中心6楼');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(20,'横店影视电影城武昌店','武昌区','张之洞路南国首义汇广场南三楼');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(21,'金逸国际影城中南店','武昌区','武昌区武昌武珞路442号');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(22,'银兴菲林影城福克茂店','武昌区','湖北武昌区友谊大道团结村路福客茂五楼');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(23,'银兴菲林国际影城群星城店','武昌区','徐东大街120号群星城五楼');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(24,'星美国际影城漫时区店','武昌区','友谊大道福星惠誉漫时区3栋3楼星美国际影城');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(25,'卢米埃凯德181影城','武昌区','武昌区中北路23号凯德广场1818中心七楼');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(26,'华夏国际影城后湖百步亭店','江岸区','江岸区后湖大道268号新生活摩尔城3楼');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(27,'中影国际影城东购店','江岸区','江岸区二七路汉口东部购物公园C2栋4楼');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(28,'CGV星星国际影城','江岸区','江岸区芦沟桥路28号 天地11号楼');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(29,'奥斯卡上东汇影城','江岸区','湖北武昌区江岸区黄浦路68号,上东汇广场6楼,161医院旁');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(30,'城市广场摩尔国际电影城','江岸区','后湖大道111号汉口城市广场A座3楼');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(31,'银兴乐天电影城','江汉区','江汉区万松园路100号西园步行街三楼');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(32,'武商摩尔国际电影城','江汉区','江汉区解放大道690号7、8楼');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(33,'万达影城菱角湖店','江汉区','江汉区新华西路唐家墩5号,菱角湖万达广场娱乐楼四层');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(34,'万达国际电影城','江汉区','江汉区交通路1号万达商业广场C座二层');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(35,'环艺电影城','江汉区','中山大道608号新民众乐园4楼');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(36,'金逸国际影城杨汊湖店','江汉区','江汉区姑嫂树路12号,南国北都城市广场3F');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(37,'泛海国际影城','江汉区','云彩路198号泛海城市购物中心五层');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(38,'银兴乐天影城江夏店','江夏区','江夏大道128号附1号中央大街2号楼4层');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(39,'大地数字影院宜家','江夏区','江夏区兴新街宜佳广场四楼');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(40,'大地影院江夏店','江夏区','江夏区兴新街136号宜佳广场四楼东侧');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(41,'高德国际影城','江夏区','文华路37号中百广场6楼');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(42,'金逸国际影城武胜路店','硚口区','兰州市安宁区安宁西路3号康桥国际购物中心5层');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(43,'橙天嘉禾南国西汇影城','硚口区','解放大道387号汉口宗关水厂南国西汇城市广场二期5楼');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(44,'金逸IMAX荟聚店','硚口区','长宜路1号荟聚购物中心4层金逸影城');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(45,'武商众圆摩尔国际电影城','青山区','和平大道959号武商众圆广场4—5楼');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(46,'金逸国际影城王家湾店','汉阳区','汉阳区王家湾龙阳大道特6号摩尔城C区5楼');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(47,'汉阳天河国际影城','汉阳区','汉阳大道687号,汉商21购物娱乐中心三楼');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(48,'大地影院-汉阳新世界','汉阳区','汉阳区鹦鹉大道27号新世界百货5楼');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(49,'百老汇影院','汉阳区','龙阳大道58号汉阳人信汇商业中心A座4层');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(50,'金逸国际影城吴家山北冰洋店','东西湖区','吴家山四明路北冰洋城市广场4楼');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(51,'CGV星聚汇影城金银潭店','东西湖区','将军路街道办事处金银潭大道1号永旺梦乐城三层');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(52,'横店电影城汇和店','东西湖区','东西湖区花园中路轨道交通2号线常青花园地铁站汇和城购物中心五楼');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(53,'大地数字影院湘隆时代广场','蔡甸区','沌口经济技术开发区宁康路湘隆时代广场B1栋5楼');
insert into THEATER(TID,TNAME,TAREA,ADDRESS) values(54,'华谊兄弟黄陂影城','黄陂区','黄陂区黄陂大道387号黄陂广场C座');
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 1, 50, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 1, 80, 2018, 1)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 1, 40, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 1, 70, 2015, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 1, 60, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 1, 50, 2016, 1)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 1, 60, 2013, 12)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 1, 70, 2014, 12)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 1, 80, 2015, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 1, 30, 2015, 4)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 1, 70, 2017, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 1, 40, 2006, 6)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 2, 40, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 2, 60, 2018, 1)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 2, 60, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 2, 40, 2015, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 2, 70, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 2, 40, 2016, 1)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 2, 40, 2013, 12)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 2, 60, 2014, 12)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 2, 70, 2015, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 2, 70, 2015, 4)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 2, 80, 2017, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 2, 60, 2006, 6)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 3, 30, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 3, 50, 2018, 1)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 3, 70, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 3, 50, 2015, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 3, 50, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 3, 40, 2016, 1)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 3, 40, 2013, 12)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 3, 70, 2014, 12)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 3, 50, 2015, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 3, 40, 2015, 4)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 3, 40, 2017, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 3, 60, 2006, 6)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 4, 50, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 4, 50, 2018, 1)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 4, 60, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 4, 70, 2015, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 4, 40, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 4, 60, 2016, 1)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 4, 70, 2013, 12)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 4, 50, 2014, 12)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 4, 30, 2015, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 4, 60, 2015, 4)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 4, 60, 2017, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 4, 70, 2006, 6)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 5, 70, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 5, 70, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 5, 60, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 5, 50, 2015, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 5, 70, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 5, 80, 2016, 1)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 5, 60, 2013, 12)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 5, 70, 2014, 12)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 5, 60, 2015, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 5, 80, 2015, 4)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 5, 80, 2017, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 5, 40, 2006, 6)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 6, 80, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 6, 70, 2018, 1)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 6, 60, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 6, 70, 2015, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 6, 70, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 6, 40, 2016, 1)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 6, 70, 2013, 12)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 6, 30, 2014, 12)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 6, 80, 2015, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 6, 50, 2015, 4)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 6, 80, 2017, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 6, 70, 2006, 6)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 7, 80, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 7, 40, 2018, 1)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 7, 60, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 7, 70, 2015, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 7, 70, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 7, 40, 2016, 1)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 7, 50, 2013, 12)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 7, 40, 2014, 12)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 7, 30, 2015, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 7, 40, 2015, 4)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 7, 40, 2017, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 7, 50, 2006, 6)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 8, 70, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 8, 30, 2018, 1)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 8, 30, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 8, 60, 2015, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 8, 70, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 8, 70, 2016, 1)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 8, 70, 2013, 1)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 8, 60, 2014, 12)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 8, 30, 2015, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 8, 40, 2015, 4)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 8, 50, 2017, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 8, 40, 2006, 6)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 9, 60, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 9, 60, 2018, 1)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 9, 40, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 9, 50, 2015, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 9, 60, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 9, 70, 2016, 1)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 9, 70, 2013, 12)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 9, 30, 2014, 12)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 9, 40, 2015, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 9, 60, 2015, 4)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 9, 70, 2017, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 9, 30, 2006, 6)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 10, 80, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 10, 30, 2018, 1)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 10, 40, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 10, 50, 2015, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 10, 70, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 10, 40, 2016, 1)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 10, 50, 2013, 12)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 10, 70, 2014, 12)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 10, 60, 2015, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 10, 60, 2015, 4)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 10, 30, 2017, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 10, 50, 2006, 6)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 11, 60, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 11, 40, 2018, 1)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 11, 40, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 11, 60, 2015, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 11, 60, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 11, 80, 2016, 1)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 11, 70, 2013, 12)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 11, 60, 2014, 12)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 11, 40, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 11, 40, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 11, 40, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 11, 60, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 12, 70, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 12, 70, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 12, 50, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 12, 50, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 12, 50, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 12, 40, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 12, 40, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 12, 60, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 12, 30, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 12, 80, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 12, 70, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 12, 50, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 13, 30, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 13, 50, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 13, 50, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 13, 80, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 13, 60, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 13, 40, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 13, 70, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 13, 70, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 13, 40, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 13, 40, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 13, 80, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 13, 60, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 14, 30, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 14, 70, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 14, 50, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 14, 40, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 14, 70, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 14, 70, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 14, 40, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 14, 80, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 14, 50, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 14, 30, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 14, 30, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 14, 40, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 15, 50, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 15, 60, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 15, 50, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 15, 60, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 15, 70, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 15, 50, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 15, 40, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 15, 70, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 15, 70, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 15, 40, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 15, 70, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 15, 30, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 16, 60, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 16, 70, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 16, 80, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 16, 70, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 16, 60, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 16, 60, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 16, 80, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 16, 60, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 16, 70, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 16, 80, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 16, 50, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 16, 40, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 17, 80, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 17, 30, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 17, 40, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 17, 60, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 17, 50, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 17, 30, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 17, 40, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 17, 30, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 17, 40, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 17, 60, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 17, 50, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 17, 70, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 18, 80, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 18, 80, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 18, 70, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 18, 60, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 18, 60, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 18, 30, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 18, 60, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 18, 80, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 18, 80, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 18, 70, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 18, 40, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 18, 80, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 19, 30, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 19, 50, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 19, 70, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 19, 40, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 19, 80, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 19, 70, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 19, 60, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 19, 70, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 19, 40, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 19, 50, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 19, 30, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 19, 80, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 20, 50, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 20, 70, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 20, 60, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 20, 40, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 20, 80, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 20, 30, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 20, 80, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 20, 60, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 20, 50, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 20, 60, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 20, 60, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 20, 40, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 21, 70, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 21, 60, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 21, 30, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 21, 70, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 21, 60, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 21, 70, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 21, 80, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 21, 30, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 21, 30, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 21, 80, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 21, 50, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 21, 70, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 22, 50, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 22, 30, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 22, 30, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 22, 70, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 22, 80, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 22, 40, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 22, 70, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 22, 70, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 22, 80, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 22, 50, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 22, 80, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 22, 80, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 23, 60, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 23, 40, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 23, 80, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 23, 50, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 23, 60, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 23, 40, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 23, 80, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 23, 80, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 23, 50, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 23, 30, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 23, 70, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 23, 30, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 24, 50, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 24, 70, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 24, 40, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 24, 40, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 24, 50, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 24, 60, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 24, 60, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 24, 40, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 24, 50, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 24, 30, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 24, 40, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 24, 80, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 25, 60, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 25, 70, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 25, 40, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 25, 70, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 25, 50, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 25, 40, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 25, 80, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 25, 70, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 25, 70, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 25, 40, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 25, 50, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 25, 40, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 26, 40, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 26, 80, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 26, 40, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 26, 60, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 26, 70, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 26, 40, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 26, 50, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 26, 70, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 26, 30, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 26, 70, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 26, 30, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 26, 50, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 27, 50, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 27, 50, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 27, 40, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 27, 70, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 27, 50, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 27, 80, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 27, 50, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 27, 30, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 27, 40, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 27, 50, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 27, 50, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 27, 50, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 28, 40, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 28, 80, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 28, 70, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 28, 40, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 28, 30, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 28, 50, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 28, 70, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 28, 70, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 28, 40, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 28, 40, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 28, 50, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 28, 80, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 29, 40, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 29, 80, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 29, 40, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 29, 50, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 29, 40, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 29, 50, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 29, 60, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 29, 50, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 29, 70, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 29, 40, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 29, 50, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 29, 70, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 30, 70, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 30, 60, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 30, 60, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 30, 80, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 30, 70, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 30, 50, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 30, 40, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 30, 50, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 30, 30, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 30, 30, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 30, 30, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 30, 50, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 31, 60, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 31, 80, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 31, 80, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 31, 40, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 31, 70, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 31, 30, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 31, 50, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 31, 40, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 31, 50, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 31, 70, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 31, 60, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 31, 70, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 32, 60, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 32, 30, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 32, 50, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 32, 50, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 32, 70, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 32, 80, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 32, 50, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 32, 40, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 32, 40, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 32, 50, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 32, 60, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 32, 60, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 33, 30, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 33, 60, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 33, 70, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 33, 70, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 33, 50, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 33, 40, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 33, 30, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 33, 50, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 33, 30, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 33, 50, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 33, 60, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 33, 30, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 34, 70, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 34, 70, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 34, 50, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 34, 50, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 34, 50, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 34, 50, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 34, 70, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 34, 40, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 34, 60, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 34, 50, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 34, 30, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 34, 60, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 35, 60, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 35, 40, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 35, 30, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 35, 30, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 35, 70, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 35, 70, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 35, 70, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 35, 60, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 35, 50, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 35, 70, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 35, 40, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 35, 40, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 36, 30, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 36, 40, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 36, 40, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 36, 30, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 36, 40, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 36, 50, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 36, 80, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 36, 40, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 36, 50, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 36, 60, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 36, 60, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 36, 60, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 37, 50, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 37, 50, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 37, 60, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 37, 40, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 37, 30, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 37, 80, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 37, 70, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 37, 50, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 37, 70, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 37, 30, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 37, 40, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 37, 80, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 38, 80, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 38, 30, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 38, 60, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 38, 30, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 38, 30, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 38, 80, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 38, 50, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 38, 80, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 38, 70, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 38, 40, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 38, 50, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 38, 50, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 39, 40, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 39, 40, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 39, 40, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 39, 50, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 39, 70, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 39, 30, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 39, 40, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 39, 60, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 39, 40, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 39, 60, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 39, 70, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 39, 50, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 40, 50, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 40, 60, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 40, 50, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 40, 30, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 40, 60, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 40, 60, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 40, 40, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 40, 40, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 40, 70, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 40, 80, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 40, 40, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 40, 40, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 41, 30, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 41, 30, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 41, 50, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 41, 70, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 41, 70, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 41, 60, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 41, 70, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 41, 30, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 41, 40, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 41, 40, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 41, 40, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 41, 60, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 42, 70, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 42, 30, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 42, 80, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 42, 80, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 42, 80, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 42, 60, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 42, 60, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 42, 80, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 42, 40, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 42, 60, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 42, 70, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 42, 80, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 43, 80, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 43, 80, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 43, 40, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 43, 40, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 43, 80, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 43, 40, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 43, 70, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 43, 60, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 43, 80, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 43, 30, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 43, 50, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 43, 40, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 44, 50, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 44, 40, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 44, 30, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 44, 60, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 44, 60, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 44, 70, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 44, 80, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 44, 50, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 44, 40, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 44, 70, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 44, 50, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 44, 70, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 45, 70, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 45, 50, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 45, 60, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 45, 70, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 45, 70, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 45, 70, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 45, 50, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 45, 70, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 45, 60, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 45, 70, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 45, 40, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 45, 70, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 46, 50, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 46, 60, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 46, 40, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 46, 80, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 46, 60, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 46, 50, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 46, 50, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 46, 50, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 46, 30, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 46, 70, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 46, 40, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 46, 40, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 47, 50, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 47, 70, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 47, 30, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 47, 80, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 47, 60, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 47, 40, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 47, 40, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 47, 40, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 47, 30, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 47, 60, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 47, 70, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 47, 80, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 48, 60, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 48, 70, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 48, 70, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 48, 80, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 48, 70, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 48, 40, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 48, 70, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 48, 40, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 48, 70, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 48, 70, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 48, 70, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 48, 70, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 49, 80, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 49, 40, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 49, 50, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 49, 70, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 49, 80, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 49, 30, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 49, 70, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 49, 70, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 49, 30, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 49, 40, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 49, 60, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 49, 70, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 50, 60, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 50, 70, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 50, 30, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 50, 40, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 50, 80, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 50, 40, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 50, 30, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 50, 50, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 50, 40, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 50, 60, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 50, 80, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 50, 40, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 51, 30, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 51, 60, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 51, 70, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 51, 30, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 51, 60, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 51, 60, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 51, 60, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 51, 50, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 51, 50, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 51, 80, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 51, 70, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 51, 30, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 52, 40, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 52, 60, 2018, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 52, 60, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 52, 50, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 52, 60, 2018, 2)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 52, 50, 2016, 1)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 52, 50, 2013, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 52, 50, 2014, 12)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 52, 30, 2015, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 52, 80, 2015, 4)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 52, 70, 2017, 7)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 52, 50, 2006, 6)

INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 53, 40, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 53, 30, 2018, 1)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 53, 60, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 53, 80, 2015, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 53, 50, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 53, 30, 2016, 1)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 53, 60, 2013, 12)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 53, 30, 2014, 12)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 53, 60, 2015, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 53, 60, 2015, 4)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 53, 60, 2017, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 53, 70, 2006, 6)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (1, 54, 30, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (2, 54, 50, 2018, 1)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (3, 54, 50, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (4, 54, 70, 2015, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (5, 54, 50, 2018, 2)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (6, 54, 40, 2016, 1)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (7, 54, 40, 2013, 12)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (8, 54, 70, 2014, 12)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (9, 54, 70, 2015, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (10, 54, 70, 2015, 4)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (11, 54, 70, 2017, 7)
INSERT [dbo].[SHOW] ([FID], [TID], [PRICE], [YEAR], [MONTH]) VALUES (12, 54, 80, 2006, 6)

--2.2数据更新
--1）分别用一条sql语句完成对电影表基本的增、删、改的操作；

--新增(15,'大话西游','喜剧/爱情/奇幻','刘镇伟',138,'N',92)
insert into FILM(FID,FNAME,FTYPE,DNAME,FLENGTH,IS3D,GRADE) values (15,'大话西游','喜剧/爱情/奇幻','刘镇伟',95,'N',NULL);
--修改“FID=15,FNAME=大话西游”的记录的FLENGTH为110
UPDATE FILM SET FLENGTH = 110 WHERE FID = 15; 
--删除“FID=15,FNAME=大话西游”的记录
DELETE FROM FILM WHERE FID = 15; 
--查询语句执行情况
SELECT * FROM FILM

--2）批处理操作
-- 将演员表中的90后演员记录插入到一个新表YOUNG_ACTOR中。

--新建表YOUNG_ACTOR
CREATE TABLE YOUNG_ACTOR(
ACTID INT PRIMARY KEY,
ANAME CHAR(30),
SEX CHAR(2),
BYEAR INT
);

--插入数据
INSERT INTO YOUNG_ACTOR SELECT * FROM ACTOR WHERE ACTOR.BYEAR > 1990

--查询插入结果
SELECT * FROM YOUNG_ACTOR


--3）数据导入导出
--通过查阅DBMS资料学习数据导入导出功能,并将任务2.1所建表格的数据导出到操作系统文件,然后再将这些文件的数据导入到相应空表。

--导出
--①选择需要导出的数据库
--②选中“任务”->“导出数据”
--③选择导出的数据源“SQL Server”
--④登录服务器
--⑤选择复制到的目标文件
--⑥选择需要复制的数据库中的表
--⑦点击完成,完成导出

--导入
--①选择需要导出的数据库
--②选中“任务”->“导入数据”
--③选择导入的数据源
--④选择复制到的目标文件“SQL Server”
--⑤登录服务器
--⑥选择需要复制的数据库中的表
--⑦点击完成,完成导出

--4）观察性实验
--建立一个关系,但是不设置主码,然后向该关系中插入重复元组,然后观察在图形化交互界面中对已有数据进行删除和修改时所发生的现象。
--建立关系TSET1(TNUM int , VALUE int)
CREATE TABLE TEST1(
TNUM INT,
VALUE INT
)
--插入重复元组,执行下列语句10次
INSERT INTO TEST1(TNUM,VALUE) VALUES(1,100);
--观察插入结果
SELECT * FROM TEST1
--修改
--修改其中一行,提示“未更新任何行。
--未提交行1中的数据。
--错误源：Microsoft.SqlServer.Management.DataTools.
--错误消息：已更新或删除的行值要么不能使该行成为唯一行,要么改变了多个行（10行）。
--请更正错误并重试,或按Esc取消更改。”

--删除
--删除其中一行,提示“未删除任何行。
--试图删除行10时发生问题。
--错误源：Microsoft.SqlServer.Management.DataTools.
--错误消息：已更新或删除的行值要么不能使该行成为唯一行,要么改变了多个行（10行）。
--请更正错误并重试删除该行,或按Esc取消更改。”

--5）创建视图
--创建一个有80后演员作主角的参演记录视图,其中的属性包括：演员编号、演员姓名、出生年份、作为主角参演的电影数量、这些电影的用户评分的最高分。
CREATE VIEW ACTIN_80
AS 
SELECT ACTOR.ACTID, ACTOR.ANAME, ACTOR.BYEAR, COUNT(ACTIN.ISLEADING) AS LEADINGNUM, MAX(ACTIN. GRADE) AS MAXGRADE 
FROM ACTOR, ACTIN 
WHERE ACTOR.ACTID = ACTIN.ACTID AND 
      BYEAR BETWEEN 1980 AND 1989
GROUP BY ACTOR.ACTID, ACTOR.ANAME, ACTOR.BYEAR;

--创建成功后，从该视图中查询结果
SELECT * FROM ACTIN_80

--6）触发器实验
--编写一个触发器,用于实现对电影表的完整性控制规则：当增加一部电影时,若导演的姓名为周星驰,则电影类型自动设置为“喜剧”。
CREATE TRIGGER COMEDY
ON FILM
AFTER INSERT 
AS
UPDATE FILM SET FTYPE = '喜剧'
WHERE DNAME = '周星驰'

--新增一部电影
insert into FILM(FID,FNAME,FTYPE,DNAME,FLENGTH,IS3D,GRADE) values (15,'喜剧之王','喜剧/奇幻/爱情','周星驰',93,'N',90);
--查询新增结果
SELECT * FROM FILM

--2.3查询
--请分别用一条SQL语句完成下列各个小题的查询需求：
--1）查询“战狼”这部电影在洪山区各家影院的2015年的上映情况,并按照上映的月份的降序排列；
SELECT SHOW.TID,TNAME,MONTH,PRICE
FROM SHOW
JOIN THEATER ON SHOW.TID = THEATER.TID
JOIN FILM ON SHOW.FID = FILM.FID
WHERE FNAME = '战狼' AND
      YEAR = 2015 AND
	  TAREA = '洪山区'
ORDER BY MONTH DESC


--2）查询所有无参演演员信息的电影的基本信息,并且将结果按照电影类型的升序排列,相同类型的电影则按照用户评分的降序排列； 
SELECT * 
FROM FILM
WHERE FILM.FID NOT IN(SELECT ACTIN.FID FROM ACTIN )
ORDER BY FILM.FTYPE ASC ,
		 FILM.GRADE DESC

--3）查询所有直到2017年仍未上映的电影编号、电影名称、导演姓名；
SELECT FILM.FID,FNAME,DNAME
FROM FILM
WHERE FID NOT IN (SELECT SHOW.FID FROM SHOW WHERE YEAR <= 2017)

--4）查询在各家电影院均上映过的电影编号；
SELECT FID 
FROM SHOW 
GROUP BY FID 
HAVING COUNT(*)=(Select Count(*) From THEATER);

--5）查询所有用户评分低于80分或者高于89分的电影编号、电影名称、导演姓名及其用户评分,要求where子句中只能有一个条件表达式；
SELECT FID,FNAME,DNAME,GRADE
FROM FILM
WHERE GRADE NOT BETWEEN 80 AND 89

--6）查询每个导演所执导的全部影片的最低和最高用户评分； 
SELECT DNAME, MIN(FILM.GRADE) AS MIN_GRADE, MAX(FILM.GRADE) AS MAX_GRADE
FROM FILM
GROUP BY DNAME

--7）查询至少执导过2部电影的导演姓名、执导电影数量；
SELECT DNAME,COUNT(DNAME) AS FNUM
FROM FILM
GROUP BY DNAME
HAVING COUNT(DNAME) >= 2

--8）查询至少2部电影的用户评分超过80分的导演及其执导过的影片数量、平均用户评分；
SELECT DNAME,COUNT(DNAME) AS FNUM,AVG(GRADE) AS AVG_GRADE
FROM FILM
WHERE GRADE >= 80
GROUP BY DNAME
HAVING COUNT(*) >= 2

--9）查询至少执导过2部电影的导演姓名以及跟这些导演合作过的演员编号、姓名;
SELECT DISTINCT DNAME,ACTIN.ACTID,ANAME
FROM ACTIN
JOIN FILM ON FILM.FID = ACTIN.FID
JOIN ACTOR ON ACTIN.ACTID = ACTOR.ACTID
WHERE DNAME IN (SELECT DNAME
FROM FILM
GROUP BY DNAME
HAVING COUNT(DNAME) >= 2)

--10）查询每个演员担任主角的电影中的平均用户评分；
SELECT ACTIN.ACTID,ACTOR.ANAME,AVG(ACTIN.GRADE) AS AVG_GRADE
FROM ACTIN
JOIN FILM ON FILM.FID = ACTIN.FID
JOIN ACTOR ON ACTIN.ACTID = ACTOR.ACTID
WHERE ACTIN.ISLEADING = 'Y'
GROUP BY ACTIN.ACTID,ACTOR.ANAME

--11）查询用户评分超过90分的电影的最早上映年月； 
SELECT FILM.FID,FILM.FNAME,MIN(SHOW.YEAR) AS SHOW_YEAR, MIN(SHOW.MONTH) AS SHOW_MONTH
FROM FILM
JOIN SHOW ON FILM.FID = SHOW.FID
WHERE GRADE > 90
GROUP BY FILM.FID,FILM.FNAME

--12）查询用户评分超过90分的电影的最早上映年月及其相应的上映影院编号； 
SELECT FILM.FID,SHOW.TID,FILM.FNAME,MIN(SHOW.YEAR) AS SHOW_YEAR, MIN(SHOW.MONTH) AS SHOW_MONTH
FROM FILM
JOIN SHOW ON FILM.FID = SHOW.FID
WHERE GRADE > 90
GROUP BY FILM.FID,SHOW.TID,FILM.FNAME

--13）查询每个电影的上映总次数；
SELECT FILM.FID,COUNT(SHOW.FID) AS SHOW_NUM
FROM FILM
JOIN SHOW ON FILM.FID = SHOW.FID
GROUP BY FILM.FID
ORDER BY FILM.FID ASC

--14）查询执导过动作片,或者警匪片,或者枪战片的导演的姓名,要求where子句中只能有一个条件表达式；
SELECT DISTINCT DNAME
FROM FILM
WHERE FID IN (SELECT FID FROM FILM WHERE FILM.FTYPE LIKE '%动作%' OR FILM.FTYPE LIKE '%警匪%' OR FILM.FTYPE LIKE '%枪战%')

--15）查询所有“战狼”系列的电影的编号、电影名称、上映电影院名称及其上映年月,结果按照电影名称的升序排列；
SELECT SHOW.FID,FNAME,TNAME,SHOW.YEAR,SHOW.MONTH
FROM SHOW
JOIN THEATER ON SHOW.TID = THEATER.TID
JOIN FILM ON FILM.FID = SHOW.FID
WHERE FILM.FNAME LIKE '%战狼%'
ORDER BY FILM.FNAME ASC

--16）查询在同一个年月上映1号和2号电影的影院编号；
SELECT SHOW1.TID 
FROM SHOW SHOW1, SHOW SHOW2 
WHERE SHOW1.FID=1 AND 
      SHOW2.FID=2 AND 
      SHOW1.YEAR=SHOW2.YEAR AND 
	  SHOW1.MONTH=SHOW2.MONTH 
GROUP BY SHOW1.TID;

--17）查询所有没参演过用户评分85分以下电影的演员的编号、姓名；
SELECT ACTOR.ACTID,ACTOR.ANAME
FROM ACTOR
WHERE ACTOR.ACTID NOT IN(SELECT ACTIN.ACTID FROM ACTIN JOIN FILM ON ACTIN.FID = FILM.FID JOIN ACTOR ON ACTIN.ACTID = ACTOR.ACTID WHERE FILM.GRADE < 85)
GROUP BY ACTOR.ACTID, ACTOR.ANAME;

--18）查询参演过“吴宇森”执导过的所有电影的演员姓名；
SELECT ACTIN.ACTID,ACTOR.ANAME
FROM ACTIN 
JOIN FILM ON ACTIN.FID = FILM.FID 
JOIN ACTOR ON ACTIN.ACTID = ACTOR.ACTID
WHERE FILM.DNAME = '吴宇森' 
GROUP BY ACTIN.ACTID,ACTOR.ANAME
HAVING COUNT(*) = (SELECT COUNT(*) FROM FILM WHERE FILM.DNAME = '吴宇森')

--19）查询所有的演员的编号、姓名及其参演过的电影名称,要求即使该演员未参演过任何电影也要能够输出其编号、姓名；
SELECT DISTINCT ACTOR.ACTID, ACTOR.ANAME, FILM.FNAME 
FROM ACTOR 
LEFT JOIN ACTIN ON ACTOR.ACTID = ACTIN.ACTID 
LEFT JOIN FILM ON ACTIN.FID=FILM.FID 
ORDER BY ACTOR. ACTID, FILM. FNAME;

--20）查询所有上映超过3次但没有用户评分的电影编号、名称。
SELECT FILM.FID, FILM.FNAME 
FROM SHOW,FILM 
WHERE FILM.GRADE IS NULL AND 
      FILM.FID = SHOW.FID 
GROUP BY FILM.FID, FILM.FNAME 
HAVING COUNT(*)>3;

--2.4 了解系统的查询性能分析功能（选做）
--    选择上述2.3任务中某些较为复杂的SQL语句,查看其执行之前系统给出的分析计划和实际的执行计划,记录观察的结果,并对其进行简单的分析。


--2.5 DBMS函数及存储过程和事务（选做）
--1）通过系统帮助文档学习系统关于时间、日期、字符串类型的函数,为电影表增加首映时间属性,然后查询下个月首映的电影信息。
--2）编写一个依据演员编号计算在其指定年份参演的电影数量的自定义的函数,并利用其查询2017年至少参演过5部电影的演员编号。
--3）尝试编写DBMS的存储过程,建立每家影院的上映电影总数的统计表,并通过存储过程更新该表。
--4）尝试在DBMS的交互式界面中验证事务机制的执行效果。