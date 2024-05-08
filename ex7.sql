/* EX 7 Database and Query Performance*/


/* Connect to your IT asset management schema in the cloud by connecting as the 
user who owns the IT asset managment tables. Create a table based on principles 
of denormalization applied to tables of the IT asset management schema (I will
talk about denormalization in class). If you already created this table while 
following along in class, you do not have to recreate it. */

/* This SQL command creates a denormalized table that combines the columns 
from asset_desc with the columns of ci_inventory. The result is a denormalized
schema with redundant data in the new table. We will explore whether redundancy
slows performance of queries. */

CREATE TABLE asset_inventory_tlklein(
  ASSET_DESC_ID NUMBER(10),
  ASSET_MAKE VARCHAR2(50),
  ASSET_MODEL VARCHAR2(50),
  ASSET_EXT VARCHAR2(100),
  ASSET_TYPE_DESC VARCHAR2(50),
  APPL_INST_VERSION VARCHAR2(10),
  APPL_DETAILS VARCHAR2(100),
  COMPUTER_CPU_DETAILS VARCHAR2(100),
  GRAPHICS VARCHAR2(50),
  VOL_MEMORY VARCHAR2(25),
  STORAGE_TYPE VARCHAR2(50),
  STORAGE_CAPACITY VARCHAR2(10),
  DISPLAY VARCHAR2(20),
  BI_DISPLAY_DETAILS VARCHAR2(120),
  SERVER_CPU_DETAILS VARCHAR2(100),
  SERVER_VOL_MEMORY VARCHAR2(25),
  SERVER_STORAGE_TYPE VARCHAR2(50),
  SERVER_STORAGE_CAPACITY VARCHAR2(10),
  SERVICE_DETAILS VARCHAR2(200),
  PERIPHERAL_DETAILS VARCHAR2(200),
  OTHER_DESC VARCHAR2(100),
  OTHER_DETAILS VARCHAR2(100),
  CI_INV_ID NUMBER(10),
  PURCHASE_OR_RENTAL CHAR(8),
  UNIQUE_ID VARCHAR2(50),
  CI_ACQUIRED_DATE DATE,
  CI_STATUS_DESCRIPTION VARCHAR2(50),
  CI_STATUS_DATE DATE,
  USE_OR_SUPPORT CHAR(8),
  DATE_ASSIGNED DATE,
  DATE_UNASSIGNED DATE,
  FIRST_NAME VARCHAR2(100),
  LAST_NAME VARCHAR2(100),
  LASTFOUR_SSN CHAR(4),
  CO_MOBILE VARCHAR2(12),
  CO_EMAIL VARCHAR2(100),
  JOB_TITLE VARCHAR2(200),
  DEPT_NAME VARCHAR2(50)
);


/* Task 1 Verify Creating a Denormalized Table.
Verify the creation of the denormalized table in your schema by running the 
following query modified so that it retrieves your table information. Capture a 
screenshot of the query and the result set.*/

--Trinity Klein
--EX 7 Task 1 Verify Creating a Denormalized Table
--Logged into Cloud Server as Your ITAM Owner User
select owner, table_name,tablespace_name from all_tables 
where owner = 'TLKLEIN';--Replace ITAM_OWNER with your ITAM owner user
--Scroll down in the results (as needed) to get an accurate number of 
--rows retrieved and also make sure I can see the new table
--(ASSET_INVENTORY_TLKLEIN)in your screenshot of the results.


/*Task 2 Write a Query to Retrieve Data to (Eventually) Fill the Denormalized Table. 
Write a query that retrieves from the tables in the  normalized IT asset
management schema. The data retrieved must matche the columns of the
denormalizaed version of the table that you created in your own schema. Maximize
the amount of data retrieved by using full outer joins in your query. */

