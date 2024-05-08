/* EX 4 Migrate ITAM to the Cloud and Create and Enable Users */


/* ABCCo has generally maintained and managed their own server hardware and 
infrastructure. Your team (the one evaluating the schema for IT asset management
proposed by the hired consultants) is charged with also evaluating the potential
for using cloud infrastructure for the IT asset management information system.

Your team has acquired limited access to Oracle's cloud infrastructure to begin 
evaluating the potential of the cloud using Oracle's free tier for testing. */


/* EX 4 Task 1. Create Users and Grant System Privileges 
Your team decides to create three users with privileges that enable them to log 
in to the cloud server and create tables and other objects. The privileges that 
need to be granted first are system level privileges rather than object level 
privileges. To create users and grant them privileges, you must be logged in to 
your cloud instance as the ADMIN user.

Logged in as ADMIN, create three users: TLKLEIN (where USERNAME is your 
Cougarnet user name), JDOE, and JDOEN (you choose the usernames for 
JDOE and JDOEN, choosing something other than 'JDOE' and 
'JDOEN'). 
Grant each created user these privileges: create session (enable user to create 
a session with the RDBMS database engine), create table, create sequence, create 
type, create procedure, create trigger, and create view. Templates are provided 
for the commands to grant privileges. You do NOT need to document each command 
you 
run to create a user and grant privileges. The commands used to document your 
work follow the templates provided.*/

/*EX 4 Task 1 Command Templates */
--(1) Create users and designate a quota for each on the tablespace.
create user TLKLEIN identified by Flowercake1$
default tablespace data quota 20 M on data;
--Use template (1) to create users named TLKLEIN, JDOE, JDOEN, 
--replacing USERNAME with your CougarNet user name and replacing JDOE and 
--JDOEN with names of your choosing.

--(2) Authorize users to create a session with the RDBMS database engine.
--Users create a session by connecting to the REDBMS database engine and logging 
--in.
grant create session to TLKLEIN;
--Use template (2) to grant the create session system privilege to each of your
--3 created users.

--(3) Authorize users to create objects in their own respective schemas.
grant create table to TLKLEIN;
grant create sequence to TLKLEIN; 
grant create type to TLKLEIN;
grant create procedure to TLKLEIN;
grant create trigger to TLKLEIN;
grant create view to TLKLEIN; 
--Use the six templates in (3) to authorize all three of your created users
--to create objects in their own repspective schemas.

--(4) Authorize users to perform a few other tasks. 
grant select any sequence to TLKLEIN ;
grant alter session to TLKLEIN;
--Use the two templates in (4) to authorize all three of your created users
--to select from any sequence and to alter their own sessions with the RDBMS.


/* Connected to your Oracle cloud instance as ADMIN, run a select command that 
you create from the template provided below to retrieve information from the 
system views dba_users and dba_sys_privs. Take a screenshot of the command and 
results for your deliverable document. That screenshot is the deliverable for 
Task 1.*/

--Trinity Klein
--Connected as cloud admin
--EX 4 Task 1 Deliverable Command for Create Users and Grant System Privilege
select username,'none' as privilege, created 
from dba_users 
where 
username in ('TLKLEIN','JDOE','JDOEN')
union
select grantee,privilege,sysdate 
from dba_sys_privs 
where 
grantee in ('TLKLEIN','JDOE','JDOEN')
order by username;


/* EX 4 Task 2. Connect to Your Cloud Instance as Each Created User
Now that you have created 3 users and granted privileges, use Oracle SQL 
Developer to connect to your cloud instance as each user (i.e., connect as 
TLKLEIN, JDOE, JDOEN). For each user's connection, use the 
same Wallet information you downloaded from Oracle cloud (you used the Wallet 
to connect as ADMIN for an IC).

Once you have the connections for the three cloud users set up, document the 
connections with a screenshot of the Connections window open in Oracle SQL 
Developer. */ 



/* Task 3. Create ITAM Tables and Objects
Connect to your Oracle cloud instance as the TLKLEIN user. Open the 
student_create_itam.sql SQL commands provided and, logged in as TLKLEIN, 
use the commands to create the ITAM schema tables and sequences in your cloud 
instance. 

Once you have the tables created, connect to your Oracle cloud instance as 
ADMIN and run the following select command that retrieves information from the 
system view dba_tables. Take a screenshot of the command and results for your 
deliverable document.*/ 

