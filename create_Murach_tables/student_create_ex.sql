/* Highlight each create command one at a time and run each one to create 
the tables and other infrastructure for the examples tables used for several
examples in the Murach book. The examples tables do not correspond to a 
realistic business process. They are just examples the author uses to illustrate 
a particular techique or concept.*/


create table color_sample
(
  color_id      number                        not null,
  color_number  number            default 0   not null,
  color_name    varchar2(10)
);


create table customers
(
  customer_id          number            not null,
  customer_last_name   varchar2(30),
  customer_first_name  varchar2(30),
  customer_address     varchar2(60),
  customer_city        varchar2(15),
  customer_state       varchar2(15),
  customer_zip         varchar2(10),
  customer_phone       varchar2(24)
);


create table date_sample
(
  date_id       number   not null,
  start_date    date
);

create table departments
(
  department_number   number        not null,
  department_name     varchar2(50)  not null,
  constraint department_number_unq  unique (department_number)
);

create table employees
(
  employee_id         number            not null,
  last_name           varchar2 (35)     not null,
  first_name          varchar2 (35)     not null,
  department_number   number            not null,
  manager_id          number
);

create table float_sample
(
  float_id       number,
  float_value    binary_double
);

create table null_sample
(
  invoice_id      number            not null,
  invoice_total   number(9,2),
  constraint invoice_id_unq unique (invoice_id)
);


create table projects
(
  project_number    varchar2(5)   not null,
  employee_id       number        not null
);

create table string_sample
(
  id        varchar2(3),
  name      varchar2(25)
);

create table downloads (
download_id number(38) primary key,
date_value date default sysdate,
timestamp_value timestamp(6),
timestamp_wltz_value timestamp with local time zone,
timestamp_wtz_value timestamp with time zone);

create sequence download_id_seq;

create table interval_ym_sample
(interval_id number(38) primary key,
interval_val interval year(3) to month);

create sequence interval_id_seq;

create table interval_ds_sample
(intervalds_id number(38) primary key,
interval_val interval day(3) to second(2));

create sequence intervalds_id_seq;



-- Disable substitution variable prompting 
/*** This is an important step. DO NOT MISS THIS STEP!!! ***/
set define off;

/* Run the insert statements for one table at a time by
highlighting all the statements for one table and then 
running that batch of commands. */

-- inserting into customers

