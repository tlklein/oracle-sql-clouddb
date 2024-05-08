/* Create the IT Asset Management Schema */
/* Highlight each create command one at a time and run each one to create 
the tables and other infrastructure for the IT asset management (ITAM) backend
used for homework assignments. 

Drop statements are provided for you to drop objects as needed.*/




--Batch 1: Create the tables that have no dependencies on other tables.
--Create the asset_type table.
--Since it does not have any foreign keys, it does not depend on any other table.
--The asset_desc table (to be created later) depends on the asset_type table.

drop table asset_type;--Use as needed.

create table asset_type (
    asset_type_id number(10),
    asset_type_desc varchar2(50) not null,
    constraint asset_type_pk primary key(asset_type_id)
);

/* Use Oracle sqlldr tool or Oracle SQL Developer tool to import data from 
the asset_type_data.csv file (provided) into your asset_type table. This 
procedure is demonstrated in class. */

/* The attribute asset_type_id is a surrogate key for the asset_type entity. In 
Oracle database, a separate object called a sequence is created to generate
sequential integer values for a surrogate key field. Since asset_type_id values
have already been used for the uploaded data, set the sequence's start value
to something after the highest value used. */

drop sequence asset_type_id_seq;--Use as needed.

create sequence asset_type_id_seq start with 14;--You can start with anything 14 or higher



--Create the ci_status table.
--Since the ci_status table does not have any foreign keys, it does not depend on any other table.
--The ci_inventory table (to be created later) depends on the ci_status table.

drop table ci_status;--Use as needed.

create table ci_status
(
    ci_status_code char(8),
    ci_status_description varchar2(50),
    constraint ci_status__pk primary key(ci_status_code)    
);

/* Use Oracle sqlldr tool or Oracle SQL Developer tool to import data from 
the ci_status_data.csv file provided into your ci_status table. This 
procedure is demonstrated in class. */


--Create the department table.
--Since the table does not have any foreign keys, it does not depend on any other table.
--The employee table (to be created later) depends on the department table.

drop table department;
--All drop commands are coded for your convenience, to run as needed.

create table department (
    dept_code char(10),
    dept_name varchar2(50),
    constraint dept_pk primary key (dept_code)
);

/* Use Oracle sqlldr tool or Oracle SQL Developer tool to import data from 
the department_data.csv file provided into your department table. This 
procedure is demonstrated in class. */




--Batch 2: Create the tables that have a dependency on one of the tables created 
--in Batch 1.

--Create the asset_desc table.
--The asset_desc table has a foreign key to the asset_type table. This is 
--a dependency.

drop table  asset_desc;--Use as needed.

create table asset_desc (
  asset_desc_id number(10),
  asset_type_id number(10) not null,
  asset_make varchar2(50) not null,
  asset_model varchar2(50) not null,
  asset_ext varchar2(100) not null,
  constraint asset_desc_pk primary key(asset_desc_id),
  constraint unq_id_type unique (asset_desc_id,asset_type_id),
  constraint  asset_desc_asset_type_fk foreign key (asset_type_id)
  references asset_type(asset_type_id)
);

/* Use Oracle sqlldr tool or Oracle SQL Developer tool to import data from 
the asset_desc_data.csv file provided into your asset_desc table. This 
procedure is demonstrated in class. */

--The attribute asset_desc_id is a surrogate key for the asset description entity.
--In Oracle database, a separate object called a sequence can be created to generate
--sequential integer values for a surrogate key field.

drop sequence asset_desc_id_seq;--Use as needed.

create sequence asset_desc_id_seq
start with 2003;--You can start with any number higher than the largest value used


--Create the employee table. 
--It has a foreign key to the department table, a table that exists now. The
--employee table also has a foreign key to emp_id, one of its own fields.

drop table employee;--Use as needed.

create table employee (
	emp_id number(10),
	first_name varchar2(100) not null,
    last_name varchar2(100) not null,
    lastfour_ssn char(4) not null,
    co_mobile varchar2(12),
    co_email varchar2(100) not null,
    action varchar2(20) not null,
    action_date date not null,
    dept_code char(10) not null,
    job_title varchar2(200),
    supervisor_id number(10),
    constraint employee_pk primary key(emp_id),
    constraint emp_dept_fk foreign key (dept_code) 
    references department(dept_code),
    constraint supervisor_fk foreign key (supervisor_id)
    references employee(emp_id)
);

/* Use Oracle sqlldr tool or Oracle SQL Developer tool to import data from 
the employee_data.csv file provided into your employee table. This 
procedure is demonstrated in class. */

