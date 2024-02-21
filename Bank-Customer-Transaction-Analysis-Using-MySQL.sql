-- This is a single line comment which SQL will NOT understand or execute!!!

/* 
This is a 
multiline 
comment
*/

-- Highlight all the lines below and press Ctrl /
-- This is a 
-- multiline 
-- comment

-- One time execution
-- create database dsp13; -- SQL query or command or statement or code

-- Everytime time execution
use dsp13;


select * from customer; -- extract query
-- "select" is a keyword which is like a "print" statement
-- "*" indicates "ALL columns"
-- "from" indicates a "keyword to identify the table"
-- "customer" indicates the "name of the table"

-- extract only few columns
select customer_id, customer_name from customer;

-- 1. Create a table called customer_account
create table customer_account(
Customer_id	int,
Account_Number	varchar(50),
Account_type	varchar(20),
Balance_amount	float,
Account_status	varchar(20),
Relationship_type char(1)
);

select * from customer_account;

select * from customer_transaction;

select transaction_amount, transaction_channel from customer_transaction;

-- 11:45:21	select transaction_amount, transaction_channel from customer_transaction LIMIT 0, 1000	Error Code: 1054. 
-- Unknown column 'transaction_channel' in 'field list'	0.000 sec


alter table customer_transaction 
change transcation_channel transaction_channel varchar(20);


/*========================
Operators

1. Mathematical operators: +, -, *, /
2. Comparison operators: >, <, >=, <=, =, !=
3. Logical operators: and, or, not
4. Special operators: in, like, between-and
=========================*/

-- 1. Mathematical operators: +, -, *, /
select * from customer_transaction;

select transaction_amount, transaction_amount*0.10 from customer_transaction;
select *, transaction_amount*0.10 from customer_transaction;
select *, transaction_amount*0.10 as service_charge from customer_transaction;


-- 2. Comparison operators: >, <, >=, <=, =, !=
-- 3. Logical operators: and, or, not

-- Obj: transactions amounting to more than 10000
select * from customer_transaction
where transaction_amount > 10000; -- where clause allows filtering of rows

-- Obj: tansactions amounting to more than 1000 from NY
select * from customer_transaction
where transaction_amount > 1000
and province = "NY";
-- and transaction_id >= 8;

-- transacctions amounting to more than 1000 and they are from either NY or MN
select * from customer_transaction
where transaction_amount > 1000
and (province = "NY" or province = "MN");


select * from customer_transaction
where transaction_amount > 1000
and (province = "NY" or province = "MN" or province = "CA");

-- 4. Special operators: in, like, between-and

select * from customer_transaction
where transaction_amount > 1000
and province in ("NY", "MN"); -- and (province = "NY" or province = "MN");

select * from customer_transaction;

select * from customer_transaction
where transaction_channel like "%cheque%"; -- regex: % indicates "any number of characters before or after a certain word"

-- display only those transactions which have "b" in the 5th position
select * from customer_transaction
where transaction_channel like "____b%"; -- regex: _ indicates "one charcater ONLY"


select * from customer_transaction
where transaction_amount between 0 and 30000;

-- not, !=, <>
select * from customer_transaction
where transaction_channel != "ECS transfer";

select * from customer_transaction
where transaction_channel <> "ECS transfer";

select * from customer_transaction
where not transaction_channel = "ECS transfer"; -- less common

select * from customer_transaction
where transaction_channel not in ("ECS transfer", "POS-Walmart");

select * from customer_transaction
where transaction_channel not like "%transfer%";

/*========================
Misc queries
=========================*/
select * from customer_account;

select distinct account_type from customer_account;

-- count() is a function that allows you to calculate the "length" of the output
select count(distinct account_type) as unique_acc_type_count from customer_account; -- length of "select distinct account_type" is 4

select count(*) from customer_account; -- length of "select *" is 16

select * from customer_account
limit 5;

-- Self study: Learn/ read the other variations of using "limit" keyword

-- sorting using order by
select * from customer;

select * from customer
order by state_code asc;

select * from customer
order by state_code desc;