--Trinity Klein
--Connected as cloud admin, tables under itam_tlklein
--EX 4 Task 3 Create ITAM Tables and Objects
select owner, table_name,num_rows,tablespace_name 
from dba_tables where owner = 'TLKLEIN' 
order by num_rows desc;


/* EX 4 Task 4. Import the Sample Data Provided into your Cloud Instance Tables
Connect to your cloud instance as TLKLEIN to import the sample data. The 
instructor provided a video demonstrating the process for importing the sample
data using Oracle SQL Developer. The video is in your class Teams area under the 
Class Meetings channel - Files - EX4 folder. The instructor also put 
the other Ex 4 support files in the same folder.

Before you attempt to import the data into the employee table of the IT asset 
management system, disable the FK on supervisor_id in the employee table in the 
cloud. */
alter table itam_tlklein.computers enable constraint COMPUTER_ASSET_DESC_FK;
--right click on the employee table in the cloud, select import data, use the 
--GUI interface to continue
--after importing, enable the FK on supervisor_id in the employee table in the 
--cloud
alter table employee_ci disable constraint CI_INV_EMP_ASSET_FK;

alter SESSION set NLS_DATE_FORMAT = 'DD-MON-YYYY HH:MI:SS AM';

select * from employee;
commit;

/* Once you have imported the data , connect to your Oracle cloud instance as 
ADMIN to run the following select command that retrieves information from the 
system  view dba_tables. Take a screenshot of the command and results for your 
deliverable document.*/ 

--Trinity Klein
--Connected as cloud admin
--EX 4 Task 4 Import the Sample Data 
select owner,table_name,num_rows,tablespace_name 
from dba_tables where owner = 'TLKLEIN' 
order by num_rows desc;

/* Note that if you inserted all the data but the number of rows shows as null
for some tables, you should execute the following command to update the server
statistics for each table that shows num_rows as null when it should not.*/
exec dbms_stats.gather_table_stats('TLKLEIN','EMPLOYEE_CI');
--replace TLKLEIN by your user that owns the IT asset management tables
--replace TABLENAME with the name of the table for which you need to update stats


/* Task 5. Grant a User Access to TLKLEIN's Data
Connect to your Oracle cloud instance as ADMIN to grant a user privileges to 
create, retrieve, change, and destroy data from the TLKLEIN user's tables 
in that schema. Also grant the same user privileges to select values from the 
sequences of the TLKLEIN schema. Choose either JDOE or JDOEN to 
grant all of these privileges.*/ 

--EX 4 Task 5 Instructions and Command Templates
--Connected as CLOUD ADMIN
--grant select on each ITAM schema table to JDOE or JDOEN
grant insert,select,update,delete on tlklein.departments to JDOEN;
--there are 14 tables
--Replace owner with the username of the user who owns the ITAM tables.
--Replace table_name with the name of each ITAM table (one at a time).
--Replace youruser with the name of JDOE or JDOEN (a user for which you
--chose the name).
grant select on tlklein.it_Asset_inv_summary_id_seq to jdoe;
--there are 5 sequences
--Preplace owner with the username of the user who owns the ITAM sequences.
--Replace name_of_sequence with the name of each ITAM sequence (one at a time).
--Replace youruser with the name of JDOE or JDOEN (a user for which you
--chose the name).

/* Once you have granted one of your users privileges, connect to your Oracle 
cloud instance as ADMIN and run the following select command that retrieves 
information from the system view dba_tab_privs. Scroll down in the result set so
that the total number of rows retrieved is visible. Take a screenshot of the 
command and results for your deliverable document.*/ 

--Trinity Klein
--Connected as cloud admin
--EX 4 Task 5 Grant a User Access to ITAM's Data
select grantee,owner,table_name,grantor,privilege
from dba_tab_privs where grantee = 'JDOE'
order by table_name;