--The attribute emp_id is a surrogate key for the employee entity.
--In Oracle database, a separate object called a sequence can be created to generate
--sequential integer values for a surrogate key field.

drop sequence emp_id_seq;-- Use as needed.

create sequence emp_id_seq
start with 1562;--You can start with any value larger than the largest value used.




--Batch 3: Create the tables that have a dependency on the tables created in 
--Batch 2.

--Create the application table.
--The application table has a foreign key to the asset_desc table. This is a
--dependency.

drop table application;--Use as needed.

create table application (
	asset_desc_id number(10),
    asset_type_id number(10),
    appl_inst_version varchar2(10),
	appl_details varchar2(100), 
    constraint appl_pk primary key(asset_desc_id,asset_type_id),
    constraint appl_asset_desc_fk foreign key(asset_desc_id,asset_type_id)
    references asset_desc(asset_desc_id,asset_type_id)
 );

/* Use Oracle sqlldr tool or Oracle SQL Developer tool to import data from 
the application_data.csv file provided into your application table. This 
procedure is demonstrated in class. */


--Create the computer table.
--The computer table has a foreign key to the asset_desc table. This is a
--dependency.

drop table computer;--Use as needed.

create table computer (
    asset_desc_id number(10),
    asset_type_id number(10),
    cpu_details varchar2(100),
    graphics varchar2(50),
    vol_memory varchar2(25),
    storage_type varchar2(50),
    storage_capacity varchar2(10),
    display varchar2(20),--built-in or external
    bi_display_details varchar2(120),
    constraint computer_pk primary key(asset_desc_id,asset_type_id),
    constraint computer_asset_desc_fk foreign key(asset_desc_id,asset_type_id)
    references asset_desc(asset_desc_id,asset_type_id)
);

/* Use Oracle sqlldr tool or Oracle SQL Developer tool to import data from 
the computer.csv file provided into your computer table. This 
procedure is demonstrated in class. */


--Create the it_service table.
--The it_service table has a foreign key to the asset_desc table. This is a
--dependency.

drop table it_service;--Use as needed.

create table it_service (
    asset_desc_id number(10),
    asset_type_id number(10),
    service_details varchar2(200),
    constraint service_pk primary key(asset_desc_id,asset_type_id),
    constraint service_asset_desc_fk foreign key(asset_desc_id,asset_type_id)
    references asset_desc(asset_desc_id,asset_type_id)
);

/* Use Oracle sqlldr tool or Oracle SQL Developer tool to import data from 
the it_service_data.csv* file provided into your it_service table. This 
procedure is demonstrated in class. */
--There is no data to import from it_service_data.csv


--Create the peripheral table.
--The peripheral table has a foreign key to the asset_desc table. This is a
--dependency.

drop table peripheral;--Use if needed.

create table peripheral (
    asset_desc_id number(10),
    asset_type_id number(10),
    peripheral_details varchar2(200),
    constraint peripheral_pk primary key(asset_desc_id,asset_type_id),
    constraint peripheral_asset_desc_fk foreign key(asset_desc_id,asset_type_id)
    references asset_desc(asset_desc_id,asset_type_id)
);

/* Use Oracle sqlldr tool or Oracle SQL Developer tool to import data from 
the peripheral_data.csv* file provided into your peripheral table. The 
procedure for doing this was demonstrated in class. */
--There is no data to import from peripheral_data.csv


--Create the server table.
--The server table has a foreign key to the asset_desc table. This is a
--dependency.

drop table server;--Use if needed.

create table server (
	asset_desc_id number(10),
    asset_type_id number(10),
    cpu_details varchar2(100),
    vol_memory varchar2(25),
    storage_type varchar2(50),
    storage_capacity varchar2(10),
    constraint server_pk primary key(asset_desc_id,asset_type_id),
    constraint server_asset_desc_fk foreign key(asset_desc_id,asset_type_id)
    references asset_desc(asset_desc_id,asset_type_id)
);

/* Use Oracle sqlldr tool or Oracle SQL Developer tool to import data from 
the server_data.csv file provided into your server table. The procedure for doing
so was demonstrated in class. */


--Create the other table.
--The other table has a foreign key to the asset_desc table. This is a
--dependency.

drop table other;--Use as needed.

create table other (
	asset_desc_id number(10),
    asset_type_id,
    other_desc varchar2(100),
	other_details varchar2(100), 
    constraint other_pk primary key(asset_desc_id,asset_type_id),
    constraint other_asset_desc_fk foreign key(asset_desc_id,asset_type_id)
    references asset_desc(asset_desc_id,asset_type_id)
 );