-- display output where state_code is ascending and customer_id is descending
select * from customer
order by state_code asc, customer_id desc;


-- group by

select * from customer_account;

select account_type, avg(balance_amount) from customer_account
group by account_type;

select account_type, avg(balance_amount) as avg_balance from customer_account
group by account_type
order by account_type asc;


select account_type, account_status, avg(balance_amount) from customer_account
group by account_type, account_status;

-- Task: find the range of balance amount for each account type

/*========================
DML (insert, update, delete): "Modify/ Manipulate" contents (data) in the table 
=========================*/

select * from customer_transaction;

-- insert a SINGLE row of data into customer_transaction table
insert into customer_transaction values
(18, "5890-1970-7706-8913", 10000, "Shopping Cart", "MN", "08-05-2022");

-- insert MULTIPLE rows
insert into customer_transaction values
(19, "5890-1970-7706-8914", 11000, "Shopping Cart", "MN", "08-05-2022"),
(20, "5890-1970-7706-8915", 12000, "Unknown", "NY", "08-04-2022"),
(21, "5890-1970-7706-8916", 13000, "Shopping Cart", "MN", "08-05-2021");

insert into customer_transaction(transaction_id, transaction_amount) values
(22, 20000),
(23, 5000);

insert into customer_transaction values
(24, "5890-1970-7706-8914", null, "Shopping Cart", "MN", null);


-- update existing data/ rows
update customer_transaction set transaction_channel = "ABC" where transaction_id = 23; -- one row updation

select * from customer_transaction;

update customer_transaction set transaction_amount = 0
where transaction_amount < 0; -- multiple rows updation

update customer_transaction set transaction_amount = 200, province = "AB"
where transaction_id >= 19;


-- delete content/ data / rows

delete from customer_transaction where transaction_id >=18;

/*========================
DDL (rename, create, alter, truncate, modify, create, drop)
-- Table structure changes
=========================*/

select *, transaction_amount*0.10 as service_charge from customer_transaction;

select * from customer_transaction;

-- alter 
alter table customer_transaction add column service_charge float;

update customer_transaction set  service_charge = 0.10*transaction_amount;


-- create table 
-- create table customer_account(
-- Customer_id	int,
-- Account_Number	varchar(50),
-- Account_type	varchar(20),
-- Balance_amount	float,
-- Account_status	varchar(20),
-- Relationship_type char(1)
-- );

create table customer_transaction_ny as
(select * from customer_transaction
where province = "NY");

select * from customer_transaction_ny;

describe customer_transaction; -- metadata info

-- modify
-- modify the datatype of service charge column from float to int.
alter table customer_transaction modify service_charge int;

describe customer_transaction; 


-- rename a colunn
alter table customer_transaction rename column service_charge to service_fee;
select * from customer_transaction;

-- rename a table
rename table customer_transaction to customer_transaction_new;
select * from customer_transaction; -- error

rename table customer_transaction_new to customer_transaction;

use dsp13;

-- truncate removes all the data leaving the table structure untouched

select * from customer_transaction_ny;

truncate table customer_transaction_ny;

drop table customer_transaction_ny;

/*========================
SQL inbuilt STRING functions
https://dev.mysql.com/doc/refman/8.0/en/string-functions.html
=========================*/

-- strcmp()
select strcmp("text1", "text1"); -- 0 when first n second string MATCH
select strcmp("text1", "text12"); -- -1 when first string length is smaller than 2nd string length
select strcmp("text123", "text12"); -- 1 when first string length is greater than 2nd string length

select "teXT";
select lower("teXT");

select "                                             text";
select ltrim("                                             text");

select "                                             text                  ";
select trim("                                             text                  ");

select trim("                                             text1     text2                  "); -- does NOT remove white spaces in the middle

-- substring()
select substring("Roger Federer", 3, 6); -- (3,6) => (start position, how many characters to extract)

-- concat
select concat("Roger", " Federer");
select concat("Roger ", "Federer");
select concat("Roger", " ", "Federer");


select * from customer_transaction;