/* EX 4 Task 6. Connected as JDOE Access Data in ITAM's Tables 
Connect to your Oracle cloud instance as the user to whom you granted access to 
the tables belonging to ITAM (in EX 4 Task 5). Demonstrate that JDOE or 
JDOEN (whichever one you granted privileges to) has privileges to create, 
retrieve, change, and delete data in at least one table of the ITAM schema that 
belongs to another user (should be ITAM). I recommend working with a table 
without too many dependecies, such as asset_desc, employee, or department. 
Once you choose a table, write and run six SQL commands (described next).

Command 1. Insert a New Record
Write and run commands to insert a new record into the table you have chosen and
commit the data. Follow all the business rules about that data.
Command 2. Retrieve the New Record
Write and run a query to retrieve the data you inserted with Command 1.
Command 3. Change the New Data
Write and run command to change the data you inserted with Command 1 and commit 
the data change. 
Command 4. Retrieve the Changed Data
Write and run a query to retrieve the changed data you changed with Command 3.
Command 5.Delete the Data
Write and run commands to delete the data you inserted and then changed with 
Command 3 and commit the data deletion.
Command 6. Retrieve the Data
Write and run a query to retireve the data you deleted. The query you write  and 
run should return no rows.*/
select * from tlklein.department;

--Trinity Klein
--Connected as cloud admin
--EX 4 Task 6 Command 1
insert into tlklein.department values ('SWE','Software Engineers');

--Trinity Klein
--Connected as cloud admin
--EX 4 Task 6 Command 2
select * from tlklein.department where dept_code = 'SWE';

--Trinity Klein
--Connected as cloud admin
--EX 4 Task 6 Command 3
update tlklein.department set dept_name = 'Software Developers' where dept_code = 'SWE';

--Trinity Klein
--Connected as cloud admin
--EX 4 Task 6 Command 4
select * from tlklein.department where dept_code = 'SWE';

--Trinity Klein
--Connected as cloud admin
--EX 4 Task 6 Command 5
delete from tlklein.department where dept_code = 'SWE';

--Trinity Klein
--Connected as cloud admin
--EX 4 Task 6 Command 6
select * from tlklein.department where dept_code = 'SWE';

/* EX 4 Task 7. Create a Role and Grant Privileges Through the Role
Connect to your Oracle cloud instance as ADMIN and create a role named itam_user
so that users granted the role are able to create, retrieve, change, and destroy 
data from the ITAM user's tables in that schema. Also grant privileges to the 
role to select values from the sequences of the ITAM schema. */

--EX 4 Task 7 Instructions and Command Templates
--create the role
-- connect as ADMIN to run the commands
create role itam_user; -- connect as ADMIN
--Grant select on each ITAM schema table to the role.
grant insert,select,update,delete on tlklein.server to itam_user;
--there are 14 tables
--Replace owner with the username of the user who owns the ITAM tables.
--Replace table_name with the name of each ITAM table (one at a time).
grant select on tlklein.it_asset_inv_summary_id_seq to itam_user;--there are 5 sequences
--Preplace owner with the username of the user who owns the ITAM sequences.
--Replace name_of_sequence with the name of each ITAM sequence (one at a time).

/*Once you have the role created and have granted it privileges, connect to your
Oracle cloud instance as ADMIN and run the following select command that 
retrieves information from the system view dba_tab_privs. Scroll down in the 
result set so that the total number of rows retrieved is visible. Take a 
screenshot of the command and results for your deliverable document.*/ 

--Trinity Klein
--Connected as cloud admin
--EX 4 Task 7
select grantee,owner,table_name,grantor,privilege
from dba_tab_privs where grantee = 'ITAM_USER'
order by table_name;


/* EX 4 Task 8. Grant the Role to JDOEN
Grant to JDOEN the role itam_user that you created. */
--Connect as admin to grant the role to JDOEN.
grant itam_user to JDOEN;
--Replace JDOEN with the name of JDOEN that you created.
--JDOEN must be different from JDOE who was granted privileges to the 
--data in the ITAM tables directly in EX 4 Task 5. 

/*Once you have granted the role itam_user to JDOEN, connect to your Oracle 
cloud instance as ADMIN and run the following select command that retrieves 
information from the system view dba_role_privs. Take a screenshot of the 
command and results for your deliverable document.*/ 


--Trinity Klein
--Connected as cloud admin
--EX 4 Task 8
select * from dba_role_privs where grantee = 'JDOEN';
--Replace USERNAME with the name of JDOEN.