--Trinity Klein
-- EX 7 Task 2 Write a Query to Retrieve Data to (Eventually) Fill the Denormalized Table.
--Logged into Cloud Server as Your ITAM Owner User
SELECT
  ad.ASSET_DESC_ID,
  ad.ASSET_MAKE,
  ad.ASSET_MODEL,
  ad.ASSET_EXT,
  at.ASSET_TYPE_DESC,
  app.APPL_INST_VERSION,
  app.APPL_DETAILS,
  comp.CPU_DETAILS,
  comp.GRAPHICS,
  comp.VOL_MEMORY,
  comp.STORAGE_TYPE,
  comp.STORAGE_CAPACITY,
  comp.DISPLAY,
  comp.BI_DISPLAY_DETAILS,
  serv.CPU_DETAILS,
  serv.VOL_MEMORY,
  serv.STORAGE_TYPE,
  serv.STORAGE_CAPACITY,
  its.SERVICE_DETAILS,
  per.PERIPHERAL_DETAILS,
  oth.OTHER_DESC,
  oth.OTHER_DETAILS,
  ci.CI_INV_ID,
  ci.PURCHASE_OR_RENTAL,
  ci.UNIQUE_ID,
  ci.CI_ACQUIRED_DATE,
  cis.CI_STATUS_DESCRIPTION,
  ci.CI_STATUS_DATE,
  eci.USE_OR_SUPPORT,
  eci.DATE_ASSIGNED,
  eci.DATE_UNASSIGNED,
  emp.FIRST_NAME,
  -- submitted by trinity klein
  emp.LAST_NAME,
  emp.LASTFOUR_SSN,
  emp.CO_MOBILE,
  emp.CO_EMAIL,
  emp.JOB_TITLE,
  dept.DEPT_NAME
FROM
  ASSET_DESC ad
  FULL OUTER JOIN ASSET_TYPE at ON ad.ASSET_TYPE_ID = at.ASSET_TYPE_ID
  FULL OUTER JOIN APPLICATION app ON ad.ASSET_DESC_ID = app.ASSET_DESC_ID
  FULL OUTER JOIN COMPUTER comp ON ad.ASSET_DESC_ID = comp.ASSET_DESC_ID
  FULL OUTER JOIN SERVER serv ON ad.ASSET_DESC_ID = serv.ASSET_DESC_ID
  FULL OUTER JOIN IT_SERVICE its ON ad.ASSET_DESC_ID = its.ASSET_DESC_ID
  FULL OUTER JOIN PERIPHERAL per ON ad.ASSET_DESC_ID = per.ASSET_DESC_ID
  FULL OUTER JOIN OTHER oth ON ad.ASSET_DESC_ID = oth.ASSET_DESC_ID
  FULL OUTER JOIN CI_INVENTORY ci ON ad.ASSET_DESC_ID = ci.ASSET_DESC_ID
  FULL OUTER JOIN CI_STATUS cis ON ci.CI_STATUS_CODE = cis.CI_STATUS_CODE
  FULL OUTER JOIN EMPLOYEE_CI eci ON ci.CI_INV_ID = eci.CI_INV_ID
  FULL OUTER JOIN EMPLOYEE emp ON eci.EMP_ID = emp.EMP_ID
  FULL OUTER JOIN DEPARTMENT dept ON emp.DEPT_CODE = dept.DEPT_CODE;
  
  
/* Task 3 Understand the Meaning of Rows with No Value for ci_inv_id
Notice that there are some rows retrieved that have no value for ci_inv_id. 
Since the old ci_inv_id is to become the new asset_inv_id in the denormalized 
table, these incomplete rows must either not be retrieved or they must be given
a value for ci_inv_id. Before deciding which is the best course of action, you 
must answer the question, "What is the meaning of the rows of data that have no 
value for ci_inv_id?" That is, describe in a business sense the data that exists
in the original tables but that may be removed throught the denormalization
process. If the data is "important" in a business sense, then removing the data 
is not a good idea. */

--Trinity Klein
--EX 7 Task 3 Answer the Question and Make a Decision About What to Do
/* Answer the question, "What is the meaning of the rows of data that have no 
value for ci_inv_id?
Make a decision whether you will remove the data that has no ci_inv_id or 
whether you will provide these rows with a value for ci_ivn_id, and explain
why.
Note* Your answer should address the issues from a business meaning perspective. */
/* The rows that have no value for ci_inv_id most likely represent asset 
descriptions or cofigurations that are not current associated with any ci 
in the inventory. These rows still contain information about the type of assests,
descriptions, models, and technical specifications but just are not linked to a 
physical or virtual asset. 
In business, these rows would represent the master data or available asset types,
models, and cis that the organization supports or a some knowledge of. This 
data is still important because it provides a reference for the oranization to 
understand the various assets they have or may manage. 
Removing those rows from the denormalization table could result in losing valuable
reference data about the different types of assets the organization is capable 
of managing. Therefore, it would be better, as a business to generate information that
fills in the gaps of the missing information in the cis. /*



/* Task 4 Modify the Task 2 Query to Either (a) Eliminate Incomplete Data
or (b) to Generate Values for the Missing ci_in_id Values */
--How many rows are there that do not have ci_inv_id values?

