--Joey Mace 

--1. Find the ids of instructors who are also students using the exists construct.

select ID
from instructor 
where exists
(
  select *
  from student
  where student.ID = instructor.ID
);

/* 
2. Find the names and ids of the students who have taken all the courses that are offered by their departments. 
Notice, the table course contains information about courses offered by departments.
*/

select s.name, s.ID
from student s
where not exists
(
  select c.course_id
  from course c 
  where c.dept_name = (
  select d.dept_name
  from department d
  where d.dept_name = s.dept_name)
  except
  select t.course_id
  from takes t
  where t.ID = s.ID
);

/*
3. Find the names and ids of the students who have taken exactly one course in the Fall 2017 semester.
*/
select s.name, s.ID
from student s
join (select t.ID
      from takes t
      where t.semester = 'Fall' and t.year = '2017'
      group by ID
      having count(*) = 1) as answer on s.ID = answer.ID;

/*
4.Find the names and ids of the students who have taken at most one course in the Fall 2017 semester. Notice, at most one means one or zero. 
So, the answer should include students who did not take any course during that semester. 
*/
select s.name, s.ID
from student s
left join (select t.ID, count(*) as num_course
           from takes t
           where t.semester = 'Fall' and t.year = '2017'
           group by ID
           having count(*) = 1) as answer on s.ID = answer.ID
           where answer.num_course is null or answer.num_course = 1;

/*
5. Write a query that uses a derived relation to find the student(s) who have taken at least two courses in the Fall 2017 semester. 
Schema of the output should be (id, number_courses). Remember: derived relation means a subquery in the from clause. */
select ID, number_courses
from (select t.ID, count(*) as number_courses
      from takes t
      group by t.ID) as count_courses
where number_courses is null or number_courses <= 2;

/* 6. Write a query that uses a scalar query in the select clause to find the number of distinct courses that have been taught by each instructor. 
Schema of the output should be (name, id, number_courses).*/
select i.name, i.id, (select count(distinct course_id)
                                  from teaches t
                                  where i.id = t.id) as number_courses
from instructor i;

/* 7. Write a query that uses the with clause or a derived relation to find the id and number of courses that have been taken by student(s) who
have taken the most number of courses. Schema of the output should be (id, number_courses).
*/
with courses_count as(
  select t.ID, count(distinct course_id) as number_courses
  from takes t
  group by t.ID)
  select ID, number_courses
  from courses_count
  where number_courses = (select max(number_courses)
                          from courses_count);
                                 
