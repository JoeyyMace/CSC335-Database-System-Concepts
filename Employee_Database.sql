--Joey Mace 
/* 1. Give an SQL schema definition for the following employee database:

employee (employee name, street, city)
works (employee name, company_name, salary)
company (company name, city)
manages(employee name, manager_name)

Choose an appropriate domain for each attribute and an appropriate primary key for each relation schema. 
Include foreign key constraints where needed. 
The table manages contains two foreign keys where both employee_name and manager_name are foreign keys referencing the relation employee. 
Be careful about the order you create the tables. */

CREATE TABLE if not exists employee (
	employee_name VARCHAR(100) PRIMARY KEY,
	street VARCHAR(100),
	city VARCHAR(100)
);

CREATE TABLE if not exists works (
	employee_name VARCHAR(100),
	company_name VARCHAR(100),
	salary DECIMAL(10, 2),
	FOREIGN KEY (employee_name) REFERENCES employee(employee_name)
);

CREATE TABLE if not exists company (
	company_name VARCHAR(100) PRIMARY KEY,
	city VARCHAR(100)
);

CREATE TABLE if not exists manages (
	employee_name VARCHAR(100),
	manager_name VARCHAR(100),
	FOREIGN KEY (employee_name) REFERENCES employee(employee_name),
	FOREIGN KEY (manager_name) REFERENCES employee(employee_name)
);

DELETE FROM manages;
DELETE FROM works;
DELETE FROM company;
DELETE FROM employee;

/* [20 points] Populate the tables you created for the previous question with data (i.e, write SQL insert statements to insert data in the tables). 
You need to insert at least three rows in each table. 
Be careful about the order you populate the tables with data. */

insert into employee(employee_name, street, city) values
('Joey Mace', '123 left street', 'Bellevue'),
('Riley Bagley', '321 right street', 'Springfield'),
('Cody Wilson', '231 center street', 'Santa Monica'),
('Logan Davis', '231 center street', 'Springfield'),
('Deric Flores', '231 center street', 'Springfield'),
('Abby Foster', '231 center street', 'Santa Monica')
ON CONFLICT (employee_name) DO NOTHING;

insert into works(employee_name, company_name, salary) values
('Joey Mace', 'Valve', '90000'),
('Riley Bagley', 'First Bank Corporation', '60000'),
('Cody Wilson', 'Activision', '55000'),
('Logan Davis', 'Valve', '110000'),
('Deric Flores', 'First Bank Corporation', '160000'),
('Abby Foster', 'Activision', '145000')
ON CONFLICT DO NOTHING;

insert into company(company_name, city) values
('Valve', 'Bellevue'),
('Blizzard', 'Santa Monica'),
('Activision', 'Santa Monica')
ON CONFLICT (company_name) DO NOTHING;

insert into manages(employee_name, manager_name) values
('Joey Mace', 'Logan Davis'),
('Riley Bagley', 'Deric Flores'),
('Cody Wilson', 'Abby Foster')
ON CONFLICT DO NOTHING;

/*For this question, you are not allowed to use any SQL command that was not covered in module 5. 
Answers that use SQL commands covered in modules after module 5 will be considered wrong. Write SQL queries to answer the following questions:
*/

--1. Find the names of all employees who work for “First Bank Corporation”.
select employee_name
from works
where company_name = 'First Bank Corporation';

--2. Find the company_name and city for every company. Order the output in alphabetical order by company_name.
select company_name, city
from company
order by company_name;

--3. Find the names of the employees who make a salary of at least $65,000. Notice: in the query the value should be specified as 65000.
select employee_name, salary
from works
where salary >= 65000;

--4. Find all employees in the database who live in the same cities as the companies for which they work.
select e.employee_name, c.company_name, e.city
from employee e
join works w on e.employee_name = w.employee_name
join company c on w.company_name = c.company_name
where e.city = c.city;

--5. Find all employees in the database who live in the same cities and on the same streets as do their managers.
select e.employee_name, e.city, e.street, m.manager_name
from employee e
join manages m on m.employee_name = e.employee_name
join employee manager on m.manager_name = manager.employee_name
where manager.city = e.city and manager.street = e.street;
