
use 文献管理数据库
Create Table Author
	(A#	      	char(9) 		primary key,
	 Aname 		varchar(10) 	 not null,
	 Aorganization  	varchar(20),
	 Atitle		varchar(20));
Create Table Paper
	(P#			varchar(40)  	primary key,
	 Pyear		varchar(8),
	 Ptopic		varchar(40),
	 Pproblem		varchar(1000));
Create Table Type
	(T#		char(10)		 primary key, 
	 Tname		varchar(30));
Create Table Method
	(M#		char(10) 		primary key,
	 Mname		varchar(30),
	 Minformation 	varchar(1000));
Create Table Reader
	(C#			char(9) 		primary key,
	 Citation	varchar(50));
Create Table Writing
	(A#			char(9),
	 P#			varchar(40),
	 T#			char(10),
	 M#			char(10),
	 Pyear		varchar(8),
	 Ptopic		varchar(40),
	 Pproblem	varchar(1000),
	 Primary key(A#, P#),
	 Foreign key(T#) References Type(T#),
	 Foreign key(M#) References Method(M#));
Create Table Reading
	(P#		varchar(40),
	 C#		char(9),
	 Rstrength		varchar(2000),
	 Rweakness		varchar(2000),
	 Ridea			varchar(2000),
	 Citation		varchar(50),
	 Primary key(C#, P#));


use 文献管理数据库
--rename 'reader' to 'ad'
--修改表名,防止与reading表混淆
execute sp_rename 'reader','ad' ;
select * from ad

use 文献管理数据库
--在Author表中增加列 nationality
alter table Author add nationality char(10);
select * from Author

use 文献管理数据库
--在Author表中删除列 nationality，以免过于冗杂
alter table Author drop column nationality;
select * from Reading

use 文献管理数据库
--修改reading表中列 Ridea的长度，容纳更多信息
alter table Reading alter column citation varchar(200);
select * from Author

use 文献管理数据库
select * from Author
--省略属性列的表示
insert into Author 
values('A001','赵欢','华南理工大学','硕士研究生');
select * from Paper
--不可以省略属性列的表示
insert into Paper(P#,Pyear,Ptopic)
values('P001','2019','基于时间序列模型与灰色模型的广东省旅游人数预测研究');
select * from Paper 
--Reading表插入操作
select * from Reading;
insert into Reading(P#,C#,Rstrength,Rweakness,Ridea)
values('P001','C001','优势','不足','想法');
select * from Reading;



use 文献管理数据库
--表的数据修改
select * from Author;
update Author
set Atitle='教授、长江学者'
where Aname='张文喜';
select * from Author;

--表的数据删除
use 文献管理数据库
select * from Type;
delete from Type
where Tname='著作';
select * from Type;

use 文献管理数据库
select * from Author;
--统计某列
select COUNT(*) as 作者数
from Author;

--修改表之修改属性（列）
ALTER TABLE Writing alter column Pproblem varCHAR(1000);
select * from Writing;

use 文献管理数据库
select COUNT(P#) as 文章记录数据个数
from Writing;

select COUNT (DISTINCT P# ) as 实际文章篇数
from Writing

ALTER TABLE Paper ADD PCC Int,CHECK(PCC  BETWEEN  0 AND 100);
select * from Paper;

use 文献管理数据库
--统计平均值，最小值等
    SELECT 
		AVG(PCC) as 引证文献平均数,
		Min(PCC) as 引证文献最小值,
		Max(PCC) as 引证文献最大值,
		Sum(PCC) as 引证文献总和
    FROM   Paper;

	 SELECT PCC  as 引证数不小于9的作者
      FROM Paper
      GROUP BY PCC
      HAVING PCC >=9
      ORDER BY PCC desc;

use 文献管理数据库
--查询Author中名字为两个字的作者的编号和姓名
SELECT A#,Aname 
FROM Author
WHERE ANAME LIKE '__';

--查询职称中包含教授的作者的编号和姓名
SELECT A#,ANAME
FROM Author
WHERE Atitle LIKE '教授%';
select* from  Paper 
   

use 文献管理数据库
SELECT A#
FROM  Author
WHERE Aorganization  like '大学%';


--表的嵌入查询+多表链接查询
--查询来自大学且作品发布年份最新的作者
SELECT A#,Max(Pyear) as 最新年份
    FROM Writing 
    WHERE A# IN  (SELECT A#
                FROM  Author
                WHERE Aorganization like '%大学')
GROUP BY A#;


--表的嵌入查询+多表链接查询
SELECT *
    FROM Reading
    WHERE P#=(SELECT P#
                FROM Paper 
                WHERE P# ='P005')
    AND C#='C005';


use 文献管理数据库
select* from writing, Method
--查询所有使用了文本访谈法(M005)的作者姓名和文章名。
--多表查询
          SELECT Aname,Ptopic,M#
          FROM Author,Writing 
          WHERE  Author.A#= Writing.A# 
            AND M# ='M005';

--谓词in
		 SELECT A#,Ptopic
		 FROM   Writing
		 WHERE  M# IN
				  (SELECT M#
				   FROM   Method
				   WHERE M# <>'M005');	 
				   
--谓词=any
     SELECT Pyear,Ptopic
	 FROM   Paper
	 WHERE  Pyear = any
				  (SELECT Pyear
				   FROM   Writing
				   WHERE Pyear >'2000');   
				   
 --谓词=some
     SELECT Pyear,Ptopic
	 FROM   Paper
	 WHERE  not Exists(SELECT *
				   FROM   Writing
				   WHERE Pyear ='2000');

 --谓词=some
     SELECT Pyear,Ptopic
	 FROM   Paper
	 WHERE  Exists(SELECT *
				   FROM   Writing
				   WHERE Pyear ='2000');


--创建引证数小于15的视图
Create view P_PCC1 (P#, MAX_PCC)
	as select P#, MAX(PCC)
	from Paper
	where PCC < 15
	group by P#;

select * from P_PCC1


use 文献管理数据库
select *
	from Reading 


use 文献管理数据库
--谓词演算第二部分 
--谓词 all 查询2019年引证数量最大的所有文章的信息
	SELECT Writing.*
    FROM Writing,Paper
	WHERE Paper.P#=Writing.P#
    AND   PCC >ALL (SELECT PCC
                     FROM Writing,Paper
                     WHERE Paper.P#=Writing.P#
                     AND  Paper.Pyear='2019');

--优化
	select Writing.*
	from Writing,Paper
	where Paper.P#=Writing.P#
	And PCC > (select max (PCC)
					from Paper,Writing 
					where Paper.P#=Writing.P#
					and Paper.Pyear='2019');


 --查询没有记录文章信息的作者名称和编号
select A#,Aname  from Author
where not exists(select *
                from Writing
                where A#=Author.A#);

use 文献管理数据库
CREATE VIEW 引证视图(P,PCC)
        AS SELECT P#,PCC
           FROM  Paper
           WHERE PCC <=15 
		   group by P#,PCC;
select *
from 引证视图;


--更新作者头衔为教授的引证数据
update paper
set PCC =PCC /1.06
where Pyear in (select  Pyear 
				 from Paper
				 where Pyear < '2000');

insert into Paper_AVG(P#,AVG_PCC)
select P#,AVG(PCC)
from Paper
where P# in (select P#
			 from Writing 
			 where Pyear ='2019')
group by P#
having AVG(PCC)>9;

/*带有子查询的数据插入操作,临时表题目名字为’旅游者行为研究‘课程的相关信息：
作者编号，作者姓名，文章名称以及研究问题。*/
create table A_W
(A# char(9),
Aname VARCHAR(10),
Ptopic VARCHAR(1000),
Pproblem VARCHAR(1000))

INSERT INTO A_W(A#, Aname, Ptopic, Pproblem)
       SELECT Author.A#, Aname, Ptopic,Pproblem
       FROM Author,Writing
       WHERE Author.A# IN
                (SELECT A#
                  FROM Writing
                  WHERE P# in
                           (select P#
                           from Paper
                           where Ptopic like '旅游者行为研究%'));
select * from A_W;
delete from A_W;


----将“作者头衔为教授”的引证数量提高6%-T-SQL
begin transaction sscore;
	declare @tran_error int;    
	set @tran_error = 0;    
	begin try
	    update Paper set PCC = PCC * 1.06 where Pyear< '2000';
	    update Paper set PCC= 20 where PCC>20
		set @tran_error = @tran_error + @@error;
	end try

	begin catch
		print '出现异常，错误编号：' + convert(varchar, error_number()) + '，错误消息：' + error_message();
		set @tran_error = @tran_error + 1;
	end catch
	
	if (@tran_error > 0)    
		begin        
			--执行出错，回滚事务     
			rollback tran;        
			print '出错，取消引证设置';    
		end
	else    
		begin        
			--没有异常，提交事务
			commit tran;
			print '成绩设置成功';    
		end