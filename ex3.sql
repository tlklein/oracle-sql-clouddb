/* EX 3 Queries for a Business Purpose */

/*Connect to the class server using your assigned username to complete the
tasks.*/

/* For each task of EX 3, do not get data from the it_asset_inv_summary table 
unless the task specifically asks you to do so. */




/*  Task 1. Retrieve the employee name, asset description (asset make and model),
and dates assigned and unassigned, for all assets assigned to an employee for use
before XX AM in the MONTH and DD of YYYY, and that are no longer assigned for use 
by the same employee. When you retrieve date values, display the time value 
associated with the date as well as the date value (use the to_char function). 
Choose your own value of XX, your own value for MONTH, your own value for DD, and
your own value for YYYY. Hard code your personal chosen date/time value to be 
compared to in the where clause and make sure your query returns at least one 
row. 
Note from IT boss: Be aware that the derived information in the 
it_asset_inv_summary table is not kept up to date in an automated way, so use 
only data from other tables. */

--Task 1 Assets Assigned for Use Before a Specific Date/Time Value and No Longer Assigned
--Trinity Klein
select first_name, last_name, asset_make, asset_model, date_assigned, date_unassigned, ci_status_code
from jaherna42.employee a
join jaherna42.employee_ci b on a.emp_id = b.emp_id
join jaherna42.ci_inventory c on b.ci_inv_id = c.ci_inv_id
join jaherna42.asset_desc d on c.asset_desc_id = d.asset_desc_id
where TO_DATE('20-02-2024', 'DD-MM-YYYY') > date_assigned and 
date_unassigned is not null and ci_status_code != 'INUSE'
order by date_assigned, date_unassigned;

/* Task 2. Retrieve the employee name, asset description (asset make and model),
and date assigned, for all assets assigned to an employee for use where the 
assignment happened on a specific date of your choosing and where the asset is 
still assigned to the employee for use. When you retrieve date values,
display the time value associated with the date as well as the date value. 
Your query must retrieve all rows for the specific date, regardless of the time 
the assignment got recorded on that date. Hint* Use the trunc function in the 
where clause so that all matching dates are retrieved regardless of their time 
parts. Your query must return at least one row.
Note from IT boss: Be aware that the derived information in the 
it_asset_inv_summary table is not kept up to date in an automated way, so use 
only data from other tables. */

--Task 2 Assets Assigned for Use on a Specific Date and Still Assigned
--Trinity Klein 
select first_name, last_name, asset_make, asset_model, date_assigned, date_unassigned, ci_status_code
from jaherna42.employee a
join jaherna42.employee_ci b on a.emp_id = b.emp_id
join jaherna42.ci_inventory c on b.ci_inv_id = c.ci_inv_id
join jaherna42.asset_desc d on c.asset_desc_id = d.asset_desc_id
where date_assigned = TO_DATE('16-02-2024', 'DD-MM-YYYY') and 
date_assigned is not null and ci_status_code = 'INUSE'
order by date_unassigned, date_assigned;


/* Task 3. An Accounting manager says, "I think some of my department employees
have several computers they are using. For security reasons, I do not want them
to have more than one computer they use for work. I need a list of employees in 
my department and all the computers they are assigned for work regardless of what
type of computer it is. I do not want to know about company cell phones they are
using. I want the make, model, and serial number information, with all the CIs 
for each employee together. 
Note from IT boss: Be aware that the derived information in the 
it_asset_inv_summary table is not kept up to date in an automated way, so use 
only data from other tables.  */

--Task 3 Employees with More than One Computer Assigned
--Trinity Klein
select first_name, last_name, asset_make, asset_model, asset_ext
    ,count(*) over (partition by asset_make, a.emp_id) as count
from jaherna42.employee a
join jaherna42.employee_ci b on a.emp_id = b.emp_id
join jaherna42.ci_inventory c on b.ci_inv_id = c.ci_inv_id
join jaherna42.asset_desc d on c.asset_desc_id = d.asset_desc_id
where dept_code = 'ACCT' and asset_type_id != 4 and asset_type_id != 3
and asset_type_id != 11 and asset_type_id != 12 and asset_type_id != 13 
and asset_type_id != 14 and asset_type_id != 1 and asset_type_id != 3 
and asset_type_id != 5 and asset_type_id != 6 and asset_type_id != 7 
and ci_status_code = 'INUSE'
order by last_name, first_name;



/* Task 4. Your manager says, "I would like a report with a list of descriptions 
of different IT assets we have in our system that are signed out to an employee 
in the Executive area who is using the asset to do their job. I need to know the 
name of the executive as well as the make and model of the asset and what type 
of asset it is. Is it a computer or a tablet, is it software, or is it something
else?" 
Note from IT boss: Be aware that the derived information in the 
it_asset_inv_summary table is not kept up to date in an automated way, so use 
only data from other tables. */