select transaction_channel, strcmp("ECS transfer", transaction_channel) from customer_transaction;

select transaction_channel, upper(transaction_channel) as transaction_channel_upper from customer_transaction;

-- Transaction of 0 done through ATM withdrawal in CA on 13-01-2020
-- Transaction of 23000 done through cheque deposit in MN on 15-03-2020

select concat("Transaction of ", transaction_amount) from customer_transaction;
select *, concat("Transaction of ", transaction_amount, " done through ", transaction_channel, " in ", province, " on ", transaction_date) 
as my_text
from customer_transaction;

/*========================
SQL datetime functions
https://dev.mysql.com/doc/refman/8.0/en/date-and-time-functions.html
MySQL acceptable datetime format is YYYY-MM-DD HH:MM:SS (Example: 2022-05-14 09:26:35)
=========================*/


select now(); -- returns date and time

select date(now()); -- returns just date

select curdate(); -- does same as above

select date_format(curdate(), "%d %M %Y");
select date_format(curdate(), "%d/%b/%y");
select date_format(curdate(), "%b/%y/%d");

select datediff(curdate(), "2021-05-12"); -- returns the difference in "days"

select * from customer_transaction;
select transaction_date, dayofmonth(transaction_date) as day_of_month from customer_transaction; -- not working
-- YYYY-MM-DD (acceptable to MySQL)


-- str_to_date
select transaction_date as original_date_format, str_to_date(transaction_date, "%d-%m-%Y") as changed_date_format from customer_transaction;
select transaction_date, dayofmonth(str_to_date(transaction_date, "%d-%m-%Y")) as day_of_month from customer_transaction; -- working

select transaction_date, datediff(curdate(), transaction_date) as date_diff_in_days from customer_transaction; -- not working
select transaction_date, datediff(curdate(), str_to_date(transaction_date, "%d-%m-%Y")) as date_diff_in_days from customer_transaction; -- working

select *, str_to_date(transaction_date, "%d-%m-%Y") as changed_date_format from customer_transaction;

describe customer_transaction;

create table customer_transaction_copy as
(select * from customer_transaction);

select * from customer_transaction_copy;

describe customer_transaction_copy;
alter table customer_transaction_copy modify transaction_date date; -- Why dint this work?
-- 10:29:05	alter table customer_transaction_copy modify transaction_date date	
-- Error Code: 1292. Incorrect date value: '13-01-2020' for column 'transaction_date' at row 1	0.015 sec

describe customer_transaction_copy;

select * from customer_transaction_copy;

--  Step1: Update "existing" date data to MySQL's acceptable format (YYYY-MM-DD)
select * from customer_transaction;
update customer_transaction set transaction_date = str_to_date(transaction_date, "%d-%m-%Y");
select * from customer_transaction;

--  Step2: Alter the datatype of transaction_date so that "future" entries follow MySQL's acceptable datetime format
describe customer_transaction;
alter table customer_transaction modify transaction_date date; -- this worked
describe customer_transaction;

select * from customer_transaction;

-- select transaction_date, dayofmonth(str_to_date(transaction_date, "%d-%m-%Y")) as day_of_month from customer_transaction; 
select transaction_date, dayofmonth(transaction_date) as day_of_month from customer_transaction; -- str_to_date() not needed anymore


/*========================
Union, union all
=========================*/

-- table 1
CREATE TABLE Student_Mumbai (
Id VARCHAR(10),
Full_Name VARCHAR(20),
Joining_Date DATE,
Marks INT,
Course_Id VARCHAR(20)
);


INSERT INTO Student_Mumbai VALUES
("M1", "Roger Federer", "2022-01-01", 98, "DSP"),
("M2", "Rafael Nadal", "2022-01-02", 98, "ML"),
("M3", "Novak Djokovic", "2022-01-03", 98, "AI"),
("M4", "Andy Murray", "2022-01-01", 95, "ML-AI"),
("M5", "Stan Wawrinka", "2022-01-01", 97, "DSP");

select * from student_mumbai;