/* Use Oracle sqlldr tool or Oracle SQL Developer tool to import data from 
the other_date.csv file provided into your other table. The procedure for doing 
so was demonstrated in class. */


--Create the it_asset_inv_summary table.
--The it_asset_inv_summary table has a foreign key to the asset_desc table. 
--This is a dependency.

drop table it_asset_inv_summary;--Use as needed.

create table it_asset_inv_summary (
    it_asset_inv_summary_id number(10),
    asset_desc_id number(10) not null,
    inv_summary_date date not null,
    num_available number(8),
    num_assgnd_use number(8),
    num_assgnd_support number(8),
    constraint it_inv_summary_pk primary key (it_asset_inv_summary_id),
    constraint inv_summary_asset_desc_fk foreign key (asset_desc_id) references
    asset_desc(asset_desc_id)
);

/* Use Oracle sqlldr tool or Oracle SQL Developer tool to import data from 
the it_asset_inv_summary_data.csv file into your it_asset_inv_summary table. The 
procedure for doing so was demonstrated in class. */

--The attribute it_asset_inv_summary_id is a surrogate key for the 
--it_asset_inv_summary entity.
--In Oracle database, a separate object called a sequence can be created to generate
--sequential integer values for a surrogate key field.

drop sequence it_asset_inv_summary_id_seq;--Use as needed.

create sequence it_asset_inv_summary_id_seq
start with 2215;--Start with any value larger than the largest value used in the data.




--Batch 4: Create the tables that have one or more dependencies on the tables 
--created in Batches 1 though 3.

--Create the ci_inventory table.
--The ci_inventory table has a foreign key to the ci_status table and it has a 
--foreign key to the asset_desc table . These are dependencies.

drop table ci_inventory;--Use as needed.

create table ci_inventory (
	ci_inv_id number(10),
    asset_desc_id number(10) not null,
    purchase_or_rental char(8),
    unique_id varchar2(50),--such as a serial number or license key
    ci_acquired_date date not null,
    ci_status_code char(8) not null,
    ci_status_date date not null,
    constraint ci_inv_pk primary key(ci_inv_id),
    constraint ci_inv_asset_fk foreign key(asset_desc_id)
    references asset_desc(asset_desc_id),
    constraint ci_inv_ci_status_fk foreign key (ci_status_code)
    references ci_status(ci_status_code)
);

/* Use Oracle sqlldr tool or Oracle SQL Developer tool to import data from 
the ci_iventory table belonging to the JAHERNA42 user on the class server. Import
only data inserted by the user JAHERNA42. The procedure for using Oracle SQL 
Developer tool to download the data and save it in a .csv or .xlsx file was 
demonstrated in class. */

--The attribute ci_inv_id is a surrogate key for the ci_inventory entity.
--In Oracle database, a separate object called a sequence can be created to generate
--sequential integer values for a surrogate key field.

drop sequence ci_inv_id_seq;--Use as needed.

create sequence ci_inv_id_seq
start with 83;--Start with any value larger than the largest value used in the data



--Batch 5: Create the tables that have one or more dependencies on the tables 
--created in Batches 1 though 4.

--Create the employee_ci table.
--The employee_ci table has a foreign key to the employee table and it has a 
--foreign key to the ci_inventory table . These are dependencies.

drop table employee_ci;--Use as needed.

create table employee_ci (
	ci_inv_id number(10),
    emp_id number(10) not null,
    use_or_support char(8) not null,
    date_assigned date not null,
	date_unassigned date NULL,
    constraint employee_ci_pk primary key(ci_inv_id,emp_id,use_or_support),
    constraint ci_inv_emp_asset_fk foreign key (ci_inv_id)
    references ci_inventory (ci_inv_id),
    constraint emp_asset_emp_fk foreign key(emp_id)
    references employee(emp_id)
);

/* Use Oracle sqlldr tool or Oracle SQL Developer tool to import data from 
the employee_ci table belonging to the JAHERNA42 user on the class server. Import
only data inserted by the user JAHERNA42. The procedure for using Oracle SQL 
Developer tool to download the data and save it in a .csv or .xlsx file was 
demonstrated in class. */




/* The tables of the schema are now created and data has been inserted. Note
that the process is successful because dependencies were accommodated. The 
dependencies required for creation of the tables also affect the order in 
which data can be inserted into the tables.

Here is the order in which the the tables were created. The order of creation 
within each "batch" is not important.

Batch 1: asset_type, ci_status, department
Batch 2: asset_desc, employee
Batch 3: application, computer, it_service, other, peripheral, server, 
it_asset_inv_summary
Batch 4: ci_inventory
Batch 5: employee_ci   */