--Task 4 Asset Description for Assets in Use by an Executive Someone
--Trinity Klein (there could be variation in which columns are selected)
select first_name, last_name, asset_make, asset_model,
 (select asset_type_desc from jaherna42.asset_type where asset_type_id = d.asset_type_id) as type
from jaherna42.employee a
join jaherna42.employee_ci b on a.emp_id = b.emp_id
join jaherna42.ci_inventory c on b.ci_inv_id = c.ci_inv_id
join jaherna42.asset_desc d on c.asset_desc_id = d.asset_desc_id
where ci_status_code = 'INUSE' and dept_code = 'EXEC';


/* Task 5. Your manager says, "Now I would like to know how many Dell
or Samsung computers (desktops, tablets, laptops) are currently being used by 
employees in Sales or in Marketing. I want description information for which 
department and the make, model, and extended information for each different 
Dell or Samsung computer with a count of how many of each. And, of course, I 
don't want information about computers or employees that are gone (disposed of 
or terminated)." 
Note from IT boss: Be aware that the derived information in the 
it_asset_inv_summary table is not kept up to date in an automated way, so use 
only data from other tables. */


--Task 5 How Many Dell and Samsung Computers Used in Sales or Marketing
--Trinity Klein
select dept_code, asset_make, asset_model, asset_ext
    ,count(*) over (partition by dept_code, asset_make) as count
from jaherna42.employee a
join jaherna42.employee_ci b on a.emp_id = b.emp_id
join jaherna42.ci_inventory c on b.ci_inv_id = c.ci_inv_id
join jaherna42.asset_desc d on c.asset_desc_id = d.asset_desc_id
where (dept_code <> 'ADMIN' and dept_code <> 'RANDD' and dept_code <> 'ACCT' and 
dept_code <> 'CSLT' and dept_code <> 'IT' and dept_code <> 'FIN' and 
dept_code <> 'EDU' and dept_code <> 'TECSOL' and dept_code <> 'PR' and 
dept_code <> 'LOGTRAN' and dept_code <> 'EXADMIN' and dept_code <> 'ITSEC' and 
dept_code <> 'ITHS' and dept_code <> 'Dept123' and dept_code <> 'Dept125' and 
dept_code <> 'ITHELP' and dept_code <> 'BAG' and dept_code <> 'HR' and 
dept_code <> 'EXEC' and dept_code <> 'CUST' and dept_code <> 'PHYS' 
and dept_code <> 'IT') and (ci_status_code = 'INUSE') and (asset_make  = 'Dell' or asset_make = 'Samsung')
order by dept_code, asset_make;


/* Task 6. Your manager says, "Now for the list of how many Dells
or Samsung computers are currently being used by employees in Sales or 
Marketing that you just created, add rows that show the total 
numbers of each make for each department." 
Note from IT boss: Be aware that the derived information in the 
it_asset_inv_summary table is not kept up to date in an automated way, so use 
only data from other tables. */

--Task 6 Hewlett Packard and Samsung Computers Used in Accounting or HR
--Trinity Klein
select dept_code, asset_make, asset_model, asset_ext
    ,count(*) over (partition by dept_code, asset_make) as count
from jaherna42.employee a
join jaherna42.employee_ci b on a.emp_id = b.emp_id
join jaherna42.ci_inventory c on b.ci_inv_id = c.ci_inv_id
join jaherna42.asset_desc d on c.asset_desc_id = d.asset_desc_id
where (dept_code <> 'ADMIN' and dept_code <> 'RANDD' and dept_code <> 'MARK' and 
dept_code <> 'CSLT' and dept_code <> 'IT' and dept_code <> 'FIN' and 
dept_code <> 'EDU' and dept_code <> 'TECSOL' and dept_code <> 'PR' and 
dept_code <> 'LOGTRAN' and dept_code <> 'EXADMIN' and dept_code <> 'ITSEC' and 
dept_code <> 'ITHS' and dept_code <> 'Dept123' and dept_code <> 'Dept125' and 
dept_code <> 'ITHELP' and dept_code <> 'BAG' and dept_code <> 'SALES' and 
dept_code <> 'EXEC' and dept_code <> 'CUST' and dept_code <> 'PHYS' 
and dept_code <> 'IT') and (ci_status_code = 'INUSE') and 
(asset_make  = 'Hewlett Packard' or asset_make = 'Samsung' or asset_make = 'HP')
order by dept_code, asset_make;




