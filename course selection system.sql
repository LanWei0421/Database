use 选课数据库
CREATE VIEW 成绩视图1(学号,平均成绩)
        AS SELECT S#, AVG(GRADE)
           FROM  SC
           WHERE GRADE IS NOT NULL
           GROUP BY S#;

select *
from 成绩视图1;

 --查询没有选过任何课程的学生姓名
select sname from s
where not exists(select *
                from SC
                where S#=S.S#);
--查询没有任何学生选的课程名单
select c.C#,c.CNAME from C
where not exists(select *
                from SC
                where sc.C#=c.C#);

Select * from SC
--查询考试成绩大于高尔夫班所有学生课程成绩的学生的基本信息
   SELECT S.*
   FROM S,SC
   WHERE S.S#=SC.S#
   AND GRADE > (SELECT max(GRADE)
                     FROM S,SC
                     WHERE S.S#=SC.S#
                     AND  Class='高');

insert into S_C(S#,Sname)