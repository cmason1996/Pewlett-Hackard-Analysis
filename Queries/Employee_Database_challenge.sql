--DELIVERABLE 1

--Selecting  data from Employees and Titles to get the titles for the retiring employees
SELECT em.emp_no, 
	   em.first_name, 
	   em.last_name, 
	   ti.title, 
	   ti.from_date, 
	   ti.to_date
INTO retirement_titles
FROM employees as em
LEFT JOIN titles as ti on em.emp_no = ti.emp_no
WHERE (em.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (em.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
ORDER BY em.emp_no DESC;

-- Use Dictinct with Orderby to remove duplicate rows from retirement_titles and save it as unique_titles
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
					rt.first_name,
					rt.last_name,
					rt.title
INTO unique_titles
FROM retirement_titles as rt
WHERE (rt.to_date = '9999-01-01')
ORDER BY rt.emp_no, rt.to_date DESC;

--Use COUNT() and ORDER BY to get the number of retiring employees in each department
SELECT COUNT(ut.emp_no), ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY COUNT (ut.emp_no) DESC;


--DELIVERABLE 2

--Retrieve data from employees and dept_employees and join the employees and dept_employees as well as the employees
--and titles tables while filtering for people who still work for PH and exporting date into the mentorship_eligibility table
SELECT DISTINCT ON (em.emp_no) em.emp_no, em.first_name, em.last_name, 
					em.birth_date, de.from_date, de.to_date, ti.title
INTO mentorship_eligibility
FROM employees as em
	INNER JOIN dept_employee as de
	ON (em.emp_no = de.emp_no)
	INNER JOIN titles as ti
	ON (em.emp_no = ti.emp_no)
WHERE (em.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
	AND (de.to_date = '9999-01-01')
ORDER BY em.emp_no;