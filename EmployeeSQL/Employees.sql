--Data Engineering
--create table schemas from the CSV files

create table Departments (
	dept_no varchar(30) not null primary key,
	dept_name varchar(30)
);

create table Dept_emp (
	emp_no int REFERENCES Employees(emp_no),
	dept_no varchar(30) REFERENCES Departments(dept_no)
);

create table Dept_Manager (
	dept_no varchar(30) REFERENCES Departments(dept_no),
	emp_no int REFERENCES Employees(emp_no)
);

create table Employees (
	emp_no int not null primary Key,
	emp_title_id varchar(30) REFERENCES Titles(title_id),
	birth_date date,
	first_name varchar(30),
	last_name varchar(30),
	sex varchar(30),
	hire_date date
);

create table Salaries (
	emp_no int REFERENCES Employees(emp_no),
	salary varchar(30)
);

create table Titles (
	title_id varchar(30) primary Key,
	title varchar(30)
);

--Data Analysis
--list employee no, last name, first name, sex, and salary
select e.emp_no, e.last_name, e.first_name, e.sex, s.salary
from employees e
left join salaries s
on e.emp_no = s.emp_no;

--list first name, last name and hire date for employees hired in 1986
select first_name, last_name, hire_date
from employees
where hire_date between '1986-01-01' and '1986-12-31';

--list the manager, dept_no, dept_name, emp_no, last name, first name
select
employees.emp_no,
employees.last_name,
employees.first_name,
departments.dept_no,
departments.dept_name,
titles.title
from employees
join dept_manager
	on employees.emp_no = dept_manager.emp_no
join departments
	on departments.dept_no = dept_manager.dept_no
join titles
	on employees.emp_title_id = titles.title_id;

--List the dept_no, emp_no, last name, first name and department name
select
employees.emp_no,
employees.last_name,
employees.first_name,
departments.dept_no,
departments.dept_name
from employees
join dept_emp
	on employees.emp_no = dept_emp.emp_no
join departments
	on departments.dept_no = dept_emp.dept_no;

--List first name, last name and sex of employees where first is 
--Hercules and last name starts with B
select
first_name,
last_name,
sex
from employees
where first_name = 'Hercules' and last_name LIKE 'B%';

--List employees' emp_no, last name and first name in the sales department
select
emp_no,
last_name,
first_name
from employees
where emp_no in
(
	select emp_no
	from dept_emp
	where dept_no in
	(
		select dept_no
		from departments
		where dept_name = 'Sales'	
	)
);

--List the emp_no, last name, first name and dept_name of employees
--in the sales and development department
select
e.emp_no,
e.last_name,
e.first_name,
d.dept_name
from employees e
join dept_emp m
	on e.emp_no = m.emp_no
join departments d
	on m.dept_no = d.dept_no
where d.dept_name IN('Sales', 'Development');

--count how many employees have the same last name
select last_name, count(*) AS Frequency
from employees
group by last_name
having count(*) > 1
order by last_name DESC;