--Trinity Klein
-- EX 7 Task 4b Modify the Task 2 Query to Generate Values for the Missing ci_in_id Values.
--Logged into Cloud Server as Your ITAM Owner User
DROP SEQUENCE ci_inv_id_seq;
SELECT MAX(CI_INV_ID) FROM CI_INVENTORY;
CREATE SEQUENCE ci_inv_id_seq START WITH 10000;

SELECT
  ad.ASSET_DESC_ID,
  ad.ASSET_MAKE,
  ad.ASSET_MODEL,
  ad.ASSET_EXT,
  at.ASSET_TYPE_DESC,
  app.APPL_INST_VERSION,
  app.APPL_DETAILS,
  comp.CPU_DETAILS,
  comp.GRAPHICS,
  comp.VOL_MEMORY,
  comp.STORAGE_TYPE,
  comp.STORAGE_CAPACITY,
  comp.DISPLAY,
  comp.BI_DISPLAY_DETAILS,
  serv.CPU_DETAILS,
  serv.VOL_MEMORY,
  serv.STORAGE_TYPE,
  serv.STORAGE_CAPACITY,
  its.SERVICE_DETAILS,
  per.PERIPHERAL_DETAILS,
  oth.OTHER_DESC,
  oth.OTHER_DETAILS,
  NVL(ci.CI_INV_ID, ci_inv_id_seq.NEXTVAL) AS CI_INV_ID,
  ci.PURCHASE_OR_RENTAL,
  ci.UNIQUE_ID,
  ci.CI_ACQUIRED_DATE,
  cis.CI_STATUS_DESCRIPTION,
  ci.CI_STATUS_DATE,
  eci.USE_OR_SUPPORT,
  eci.DATE_ASSIGNED,
  eci.DATE_UNASSIGNED,
  --submitted by trinity klein  
  emp.FIRST_NAME,
  emp.LAST_NAME,
  emp.LASTFOUR_SSN,
  emp.CO_MOBILE,
  emp.CO_EMAIL,
  emp.JOB_TITLE,
  dept.DEPT_NAME
FROM
  ASSET_DESC ad
  FULL OUTER JOIN ASSET_TYPE at ON ad.ASSET_TYPE_ID = at.ASSET_TYPE_ID
  FULL OUTER JOIN APPLICATION app ON ad.ASSET_DESC_ID = app.ASSET_DESC_ID
  FULL OUTER JOIN COMPUTER comp ON ad.ASSET_DESC_ID = comp.ASSET_DESC_ID
  FULL OUTER JOIN SERVER serv ON ad.ASSET_DESC_ID = serv.ASSET_DESC_ID
  FULL OUTER JOIN IT_SERVICE its ON ad.ASSET_DESC_ID = its.ASSET_DESC_ID
  FULL OUTER JOIN PERIPHERAL per ON ad.ASSET_DESC_ID = per.ASSET_DESC_ID
  FULL OUTER JOIN OTHER oth ON ad.ASSET_DESC_ID = oth.ASSET_DESC_ID
  FULL OUTER JOIN CI_INVENTORY ci ON ad.ASSET_DESC_ID = ci.ASSET_DESC_ID
  FULL OUTER JOIN CI_STATUS cis ON ci.CI_STATUS_CODE = cis.CI_STATUS_CODE
  FULL OUTER JOIN EMPLOYEE_CI eci ON ci.CI_INV_ID = eci.CI_INV_ID
  FULL OUTER JOIN EMPLOYEE emp ON eci.EMP_ID = emp.EMP_ID
  FULL OUTER JOIN DEPARTMENT dept ON emp.DEPT_CODE = dept.DEPT_CODE;


/* Task 5 Create a View from the Task 4 Query.
Turn the Task 4 query into a view and document your creation of the view in 
your own schema.  */

