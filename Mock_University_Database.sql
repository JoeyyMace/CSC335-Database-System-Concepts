--Joey Mace

/* 1.	[5 points] Find the number of students in each department. Rename the count as numbStudents. 
I.e., schema of the output should be (dept_name, numbStudents).*/

select d.dept_name, count(*) as numbStudents
from department d
left outer join student s on d.dept_name = s.dept_name
group by d.dept_name;

/* 2.	[5 points] For departments that have at least three students, find department name and number of students. 
Rename the second attribute in the output as numbStudents. */

select d.dept_name, count(*) as numbStudents
from department d
left outer join student s on d.dept_name = s.dept_name
group by d.dept_name
having count(*) >= 3;

-- 3.	[10 points] Use the set membership operator to find the names of students that have taken at least three courses.  

select s.name
from student s
where s.id in (select t.id
               from takes t
               group by t.id
               having count(*) >= 3);

-- 4. [10 points] Use the with clause to create a temporary relation to find the names of students that have taken at least three courses.   

with Courses as 
(select t.ID, count(*) as numbCourses
 from takes t
 group by t.ID
 having count(*) >= 3)
 select s.name
 from student s
 inner join Courses c on s.ID = c.ID;

-- 5. [10 points] Use the exists construct to find the names of students that have taken at least three courses.

select s.name
from student s
where exists (select t.ID
              from takes t
              where t.ID = s.ID
              group by t.ID
              having count(*) >= 3);

-- 6. [10 points] Use a correlated subquery in the where clause to find the names of students that have taken at least three courses.  

select s.name
from student s
where exists (select 1
              from takes t
              where t.ID = s.ID
              group by t.ID
              having count(*) >= 3);

-- 7. [10 points] Uses a derived relation (you may also need to use the lateral clause) to find the names of students 
-- that have taken at least three courses. 

select s.name
from (select t.ID
      from takes t
      group by t.ID
      having count(*) >= 3) as Courses
inner join student s on Courses.ID = s.ID;

-- 8. [10 points] Use an outer join to find names of the students in the university database who have never taken any course.

select s.name 
from student s
left join takes t on s.ID = t.ID
where t.ID is null;

-- 9. [10 points] Define the terms: view, materialized view, updatable view.
/*
View: A virtual table derived from one or more relatons that does not store data. This means they are recreated each time they are queried. 

Materialized view: These can store results of a query and are updated periodically showing changes made to the data it represents.

Updatable view: Allows for modifications through DML statements such as insert, delete, and update. An updatable view must meet certain
conditions such as only referencing one base table(no joins or subqueries), must not use distinct, group by, union, union all, or aggregates,
columns must be columns of a single base table, no expressions in the select clause that involves columns from another table.
*/

-- 10. [10 points] Write an SQL statement to create a view that gives the number of students in each department. 
--                 Schema of the view should be (dept_name, num_students).

create view total_students_per_dept as
select d.dept_name, count(*) as num_students
from department d
join student s on s.dept_name = d.dept_name
group by d.dept_name;


-- 11. [5 points] What is the difference between join type and join condition.
/*
The join type specifies how tuples will be joined together and how the result set will be. Eg. Inner join, left outer join,
right outer join. The join condition is what comes after the ON clause to specify the the relations should be linked.
*/

-- 12. [5 points] List the three different ways one can specify a join condition.
-- The three ways one can specify a join condition are natural or implicit, using clause, or on clause.