-- table 2
CREATE TABLE Student_Blore (
Id VARCHAR(10),
Full_Name VARCHAR(20),
Joining_Date DATE,
Marks INT,
Course_Id VARCHAR(20)
);

INSERT INTO Student_Blore VALUES
("B1", "Serena Williams", "2022-01-01", 98, "AI"),
("B2", "Monica Seles", "2022-01-02", 98, "SQL"),
("B3", "Steffi Graff", "2022-01-03", 98, "ML"),
("B4", "Martina Navratilova", "2022-01-01", 99, "AI");

select * from Student_Blore;

-- union (rbinding of two dfs or tables)
select * from student_mumbai
union
select * from student_blore;

-- syntactically incorrect/ wrong
select id, full_name from student_mumbai
union
select id, full_name, marks from student_blore;

-- 11:09:10	select id, full_name from student_mumbai union select id, full_name, marks from student_blore	
-- Error Code: 1222. The used SELECT statements have a different number of columns	0.000 sec

-- logically incorrect/ wrong
select id, full_name from student_mumbai
union
select id, marks from student_blore;

-- union all
INSERT INTO Student_Blore VALUES
("M1", "Roger Federer", "2022-01-01", 98, "DSP");

select * from student_mumbai;
select * from student_blore;


select * from student_mumbai
union -- eliminates duplicate entries
select * from student_blore;

select * from student_mumbai
union all -- does NOT eliminate duplicate entries
select * from student_blore;

/*========================
Views
=========================*/

-- lets create a table to store all the values from CA state
select * from customer; -- parent/ master/ main table

create table customer_ca as
(select * from customer 
where state_code = "CA");

select * from customer_ca; -- child table

update customer set telephone = 12345 where customer_id = 123001; -- main table updation
select * from customer;
select * from customer_ca; -- up-to-date info NOT found

-- create a view (its a "table" that doesnt occupy any storage and contains up-to-date info)
create or replace view customer_mn as 
(select * from customer
where state_code = "MN");

select * from customer_mn;

update customer set telephone = 98765 where customer_id = 123002; -- main table updation
select * from customer;
select * from customer_mn; -- up-to-date info found


-- side note (but NOT recommended): update main table using view
update customer_mn set telephone = 10000 where customer_id = 123007;
select * from customer_mn; 
select * from customer;


-- Earlier Question solution: Find range for each account_type
SELECT account_type, MAX(balance_amount) - MIN(balance_amount) AS range_amount FROM customer_account
GROUP BY account_type;



use dsp13;

select * from customer;
select * from customer_mn;

create or replace view customer_mn as 
(select customer_id, customer_name, address from customer
where state_code = "MN");

select * from customer_mn;

/*========================
Keys and constraints
-- Primary and Foreign Key
=========================*/

-- Primary key
select * from student_mumbai;

insert into student_mumbai values
("M3", "Stefanos Tsitsipas", "2022-01-01", 97, "SQL"); -- should NOT be allowed (this got inserted in the table)


CREATE TABLE Student_Chennai (
Id VARCHAR(10) PRIMARY KEY,
Full_Name VARCHAR(20),
Joining_Date DATE,
Marks INT,
Course_Id VARCHAR(20)
);

INSERT INTO Student_Chennai VALUES
("M1", "Roger Federer", "2022-01-01", 98, "DSP"),
("M2", "Rafael Nadal", "2022-01-02", 98, "ML"),
("M3", "Novak Djokovic", "2022-01-03", 98, "AI"),
("M4", "Andy Murray", "2022-01-01", 95, "ML-AI"),
("M5", "Stan Wawrinka", "2022-01-01", 97, "DSP");

select * from student_chennai;

insert into student_chennai values
("M3", "Stefanos Tsitsipas", "2022-01-01", 97, "SQL"); -- disallowed (NOT inserted in the table)

-- 08:49:33	insert into student_chennai values ("M3", "Stefanos Tsitsipas", "2022-01-01", 97, "SQL")	
-- Error Code: 1062. Duplicate entry 'M3' for key 'student_chennai.PRIMARY'	0.000 sec