insert into customers values (1, 'Anders', 'Maria', '345 Winchell Pl', 'Anderson', 'IN', '46014', '(765) 555-7878');
insert into customers values (2, 'Trujillo', 'Ana', '1298 E Smathers St', 'Benton', 'AR', '72018', '(501) 555-7733');
insert into customers values (3, 'Moreno', 'Antonio', '6925 N Parkland Ave', 'Puyallup', 'WA', '98373', '(253) 555-8332');
insert into customers values (4, 'Hardy', 'Thomas', '83 d''Urberville Ln', 'Casterbridge', 'GA', '31209', '(478) 555-1139');
insert into customers values (5, 'Berglund', 'Christina', '22717 E 73rd Ave', 'Dubuque', 'IA', '52004', '(319) 555-1139');
insert into customers values (6, 'Moos', 'Hanna', '1778 N Bovine Ave', 'Peoria', 'IL', '61638', '(309) 555-8755');
insert into customers values (7, 'Citeaux', 'Fred', '1234 Main St', 'Normal', 'IL', '61761', '(309) 555-1914');
insert into customers values (8, 'Summer', 'Martin', '1877 Ete Ct', 'Frogtown', 'LA', '70563', '(337) 555-9441');
insert into customers values (9, 'Lebihan', 'Laurence', '717 E Michigan Ave', 'Chicago', 'IL', '60611', '(312) 555-9441');
insert into customers values (10, 'Lincoln', 'Elizabeth', '4562 Rt 78 E', 'Vancouver', 'WA', '98684', '(360) 555-2680');
insert into customers values (11, 'Snyder', 'Howard', '2732 Baker Blvd.', 'Eugene', 'OR', '97403', '(503) 555-7555');
insert into customers values (12, 'Latimer', 'Yoshi', 'City Center Plaza 516 Main St.', 'Elgin', 'OR', '97827', '(503) 555-6874');
insert into customers values (13, 'Steel', 'John', '12 Orchestra Terrace', 'Walla Walla', 'WA', '99362', '(509) 555-7969');
insert into customers values (14, 'Yorres', 'Jaime', '87 Polk St. Suite 5', 'San Francisco', 'CA', '94117', '(415) 555-5938');
insert into customers values (15, 'Wilson', 'Fran', '89 Chiaroscuro Rd.', 'Portland', 'OR', '97219', '(503) 555-9573');
insert into customers values (16, 'Phillips', 'Rene', '2743 Bering St.', 'Anchorage', 'AK', '99508', '(907) 555-7584');
insert into customers values (17, 'Wilson', 'Paula', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', '(505) 555-5939');
insert into customers values (18, 'Pavarotti', 'Jose', '187 Suffolk Ln.', 'Boise', 'ID', '83720', '(208) 555-8097');
insert into customers values (19, 'Braunschweiger', 'Art', 'P.O. Box 555', 'Lander', 'WY', '82520', '(307) 555-4680');
insert into customers values (20, 'Nixon', 'Liz', '89 Jefferson Way Suite 2', 'Providence', 'RI', '02909', '(401) 555-3612');
insert into customers values (21, 'Wong', 'Liu', '55 Grizzly Peak Rd.', 'Butte', 'MT', '59801', '(406) 555-5834');
insert into customers values (22, 'Nagy', 'Helvetius', '722 DaVinci Blvd.', 'Concord', 'MA', '01742', '(351) 555-1219');
insert into customers values (23, 'Jablonski', 'Karl', '305 - 14th Ave. S. Suite 3B', 'Seattle', 'WA', '98128', '(206) 555-4112');
insert into customers values (24, 'Chelan', 'Donna', '2299 E Baylor Dr', 'Dallas', 'TX', '75224', '(469) 555-8828');

-- inserting into date_sample

insert into date_sample values (1, to_date('1979-03-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
insert into date_sample values (2, to_date('2010-02-28 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
insert into date_sample values (3, to_date('2013-10-31 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
insert into date_sample values (4, to_date('2015-02-28 10:00:00', 'YYYY-MM-DD HH24:MI:SS'));
insert into date_sample values (5, to_date('2016-02-28 13:58:32', 'YYYY-MM-DD HH24:MI:SS'));
insert into date_sample values (6, to_date('2016-03-01 09:02:25', 'YYYY-MM-DD HH24:MI:SS'));

create sequence date_id_seq start with 7;
-- inserting into departments 

insert into departments (department_number,department_name) values
(1,'Accounting');
insert into departments (department_number,department_name) values
(2,'Payroll');
insert into departments (department_number,department_name) values
(3,'Operations');
insert into departments (department_number,department_name) values
(4,'Personnel');
insert into departments (department_number,department_name) values
(5,'Maintenance');

-- inserting into employees

insert into employees
(employee_id,last_name,first_name,department_number,manager_id) values
(1,'Smith','Cindy',2,null);
insert into employees
(employee_id,last_name,first_name,department_number,manager_id) values
(2,'Jones','Elmer',4,1);
insert into employees
(employee_id,last_name,first_name,department_number,manager_id) values
(3,'Simonian','Ralph',2,2);
insert into employees
(employee_id,last_name,first_name,department_number,manager_id) values
(4,'Hernandez','Olivia',1,9);
insert into employees
(employee_id,last_name,first_name,department_number,manager_id) values
(5,'Aaronsen','Robert',2,4);
insert into employees
(employee_id,last_name,first_name,department_number,manager_id) values
(6,'Watson','Denise',6,8);
insert into employees
(employee_id,last_name,first_name,department_number,manager_id) values
(7,'Hardy','Thomas',5,2);
insert into employees
(employee_id,last_name,first_name,department_number,manager_id) values
(8,'O''Leary','Rhea',4,9);
insert into employees
(employee_id,last_name,first_name,department_number,manager_id) values
(9,'Locario','Paulo',6,1);

-- inserting into float_sample 

insert into float_sample values (1, 0.999999999999999);
insert into float_sample values (2, 1);
insert into float_sample values (3, 1.000000000000001);
insert into float_sample values (4, 1234.56789012345);
insert into float_sample values (5, 999.04440209348);
insert into float_sample values (6, 24.04849);


-- inserting into null_sample 

insert into null_sample (invoice_id,invoice_total) values (1,125);
insert into null_sample (invoice_id,invoice_total) values (2,0);
insert into null_sample (invoice_id,invoice_total) values (3,null);
insert into null_sample (invoice_id,invoice_total) values (4,2199.99);
insert into null_sample (invoice_id,invoice_total) values (5,0);

-- inserting into projects

insert into projects (project_number,employee_id) values ('P1011',8);
insert into projects (project_number,employee_id) values ('P1011',4);
insert into projects (project_number,employee_id) values ('P1012',3);
insert into projects (project_number,employee_id) values ('P1012',1);
insert into projects (project_number,employee_id) values ('P1012',5);
insert into projects (project_number,employee_id) values ('P1013',6);
insert into projects (project_number,employee_id) values ('P1013',9);
insert into projects (project_number,employee_id) values ('P1014',10);

-- inserting into string sample

insert into string_sample values ('1', 'Lizbeth Darien');
insert into string_sample values ('2', 'Darnell O''Sullivan');
insert into string_sample values ('17', 'Lance Pinos-Potter');
insert into string_sample values ('20', 'Jean Paul Renard');
insert into string_sample values ('3', 'Alisha von Strump');


--Commit the data changes
/*** This is an important step. DO NOT MISS IT! ***/
commit;