--Selecting people whose birthdays are between 1952/01/01-1955/12/31 for retirement eligibility (90,000+ people)
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'; 

--Refining the selection further to only look for people of retirement age born in 1952 (21,209 people)
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31'; 

--Refing the list again to look for people born between 1952 and 1955 and hired between 1985 and 1988 (41,380 people)
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Running the same code above and saving it into a new table with an INTO statement
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Dropping the retirement_info table to recreate it with more info
DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- Joining retirement_info and dept_employee tables
SELECT ri.emp_no,
    ri.first_name, 
	ri.last_name, 
    de.to_date
INTO current_employee
FROM retirement_info as ri
LEFT JOIN dept_employee as de 
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

--Joining current_employee and dept_employee and then using GROUP BY to seperate employees into their departments
--Used COUNT() and SELECT to get the total number of employees in each department
--Used LEFT JOIN because only wanted the employee number from Table 1
--ON tells the code where to look to match the columns of data
--GROUP BY is the magic code that gives us the total number of employees retiring from each department
--Adding in ORDER BY to keep the data in order no matter how many times the script is run
--Saving data into new table to be export
SELECT COUNT(ce.emp_no), de.dept_no
INTO retiring_department
FROM current_employee as ce
LEFT JOIN dept_employee as de
	ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

--Looking to see if dates match employees table
SELECT * FROM salaries
ORDER BY to_date DESC;

--Gathering other into about the retiring employees 
SELECT emp_no, first_name, last_name, gender
INTO employee_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Joining employee_info to salaries 
SELECT e.emp_no, e.first_name, e.last_name, e.gender, s.salary, de.to_date
INTO employee_info
FROM employees as e
INNER JOIN salaries as s
	ON (e.emp_no = s.emp_no)
INNER JOIN dept_employee as de
	ON (e.emp_no = de.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	AND (de.to_date = '9999-01-01');
	
-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
INNER JOIN departments AS d
    ON (dm.dept_no = d.dept_no)
INNER JOIN current_employee AS ce
    ON (dm.emp_no = ce.emp_no);

--Getting a list of the individuals retiring that have their department name included
SELECT ce.emp_no, ce.first_name, ce.last_name, d.dept_name
INTO dept_info
FROM current_employee as ce
INNER JOIN dept_employee as de
	ON (ce.emp_no = de.emp_no)
INNER JOIN departments as d
	ON (de.dept_no = d.dept_no);
	
--Getting info for the sales department from retirement_info
SELECT * FROM dept_info
WHERE dept_name = 'Sales';

--Getting info for the sales and development department from retirement_info
SELECT * FROM dept_info
WHERE dept_name IN ('Sales', 'Development');