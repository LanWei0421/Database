use ѡ�����ݿ�
CREATE VIEW �ɼ���ͼ1(ѧ��,ƽ���ɼ�)
        AS SELECT S#, AVG(GRADE)
           FROM  SC
           WHERE GRADE IS NOT NULL
           GROUP BY S#;

select *
from �ɼ���ͼ1;

 --��ѯû��ѡ���κογ̵�ѧ������
select sname from s
where not exists(select *
                from SC
                where S#=S.S#);
--��ѯû���κ�ѧ��ѡ�Ŀγ�����
select c.C#,c.CNAME from C
where not exists(select *
                from SC
                where sc.C#=c.C#);

Select * from SC
--��ѯ���Գɼ����ڸ߶��������ѧ���γ̳ɼ���ѧ���Ļ�����Ϣ
   SELECT S.*
   FROM S,SC
   WHERE S.S#=SC.S#
   AND GRADE > (SELECT max(GRADE)
                     FROM S,SC
                     WHERE S.S#=SC.S#
                     AND  Class='��');

insert into S_C(S#,Sname)