--Trinity Klein
--EX 7 Task 5 Create a View from the Task 4 Query
--Logged into Cloud Server as Your ITAM Owner User
CREATE OR REPLACE FUNCTION get_next_ci_inv_id
RETURN NUMBER
IS
  next_id NUMBER;
BEGIN
  SELECT ci_inv_id_seq.NEXTVAL INTO next_id FROM dual;
  RETURN next_id;
END;
/

CREATE OR REPLACE VIEW combine_table_data_itam_tlklein AS
SELECT
  ad.ASSET_DESC_ID,
  ad.ASSET_MAKE,
  ad.ASSET_MODEL,
  ad.ASSET_EXT,
  at.ASSET_TYPE_DESC,
  app.APPL_INST_VERSION,
  app.APPL_DETAILS,
  comp.CPU_DETAILS AS COMPUTER_CPU_DETAILS,
  comp.GRAPHICS,
  comp.VOL_MEMORY,
  comp.STORAGE_TYPE,
  comp.STORAGE_CAPACITY,
  comp.DISPLAY,
  comp.BI_DISPLAY_DETAILS,
  serv.CPU_DETAILS AS SERVER_CPU_DETAILS,
  serv.VOL_MEMORY AS SERVER_VOL_MEMORY,
  serv.STORAGE_TYPE AS SERVER_STORAGE_TYPE,
  serv.STORAGE_CAPACITY AS SERVER_STORAGE_CAPACITY,
  its.SERVICE_DETAILS,
  per.PERIPHERAL_DETAILS,
  oth.OTHER_DESC,
  --submitted by trinity klein  
  oth.OTHER_DETAILS,
  NVL(ci.CI_INV_ID, get_next_ci_inv_id()) AS CI_INV_ID,
  ci.PURCHASE_OR_RENTAL,
  ci.UNIQUE_ID,
  ci.CI_ACQUIRED_DATE,
  cis.CI_STATUS_DESCRIPTION,
  ci.CI_STATUS_DATE,
  eci.USE_OR_SUPPORT,
  eci.DATE_ASSIGNED,
  eci.DATE_UNASSIGNED,
  emp.FIRST_NAME,
  emp.LAST_NAME,
  emp.LASTFOUR_SSN,
  emp.CO_MOBILE,
  emp.CO_EMAIL,
  emp.JOB_TITLE,
  dept.DEPT_NAME
FROM
  ASSET_DESC ad
  INNER JOIN ASSET_TYPE at ON ad.ASSET_TYPE_ID = at.ASSET_TYPE_ID
  LEFT JOIN APPLICATION app ON ad.ASSET_DESC_ID = app.ASSET_DESC_ID
  LEFT JOIN COMPUTER comp ON ad.ASSET_DESC_ID = comp.ASSET_DESC_ID
  LEFT JOIN SERVER serv ON ad.ASSET_DESC_ID = serv.ASSET_DESC_ID
  LEFT JOIN IT_SERVICE its ON ad.ASSET_DESC_ID = its.ASSET_DESC_ID
  LEFT JOIN PERIPHERAL per ON ad.ASSET_DESC_ID = per.ASSET_DESC_ID
  LEFT JOIN OTHER oth ON ad.ASSET_DESC_ID = oth.ASSET_DESC_ID
  INNER JOIN CI_INVENTORY ci ON ad.ASSET_DESC_ID = ci.ASSET_DESC_ID
  INNER JOIN CI_STATUS cis ON ci.CI_STATUS_CODE = cis.CI_STATUS_CODE
  LEFT JOIN EMPLOYEE_CI eci ON ci.CI_INV_ID = eci.CI_INV_ID
  LEFT JOIN EMPLOYEE emp ON eci.EMP_ID = emp.EMP_ID
  LEFT JOIN DEPARTMENT dept ON emp.DEPT_CODE = dept.DEPT_CODE;
  
/* Verify your completion of Task 5 by running the following query modified so 
that it retrieves your view information. Capture a screenshot of the query
and the result set.*/

--Trinity Klein
--EX 7 Task 5 Create a View
--Logged into Class Server as Your User
SELECT view_name, text
FROM user_views
WHERE view_name = 'COMBINE_TABLE_DATA_ITAM_TLKLEIN';


/*Task 6. Insert Data into the Denormalized Table
Now use the view in an insert into statement to populate the
asset_inventory_yourusername table (the new one) in your schema with all the 
data available in the normalized tables asset_desc, ci_inventory, ci_status,
and asset_type. */