select * from student_chennai;


-- Foreign key

CREATE TABLE Course_Info (
Course_Name VARCHAR(20),
Duration_In_Months INT,
Complexity VARCHAR(20),
Id VARCHAR(20) PRIMARY KEY
);


INSERT INTO Course_Info VALUES
("DSP_India", 4, "Moderate", "DSP"),
("AI_India", 2, "Hard", "ML"),
("ML_India", 3, "Moderate", "AI"),
("AI-ML_India", 6, "Hard", "ML-AI");


select * from student_chennai;
select * from Course_Info;

insert into student_chennai values
("M6", "Stefanos Tsitsipas", "2022-01-01", 97, "SQL"); -- allowed (row got inserted)

delete from student_chennai where id = "M6";


alter table student_chennai add foreign key (course_id) references course_info(id);

insert into student_chennai values
("M6", "Stefanos Tsitsipas", "2022-01-01", 97, "SQL"); -- disallowed (row did NOT get inserted)

-- 09:54:19	insert into student_chennai values ("M6", "Stefanos Tsitsipas", "2022-01-01", 97, "SQL")	
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`dsp13`.`student_chennai`, CONSTRAINT `student_chennai_ibfk_1` FOREIGN KEY (`Course_Id`) REFERENCES `course_info` (`Id`))	0.000 sec


insert into course_info values
("SQL_India", 1, "Moderate", "SQL");

insert into student_chennai values
("M6", "Stefanos Tsitsipas", "2022-01-01", 97, "SQL");

-- primary key can NEVER be null
insert into student_chennai values
(null, "Stefanos Tsitsipas", "2022-01-01", 97, "SQL");

select * from student_chennai;

/*========================
Keys and constraints
-- Others
=========================*/

create table expensive_product (id INT auto_increment Primary key, -- all values should be unique and can NEVER be null (or missing)
product_name varchar(20) unique, -- all values should be unique and can HAVE null
price float, 
weight float default 100, 
company varchar(20) not null, -- duplicate values are allowed but it can NEVER be null
check (price >= 1000));

insert into expensive_product (product_name, price, weight, company) values ("TV1", 1500, 250, "ABC");
insert into expensive_product (product_name, price, weight, company) values ("TV2", 1500, 250, "PQR"); -- auto_incr increased id to 2
insert into expensive_product (product_name, price, weight, company) values ("TV3", 900, 250, "XYZ"); -- price check failed
insert into expensive_product (product_name, price, weight, company) values (null, 1900, 250, "XYZ"); -- works
insert into expensive_product (product_name, price, weight, company) values (null, 1900, 250, "XYZ"); -- also works
insert into expensive_product (product_name, price, company) values ("TV3", 1900, null);
insert into expensive_product (product_name, price, company) values ("TV3", 1900, "X");

select * from expensive_product;


/*========================
Joins
=========================*/

use dsp13;


CREATE TABLE employees (
    emp_no      INT             NOT NULL PRIMARY KEY,
    birth_date  DATE            NOT NULL,
    first_name  VARCHAR(14)     NOT NULL,
    last_name   VARCHAR(16)     NOT NULL,
    gender      ENUM ('M','F')  NOT NULL,    
    hire_date   DATE            NOT NULL
);

select * from employees;

CREATE TABLE departments (
    dept_no     CHAR(4)         NOT NULL,
    dept_name   VARCHAR(40)     NOT NULL,
    PRIMARY KEY (dept_no)
);

select * from departments;

CREATE TABLE dept_manager (
   emp_id       INT             NOT NULL,
   dept_no      CHAR(4)         NOT NULL,
   from_date    DATE            NOT NULL,
   to_date      DATE            NOT NULL,
   FOREIGN KEY (emp_id)  REFERENCES employees (emp_no),
   FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
   PRIMARY KEY (emp_id, dept_no)
); 

select * from dept_manager;

CREATE TABLE dept_emp (
    emp_no      INT             NOT NULL,
    dept_no     CHAR(4)         NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no)  REFERENCES employees   (emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no, from_date)
);

