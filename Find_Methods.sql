--Joey Mace

/*
1. Find the number of students in each department. Rename the second attribute in the output as number_students. 
This means the schema of the output is (dept_name, number_students).
*/
SELECT dept_name, COUNT(*) AS number_students
FROM student 
GROUP BY dept_name;

/*
2. For departments that have at least three students, find department name and number of students. 
Rename the second attribute in the output as number_students. 
Remark: this question is similar to the previous one but the output lists only department that has at least three students.
*/
SELECT dept_name, COUNT(*) AS number_students
from student
GROUP By dept_name
HAVING COUNT(*) >= 3;

/*
3. Find the ids of instructors who are also students using a set operation. Assume that a person is identified by her or his id. 
So, if the same id appears in both instructor and student, then that person is both an instructor and a student. 
Remember: set operation means union, intersect or set difference.
*/
SELECT ID 
FROM instructor
INTERSECT 
SELECT ID
FROM student;

/*
4. Find the ids of instructors who are also students using the set membership operator.
*/
SELECT ID
FROM instructor
WHERE ID IN (SELECT ID FROM student);

/*
5. Find the ids of instructors who are also students using a set comparison operator.
*/
SELECT ID
FROM instructor i
WHERE EXISTS (
  SELECT *
  FROM student s 
  WHERE i.ID = s.ID
);