/* Here is a sample insert into statement that selects all the data to be 
inserted into your new table from the view and then inserts that data into 
your new denormalized table.*/
INSERT INTO asset_inventory_tlklein
SELECT
  ASSET_DESC_ID,
  ASSET_MAKE,
  ASSET_MODEL,
  ASSET_EXT,
  ASSET_TYPE_DESC,
  APPL_INST_VERSION,
  APPL_DETAILS,
  COMPUTER_CPU_DETAILS,
  GRAPHICS,
  VOL_MEMORY,
  STORAGE_TYPE,
  STORAGE_CAPACITY,
  DISPLAY,
  BI_DISPLAY_DETAILS,
  SERVER_CPU_DETAILS,
  SERVER_VOL_MEMORY,
  SERVER_STORAGE_TYPE,
  SERVER_STORAGE_CAPACITY,
  SERVICE_DETAILS,
  PERIPHERAL_DETAILS,
  OTHER_DESC,
  OTHER_DETAILS,
  CI_INV_ID,
  PURCHASE_OR_RENTAL,
  UNIQUE_ID,
  CI_ACQUIRED_DATE,
  CI_STATUS_DESCRIPTION,
  CI_STATUS_DATE,
  USE_OR_SUPPORT,
  DATE_ASSIGNED,
  DATE_UNASSIGNED,
  FIRST_NAME,
  LAST_NAME,
  LASTFOUR_SSN,
  CO_MOBILE,
  CO_EMAIL,
  JOB_TITLE,
  DEPT_NAME
FROM
  combine_table_data_itam_tlklein;

commit;


--Gather the db statistics for the table
exec dbms_stats.gather_table_stats('TLKLEIN', 'ASSET_INVENTORY_TLKLEIN');



/* Verify Task 6 completion by  running the the command provided - modified to 
retrieve your information. Capture the command and the results in a screenshot.*/

--Trinity Klein
--Logged into Cloud Server as Your ITAM Owner User
--EX 7 Task 6 Verify the Insert of Data into the Denormalized Table
select owner,table_name, num_rows from all_tables
where table_name like '%ASSET_INVENTORY_TLKLEIN%';



/* Task 7 Verify Comparable Indexes.
Before running queries to capture execution times in order to compare the 
performance of the normalized version of the tables to the denormalized version,
you want the comparison to be valid in terms of indexes (if any of the source 
normalized tables are indexed you want the denormalized table to be 
similarly indexed, too). Thus, you should create indexes on your denormalized 
table to match any indexes that exist on any of the source normalized tables 
(asset_desc, ci_inventory, asset_type, ci_status). You could also, alternatively, 
remove indexes from the source tables (the ones in the cloud) except for indexes 
created when the PKs were created (Oracle uses indexes to enforce the uniqueness 
requirement of a PK). To verify equivalent indexes, modify the command below for
your user owner of the ITAM table and capture a screenshot of the command and result. */

--Trinity Klein
--Logged into Cloud Server as Your ITAM Owner User
--EX 7 Task 7 Verify Comparable Indexes
CREATE INDEX index_name ON asset_inventory_tlklein (
    ASSET_DESC_ID,
    ASSET_MODEL,
    ASSET_MAKE,
    ASSET_EXT,
    CI_INV_ID,
    CI_STATUS_DESCRIPTION
);

SELECT index_name, table_name, column_name
FROM user_ind_columns
WHERE table_name IN (
    'ASSET_DESC', 
    'CI_INVENTORY', 
    'ASSET_TYPE', 
    'CI_STATUS'
);
-- the result should show only indexes associated with
--table PKs, except for an index on asset_desc which may have a unique constraint 
--on the composite of asset_desc_id and asset_type_id





