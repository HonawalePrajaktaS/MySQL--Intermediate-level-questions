/*Find all employees who have worked on more than one project.*/
select * from employees;
select ep.employee_id, e.name, count(project_id) as cnt from employees e
join employee_projects ep
on e.employee_id=ep.employee_id
group by ep.employee_id  having count(distinct project_id)>1;

/*List the projects that have not yet been assigned to any employees*/
select project_id from employee_projects where project_id not in (select distinct project_id from employee_projects); 

/*Retrieve the names of employees who have not been assigned to any projects*/
select * from employee_projects;
select ep.project_id, name from employees e
left join employee_projects ep
on e.employee_id=ep.employee_id
where ep.project_id is null;


/* Find the employee(s) with the highest salary in each department.*/
with max_salaries as (
select department_id, Max(salary) as high_salary 
from  employees
group by department_id)
 
select e.name, e.department_id, e.salary from employees e
join max_salaries ms
on e.department_id= ms.department_id
and e.salary= ms.high_salary;


select department_id, name, salary from employees where salary in 
(select max(salary) from employees group by department_id);

#####################################################################
/*List the names of employees along with their manager's name.*/
select name, manager_id from employees where manager_id is not null;

SELECT e.name AS employee_name, m.name AS manager_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id;

select * from branches;
select * from departments;
select * from employee_projects;
select * from employees;
select * from projects;

#####################################################################
/*Find all departments where the average salary of employees is 
greater than $50,000.*/

select department_id, avg(salary) as avh_sal from employees group by department_id having avh_sal > 50000; 

#####################################################################
/*Get the count of employees in each department, including departments with no employees*/
select d.department_id, d.department_name, count(e.employee_id) as emp_cnt from employees e 
join departments d on e.department_id=d.department_id
group by d.department_id;

#####################################################################
/*List all projects that were started after January 1, 2020*/
select project_id, project_name, start_date from projects where date(start_date) > "2020-01-01";
SELECT project_id, project_name, start_date
FROM projects
WHERE start_date > '2020-01-01';

#####################################################################
/* Retrieve the name and email of employees who have not reported to any manager*/
select name from employees where manager_id is null;

#####################################################################
/*Find the second highest salary among all employees*/
select name , salary from employees order by salary desc limit 1 offset 1;

select max(salary) from employees where salary < (select max(salary) from employees)  ;

with nth as (select salary, rank() over(order by salary desc) as rnk from employees)
select salary from nth where rnk = 2;

select * from (select salary, rank() over(order by salary desc) as rnk from employees) a where rnk = 3;

#####################################################################
/* List all employees who were hired in the last 5 years*/
SELECT employee_id, name
FROM employees
WHERE TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) <= 5;

#####################################################################
/*Calculate the total number of days each project has taken, along with the project name*/
select * from projects;
select project_name , datediff(end_date,start_date) as total_days from projects;

#######################################################################
/*Retrieve the names of employees who are working on more than one project at a time*/
select e.name
from employees e
join employee_projects ep
on e.employee_id=ep.employee_id
group by e.employee_id,e.name
having count(ep.project_id)>1;

SELECT e.name
FROM employees e
JOIN employee_projects ep ON e.employee_id = ep.employee_id
GROUP BY e.employee_id
HAVING COUNT(DISTINCT ep.project_id) > 1;

#######################################################################
/* Find the number of employees who report to each manager*/
select manager_id, count(employee_id) as cnt from employees group by manager_id ;

#######################################################################
/*List the employees who share the same department and manager*/
select e.name , e2.name from employees e join employees e2 on e.name = e2.name and e.employee_id <> e2.employee_id
group by department_id;

select * from employees ; 
#######################################################################
/*Find all employees who have the same job title but different salaries.*/

SELECT name, salary, job_title
FROM employees e
WHERE job_title IN (
    SELECT job_title
    FROM employees
    GROUP BY job_title
    HAVING COUNT(DISTINCT salary) > 1
);


#####################################################################
/*Retrieve the department names where the total salary expenditure is more than $100,000*/
select d.department_id, d.department_name, sum(e.salary) as summ from departments d 
join employees e
on d.department_id = e.department_id
group by department_id 
having sum(salary) >10000;

SELECT d.department_name, SUM(e.salary) AS total_salary
FROM departments d
JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name
HAVING SUM(e.salary) > 100000;

###############################################################
/*Get a list of employees along with the number of projects they have worked on*/
select e.name, count(ep.project_id) as pid 
from employees e
left join employee_projects ep on e.employee_id = ep.employee_id
group by e.name;

#################################################################
/* Find the average salary of employees grouped by department.*/
select department_id, avg(salary) from employees group by department_id;

#################################################################
/*List the employees who do not have any subordinates*/

 
 #################################################################
 /*Retrieve all projects that have been completed within the last 3 years*/
 # select project_id, project_name from projects where timestampdiff(year, start_date, end_date) > 3;
 
SELECT project_name, end_date
FROM projects
WHERE end_date >= DATE_SUB(CURDATE(), INTERVAL 3 YEAR);

#################################################################
/*Find the employees whose salaries are above the average salary in their department*/
select name, salary,department_id from employees e
where salary >
(select avg(salary) from employees where department_id= e.department_id ) order by department_id desc;

#################################################################
/*List the project names and the number of employees working on each project*/
select p.project_name, count(e.employee_id) as cnt from projects p
join employee_projects ep on ep.project_id = p.project_id
join employees e on e.employee_id=ep.employee_id
group by project_name
having cnt>1;

#################################################################
/*Get the names of employees who have worked on every project*/
select e.name from employees e 
join employee_projects ep on e.employee_id=ep.employee_id 
group by e.name
having count(distinct ep.project_id) = (select count(*) from projects);

#################################################################
/*Retrieve the list of employees who have the same first name.*/
select e1.name 
from employees e1 
join employees e2 
on  e1.name=e2.name
AND e1.employee_id <> e2.employee_id
GROUP BY e1.name;


SELECT e1.name
FROM employees e1
JOIN employees e2 ON e1.name = e2.name AND e1.employee_id <> e2.employee_id
GROUP BY e1.name;

#################################################################
/*Find the earliest start date of projects in each department*/
select d.department_name, min(p.start_date) as dated 
from departments d
join projects p
on d.department_id=p.department_id
group by d.department_name;

################################################################
/* List the employees along with the duration (in days) they have spent on each project*/
select p.project_id, e.name, datediff(end_date, start_date) as dd from employees e 
join employee_projects ep on e.employee_id=ep.employee_id
join projects p on p.project_id=ep.project_id;

################################################################
 /*Retrieve the employees who have the same last name but work in different departments.*/
 select e1.name, e1.department_id from employees e1 
 join employees e2 
 on e1.name=e2.name 
 where e1.department_id !=e2.department_id;
 select * from employees;

#######################################################################
/*Get a list of projects along with the total number of employees assigned to each, including projects with no employees.*/
select p.project_id, p.project_name, count(e.employee_id) as cnt  from projects p
join employee_projects ep on ep.project_id=p.project_id
join employees e on e.employee_id=ep.employee_id
group by p.project_id
having cnt>1;
 
 ###################################################################
 /*Find all employees whose salaries are within the top 10% of all employees.*/
select name, salary from employees order by salary desc limit 10;