/* ABCCo has several software apps built in-house that are shared and used by 
customers and potential customers who download one or more apps after registering
online with information that includes their location.

ABCCo wishes to track information about which download server is used the most 
by customers requesting a download. ABCCo is designing and building 
infrastructure to capture and record data about downloads. Your team is implementing 
and testing the backend for the information system being built.

There are ten download servers worldwide in different time zones. Customers are 
worldwide. The ten time zones for the servers are Africa/Lagos, Africa/Johannesburg, 
America/Chicago, America/La_Paz, America/New_York, America/Phoenix, Asia/Dubai, 
Asia/Manila, Europe/Dublin, and Europe/Prague.

Currently the download servers host 9 app versions:
app for registered customers v1.0 (regcust_app_v1.0),
app for registered customers v1.1 (regcust_app_v1.1),
app for registered customers v1.2 (regcust_app_v1.2),
app for subscription customers v1.0 (subsc_app_v1.0),
app for subscription customers v1.1 (subsc_app_v1.1),
app for subscription customers v1.2 (subsc_app_v1.2),
app for non-paying customers v1.0 (freecust_app_v1.0),
app for non-paying customers v1.1 (freecust_app_v1.1),
and app for non-paying customers v1.2 (freecust_app_v1.2)
which was recently released.

A table belonging to user JAHERNA42 holds data about app downloads. That table 
is named download. A table named customer is also created that contains 
customer information from the customer registration process. There is sample 
data in both tables.*/


/* Tasks 7 through 10 refer to the customer and download tables in the schema 
belonging to user JAHERNA42. */


/* Task 7 Most Recent App Downloads
Write a command to retrieve which app was downloaded recently, that is in 2024.
Find out when is was downloaded and the name of the customer who downloaded it. 
In a separate command, compare the time zone offset value for your time zone to 
the server time zone offset of the most recent downloaded app. A template for 
the second command is provided. */

--EX 3 Task 7 Command 1 Most Recent Downloads
--Trinity Klein
select app_code, srvr_timestamp, cust_firstname, cust_lastname
from jaherna42.download a
join jaherna42.customer b on a.cust_id = b.cust_id
where extract(year from srvr_timestamp) = 2024
order by srvr_timestamp;

--Ex3 Task 7 Command 2 Compare to Your Time Zone
--Trinity Klein 
select 'Central' as zone, tz_offset('America/Chicago')
from dual
union
select 'Most Recent App Download Zone' as zone, 
tz_offset('America/Phoenix') from dual;



/* Task 8 Time Zone Arithmetic
Subtract the most recent app download time from the current server time (as a 
timestamp with timezone value) to see what the day/time difference is between 
the two. In addition to the commands and output, write a sentence (as a comment)
to state what the data type of the difference you computed is. */

--EX 3 Task 8 Time Zone Arithmetic
--Trinity Klein
select app_code, srvr_timestamp, cust_firstname, cust_lastname
    ,(srvr_timestamp - systimestamp) as differece
from jaherna42.download a
join jaherna42.customer b on a.cust_id = b.cust_id
where extract(year from srvr_timestamp) = 2024
order by srvr_timestamp;

--The data type of the result appears to be in days then hour,
--minutes, then secounds, then militsecounds.




/* Task 9 More than One Download
Some customers have downloaded software more than once. Write a command to 
retrieve customer ids for customers who have downloaded more than two times. 
*Hint: You need a group by clause and a having clause that uses the count function, 
but you will not retrieve the count. Rather you will retrieve the customer id.*/

--EX 3 Task 9 More than One Dowload
--Trinity Klein
select a.cust_id, app_code, srvr_timestamp,cust_firstname,cust_lastname,
    count(*) over (partition by a.cust_id) as downloads
from jaherna42.download a
join jaherna42.customer b on a.cust_id = b.cust_id;
--group by a.cust_id;



/* Task 10 Time Between Earliest and Latest Download for Customers with More 
than Two Downloads
Write a query to compute the time between the earliest and latest download 
times for customers with more than two downloads. Include the customer names
in the result set. *Hint: Use the Task 9 query as a subquery with a having 
clause based on cust_id being in the result set of the Task 9 query.  */

--EX 3 Task 10 Time Between Earliest and Latest Download for Customers with More
--than Two Downloads
--Trinity Klein
select app_code, srvr_timestamp,cust_firstname,cust_lastname, a.cust_id,
    count(*) over (partition by a.cust_id) as downloads,
    a.srvr_timestamp - lag(a.srvr_timestamp)
    over (partition by b.cust_id order by a.srvr_timestamp) as diff
from jaherna42.download a
join jaherna42.customer b on a.cust_id = b.cust_id;



    