/* Task 8 Run a Query against the Normalized Tables.
In EX 3 Tasks 1 through 6, you wrote queries for several business purposes. 
Choose one query you wrote for any one of Tasks 1 through 6 of EX 3 to use for 
this Task 8. The query you choose must involve a join of the asset_desc table to 
the ci_inventory table. Also, check the feedback I provided for EX 3 to make sure
you choose to use a query that is correctly constructed.
Use a comment to make it clear for which Task of EX 3 the query you are using 
here was originally written (e.g. -- EX 3 Task 5 Query).
To the beginning of the select list of the query you have chosen to use for this
Task 8, add the verbatim selection: user as NORMALIZED. Execute the query you have
chosen using Oracle SQL Developer tool, executing it against the normalized tables 
of the IT asset management schema in the cloud.
Capture a screen shot of the query and the execution results. The result set 
should include the last row retrieved (possibly a partial row in that all 
columns need not be shown) with some of the rows above it. Make note of the 
retrieval time as reported by Oracle SQL Developer tool as All Rows Fetched: 
followed by the number of rows and how long the fetch took (for example, it shows
All Rows Fetched: 1014 in 0.15 seconds).
If you did not write any of the queries requested in Tasks 1 through 6 of EX 3, 
then you will have to write one of those queries now, execute it and make note 
of the retrieval time reported by Oracle SQL Developer tool as requested.*/

--Trinity Klein
--Logged into Cloud Server as Your ITAM Owner User
--EX 7 Task 8 Run a Query against the Normalized Tables
--(using a query for CIs assigned for support that are now unassigned)
-- Note that students must use a different query.
--Students are given a choice of Tasks 1 through 6 from EX 4. 
--Just make sure it is not the one shown below since that is the one we did in 
--class.
-- EX 3 Task 4 Query 
SELECT user as NORMALIZED, first_name, last_name, asset_make, asset_model,
 (SELECT asset_type_desc FROM asset_type at WHERE asset_type_id = d.asset_type_id) as type
FROM employee a
JOIN employee_ci b ON a.emp_id = b.emp_id
JOIN ci_inventory c ON b.ci_inv_id = c.ci_inv_id
JOIN asset_desc d ON c.asset_desc_id = d.asset_desc_id
WHERE c.ci_status_code = 'INUSE' AND a.dept_code = 'EXEC';


/*Task 9 Run a Query against the Denormalized Tables. 
Modify the query from Task 8 to retrieve the identical information except the 
first item in the select list should now be (verbatim): user as DENORMALIZED. 
Also, use your user's asset_inventory table in place of joins between any of 
the denormalized tables replaced by asset_inventory (asset_desc, ci_inventory,
asset_type, ci_status) in the original query.
Verify Task 9 completion by capturing a screenshot of the modified query and the
last ten rows of the result set it returns.*/

--Trinity Klein
--Logged into the Class Server as Your User
--EX 7 Task 9 Run a Query against the Denormalized Tables
--using Ex 3 Old Task 5 Query Sample - but you must use a different query
-- EX 3 Task 4 Query
SELECT user as DENORMALIZED, a.first_name, a.last_name, ai.asset_make, ai.asset_model,
 (SELECT asset_type_desc FROM asset_type at WHERE at.asset_type_desc = ai.asset_type_desc) as type
FROM employee a
JOIN employee_ci b ON a.emp_id = b.emp_id
JOIN ci_inventory c ON b.ci_inv_id = c.ci_inv_id
JOIN asset_inventory_tlklein ai ON c.asset_desc_id = ai.asset_desc_id
WHERE c.ci_status_code = 'INUSE' AND a.dept_code = 'EXEC';




/* For Tasks 10 through 13 you explain and retrieve the execution plans for the 
Task 8 query in the normalized environment and for the Task 9 query in the 
modified denormalized environment. */

/* Task 10 Explain the Plan for the Task 8 Query on the Normalized Tables.
Use the following template of commands, recording with a screen shot each 
command and its result after execution. */

--Trinity Klein
--EX 7 Task 10 Explain the Plan for the Task 8 Query on the Normalized Tables
--Logged into the Class Server as Your User
EXPLAIN PLAN FOR
SELECT user as NORMALIZED, first_name, last_name, asset_make, asset_model,
 (SELECT asset_type_desc FROM asset_type at WHERE asset_type_id = d.asset_type_id) as type
FROM employee a
JOIN employee_ci b ON a.emp_id = b.emp_id
JOIN ci_inventory c ON b.ci_inv_id = c.ci_inv_id
JOIN asset_desc d ON c.asset_desc_id = d.asset_desc_id
WHERE c.ci_status_code = 'INUSE' AND a.dept_code = 'EXEC';


/* Task 10. Once the plan has been explained, retrieve the plan data from the 
buffer where it is saved (temporarily). */