/* Task 9. Check Privs in DBA_TAB_PRIVS System View 
Logged in as ADMIN, select from the system view dba_tab_privs to see if 
JDOEN has been granted privileges to any of the individual ITAM tables.*/

--Trinity Klein
--Connected as cloud admin
--EX 4 Task 9
select grantee,owner,table_name,grantor,privilege
from dba_tab_privs where grantee = 'JDOEN'
order by table_name;
--Replace USERNAME with the name of the user to whom you granted the role.
--Note that granting a user privileges through a role does not mean the user
--is granted privileges to the table directly.


/* EX 4 Task 10. Test JDOEN's Privileges Set Through the Role
Connect to your Oracle cloud instance as JDOEN. Redo the 6 commands of Task 6 
to verify that JDOEN has been granted privileges that allow it to create, 
retrieve, change, and delete data in the tables owned by user ITAM.*/

--Trinity Klein
--Connected as jdoen
--EX 4 Task 10 Command 1
insert into tlklein.department values ('SWE','Software Engineers');

--Trinity Klein
--Connected as jdoen
--EX 4 Task 10 Command 2
select * from tlklein.department where dept_code = 'SWE';

--Trinity Klein
--Connected as jdoen
--EX 4 Task 10 Command 3
update tlklein.department set dept_name = 'Software Developers' where dept_code = 'SWE';

--Trinity Klein
--Connected as jdoen
--EX 4 Task 10 Command 4
select * from tlklein.department where dept_code = 'SWE';

--Trinity Klein
--Connected as jdoen
--EX 4 Task 10 Command 5
delete from tlklein.department where dept_code = 'SWE';

--Trinity Klein
--Connected as jdoen
--EX 4 Task 10 Command 6
select * from tlklein.department where dept_code = 'SWE';


/* EX 4 Task 11. Do Some Research
You should have been able to verify that both JDOE and JDOEN have 
privileges to create, retrieve, change, and destroy data in the ITAM schema 
tables? JDOE was granted privileges directly to the tables and JDOEN 
was granted privileges through the role itam_user. Do research to answer (in a 
very short paragraph that demonstrates professional writing skill) the question,
"If a user is granted table privileges directly through a grant to those tables,
is this level of privilege equivalent to granting a table privilege through a
role?"  */

--Trinity Klein
--EX 4 Task 11
/* 
When a user is directly granted table privileges, like select, insert, update, 
and delete, on the table, these privileges apply immediately. However, if the 
same privileges are granted via a role, the user must log in again to activate 
the role. Both methods will grant the same privileges by having key differences.
Direct privileges have immediate access without having to log in again but will 
not automatically allow the creation of objects. Role-based privileges are 
convenient for managing multiple users but will not inherently grant object 
creation privileges. The user will need direct privileges to implement object 
creation. 
/*

/* Task 12. JDOE Creates a View
Connect to your Oracle cloud instance as JDOE (s user whose name you chose).
Attempt to create a view on the tables of the ITAM schema. The base query 
of your view does not have to be complex. There are no points added for query 
complexity. */

--Trinity Klein
--Connected as itam_jdoe
--EX 4 Task 12
create view employee
as
select * from tlklein.employee;


/* Task 13. Use the JDOE View
If the view creation was successful, write and run a command to use the view. 
That is, write a command to retrieve data through the view.*/

--Trinity Klein
--Connected as JDOE -- replace with the name of youruser
--EX 4 Task 13
select * from employee;



/* EX 4 Task 14. JDOEN Creates a View
Connect to your Oracle cloud instance as JDOEN. Attempt to create the same 
view as JDOE created in Task 12.*/

--Trinity Klein
--Connected as JDOEN
--EX 4 Task 14
create view employee
as
select * from tlklein.employee;


/* Task 15. Do Some Research
Do some research to see how the privileges of JDOEN could be 
upgraded so that the user can successfully create the view of Task 9. Write a 
very brief explanation.*/

--Trinity Klein
--Ex 4 Task 15 When Can a User who is not Owner Create a View?
/*
To create a view in another user's schema, the user must have the create any 
view privilege. For creating a subview, the user must have either the under any 
view system privilege or the under object privilege on the super view.
*/