select * from dept_emp;

CREATE TABLE salaries (
    emp_no      INT             NOT NULL,
    salary      INT             NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    PRIMARY KEY (emp_no, from_date) 
); 

select * from salaries;

CREATE TABLE titles (
    emp_no      INT             NOT NULL,
    title       VARCHAR(50)     NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    PRIMARY KEY (emp_no, title, from_date)
);

select * from titles;


-- Inner join
select * from employees;
select * from salaries;

select * from employees
inner join salaries
on employees.emp_no = salaries.emp_no;

select * from employees as e
inner join salaries as s
on e.emp_no = s.emp_no;

-- import pandas as pd

select e.emp_no, e.birth_date as emp_birthdate, s.salary, s.from_date from employees as e
inner join salaries as s
on e.emp_no = s.emp_no;

select * from employees as e
inner join salaries as s
on e.emp_no = s.emp_no
where e.gender = "F";



-- hackerrank, leetcode, codewars: programming challenges
-- kaggle, analyticsvidya, hackerearth: Stats/ ML competition/ challenges


-- inner join using 3 tables
select * from employees t1
inner join dept_manager t2
on t1.emp_no = t2.emp_id -- first table or left table
inner join departments t3
on t2.dept_no = t3.dept_no;

-- same as above
select * from employees t1
join dept_manager t2
on t1.emp_no = t2.emp_id -- first table or left table
join departments t3
on t2.dept_no = t3.dept_no;


-- left join
select * from employees t1 -- employees is the left table
left join dept_manager t2 -- dept_manager is the right table
on t1.emp_no = t2.emp_id;

select * from dept_manager t1 
left join employees t2 
on t1.emp_id = t2.emp_no;


-- left join using 3 tables
select * from employees t1
left join dept_manager t2
on t1.emp_no = t2.emp_id -- first table or left table
left join departments t3
on t2.dept_no = t3.dept_no;


select t1.*, t2.dept_no, t2.from_date from employees t1
left join dept_manager t2
on t1.emp_no = t2.emp_id -- first table or left table
left join departments t3
on t2.dept_no = t3.dept_no;

-- right join
select * from dept_manager;

select * from employees t1 -- employees is the left table
right join dept_manager t2 -- dept_manager is the right table
on t1.emp_no = t2.emp_id;


-- left join
select * from employees t1 -- employees is the left table
left join dept_manager t2 -- dept_manager is the right table
on t1.emp_no = t2.emp_id;

-- same as above
select t2.*, t1.* from dept_manager t1 -- employees is the left table
right join employees t2 -- dept_manager is the right table
on t1.emp_id = t2.emp_no;


-- full join = left join + right join

-- left join 
select * from employees t1 -- employees is the left table
left join dept_manager t2 -- dept_manager is the right table
on t1.emp_no = t2.emp_id
union
-- right join
select * from employees t1 -- employees is the left table
right join dept_manager t2 -- dept_manager is the right table
on t1.emp_no = t2.emp_id;


/*========================
Subquery
=========================*/

select * from customer_transaction;

-- TWO step solution
-- step 1
select avg(transaction_amount) from customer_transaction; -- 9470.5882

-- step 2
select * from customer_transaction
where transaction_amount > 9470.5882;

-- SINGLE step solution using subqueries
-- outer query
select * from customer_transaction
where transaction_amount > 
(
-- inner query
select avg(transaction_amount) from customer_transaction
);


select * from customer_transaction;
select * from customer_account;


-- step 1
select account_number from customer_account
where account_type = "SAVINGS";

-- step 2
select * from customer_transaction
where account_number in (
"4000-1956-3456",
"4000-1956-2001",
"4000-1956-2900",
"4000-1956-3401",
"4000-1956-5102",
"4000-1956-5698",
"5000-1700-9800",
"5000-1700-7755"
);

-- SINGLE query solution using subquery

-- outer query
select * from customer_transaction
where account_number in 
(
-- inner query
select account_number from customer_account
where account_type = "SAVINGS"
);