--Trinity Klein
--EX 7 Task 10 Retrieve the Plan for the Task 8 Query on the Normalized Tables
--Logged into Cloud Server as Your ITAM Owner User
select plan_table_output from table(dbms_xplan.display());



/* Task 11 Explain the Plan for the Task 9 Query on the Denormalized Tables.
Using the following template of commands, record with with a screen shot each 
command and its result after execution. */

--Trinity Klein
--Logged into Cloud Server as Your ITAM Owner User
--EX 7 Task 11 Explain the plan for the Task 9 Query on the Denormalized Tables
--the query from task 9 that is against your denormalized ITAM tables
EXPLAIN PLAN FOR
SELECT user as DENORMALIZED, a.first_name, a.last_name, ai.asset_make, ai.asset_model,
 (SELECT asset_type_desc FROM asset_type at WHERE at.asset_type_desc = ai.asset_type_desc) as type
FROM employee a
JOIN employee_ci b ON a.emp_id = b.emp_id
JOIN ci_inventory c ON b.ci_inv_id = c.ci_inv_id
JOIN asset_inventory_tlklein ai ON c.asset_desc_id = ai.asset_desc_id
WHERE c.ci_status_code = 'INUSE' AND a.dept_code = 'EXEC';


/* Task 11. Once the plan has been explained, retrieve the 
plan data from the buffer where it is saved (temporarily). */


--EX 7 Task 11 Retrieve the Plan for the Task 9 Query on the Denormalized Tables
--Logged into Cloud Server as Your ITAM Owner User
select plan_table_output from table(dbms_xplan.display());



/* Note* Run the Task 8  and 9 queries now (again) if you 
completed Task 8 and 9 in a different log in session prior. */

/* Task 12 Verify Privileges. Logged into the class server, 
verify you have been granted access to the v$sql system view.*/
--Trinity Klein
--Logged into Cloud Server as Your ITAM Owner User
--EX 7 Task 12 Verify Privileges
select  * from v$sql; 
--being able to run this w/o error verifies privs

--if you don't have privileges to select from v$sql then log in as admin to 
--grant your user the necessary privilege
GRANT SELECT ON v$sql TO TLKLEIN;
--Replace itam_owner your ITAM owner user





/* Task 13 CPU Time for the Task 8 Query. Retrieve the cpu execution time and the 
elapsed time in microseconds for the Task 8 query. 
Modify the following command and run it. Verify Task 13 completion by capturing 
a screen shot of the command and its result set.*/

--Trinity Klein
--EX 7 Task 13 CPU Time for the Task 8 Query
--Logged into Cloud Server as Your ITAM Owner User
select sql_id,parsing_schema_name,
rows_processed,cpu_time,elapsed_time,sql_fulltext from v$sql where
upper(sql_fulltext) like 'SELECT USER AS NORMAL%'
and parsing_schema_name like 'TLKLEIN';


/* Task 14 CPU Time for the Task 8 and Task 9 Query. 
Retrieve the cpu execution time and the elapsed time in microseconds for the 
Task 9 query. Modify the following command and run it. Verify Task 14 completion
by capturing a screen shot of the command and its result set.*/

--Trinity Klein
--EX 7 Task 14 CPU Time for the Task 8 and Task 9 Query
--Logged into Cloud Server as Your ITAM Owner User
select sql_id,parsing_schema_name,rows_processed,cpu_time,elapsed_time,
sql_fulltext 
from v$sql where
upper(sql_fulltext) like 'SELECT USER AS NORMAL%' 
or upper(sql_fulltext) like 'SELECT USER AS DENORMAL%'
and parsing_schema_name like 'TLKLEIN';



/* Task 15 Compare Denormalized to Normalized. 
Trinity Klein
Discuss your results from Tasks 10, 11, and 14. 
Does it appear that denormalization improves the performance of the query? 
Explain.
Based on the results for Task 10, 11, and 14, I compared the performance
of denormalized and nommalized queries. There seems to be faster 
performance in terms of query execution and resource utilization for denormalized
tables. However, the normalized schemea also seems to provide similar performance
while having better data integrity and scalability.  

Thus, because of the nature of the itam asset management data, it seems that
normalized may be a better option in order to keep data integrity. But, if 
performance is a key and very important issue then, denormalized will be 
preferrable.
*/


