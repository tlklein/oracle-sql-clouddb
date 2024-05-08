/* EX 5 Constraints to Support Data Integirty */


/* EX 5 Task 1. Add and Test Default Constraints to Support a Business Rule
A default constraint is added to a column to help assure domain integrity. Such 
a constraint is added using the alter table command as demonstrated in class. 
Here are three ITAM business rules that may be supported by default constraints.
(1) When a CI is first added to inventory, the acquired date should be today
and should include the current time.
(2) When a CI is first added to inventory, the status of the CI should be 
'UNAVAIL'.
(3) When a CI is first added to inventory, the status date should be today and 
should include the time.

Note that these business rules impact data in only one table of the ITAM schema.

Logged in as ITAM_USERNAME, add default constraints that support the stated 
business rules to the corresponding columns in the appropriate table of your 
ITAM_USERNAME schema. Do not change the data type of any column. After adding the 
defaults, write two more commands to demonstrate that the default constraints work 
as planned. As demonstrated in class, to test that a default constraint is working, 
you must (1) perform an insert that leaves the field where the default constraint 
is defined null (without passing a non-value by using the keyword null), and then 
(2) run a select command that selects the particular record you inserted to show 
that the default value was inserted even though no value was provided. */

--EX 5 Task 1 Command 1 Add Default Constraints to Support a Business Rule
--Trinity Klein
--Connected as itam_tlklein
alter table ci_inventory
modify ci_acquired_date default current_timestamp; 
alter table ci_inventory
modify ci_status_code default 'UNAVAIL'; 
alter table ci_inventory
modify ci_status_date default current_timestamp; 


--EX 5 Task 1 Command 2 Demonstrate the Defaults Working with Insert
--Trinity Klein
insert into ci_inventory (ci_inv_id, asset_desc_id, purchase_or_rental, 
unique_id,ci_acquired_date, ci_status_date, ci_status_code)
values (9999,900, 'PURCHASE', 'Serial No. A99423111123', default, default, default);



--EX 5 Task 1 Command 3 Demonstrate Overriding the Defaults with Insert
--Trinity Klein
insert into ci_inventory (ci_inv_id, asset_desc_id, purchase_or_rental, 
unique_id,ci_acquired_date, ci_status_date, ci_status_code) values 
(9998,901, 'PURCHASE', 'Serial No. A99423111124', sysdate, sysdate, 'AVAIL');


--EX 5 Task 1 Command 4 Demonstrate the Defaults Working with Select After Inserts
--Trinity Klein
--Connected as itam_tlklein

select * from ci_inventory where ci_inv_id = 9998;



/* EX 5 Task 2. Add and Test a Uniqueness Constraint
A unique constraint can be added to a column to help assure entity
integrity. These are added using the alter table command as demonstrated in 
class. Here are ITAM business rules that can be supported with unique constraints.
(1) Asset descriptions (comprised of three columns) are unique.
(2) Asset type descriptions are unique.
(3) Status descriptions for CIs are unique.
(4) Department names are unique.
(5) Employee company mobile phone numbers are unique.
(6) Employee company email addresses are unique.

Logged in as ITAM_USERNAME, add a unique constraint to support the first stated 
business rule. Then demonstrate that the unique constraint working to prevent "bad"
data by attempting an insert or update command that violates it. The insert or 
update should fail with an error message naming the constraint you created. You 
must also perform an insert or update command that does not violate the constraint,
to demonstrate that the constraint allows "good" data. */

--EX 5 Task 2 Command 1 - Create a Uniqueness Constraint
--Trinity Klein
--Connected as itam_tlklein
--Implementing: (1) Asset descriptions (comprised of three columns) are unique.
create index asset_id_uk on asset_desc (asset_make, asset_model, asset_ext);
alter table asset_desc add constraint uk_asset_desc 
unique(asset_make, asset_model, asset_ext) enable novalidate;

--EX 5 Task 2 Command 2 - Demonstrate the Constraint Working (Prevent "Bad" Data)
--Trinity Klein
--Implementing: (1) Asset descriptions (comprised of three columns) are unique.
insert into asset_desc(asset_desc_id, asset_type_id,asset_make,asset_model,asset_ext) 
values (3005,4,'Apple', 'Airpod 1st Gen', 'white');

--EX 5 Task 2 Command 3 - Demonstrate the Constraint Working (Allow "Good" Data)
--Trinity Klein
--Implementing: (1) Asset descriptions (comprised of three columns) are unique.
insert into asset_desc(asset_desc_id, asset_type_id,asset_make,asset_model,asset_ext) 
values (7777,2,'Apple', 'Macbook M3 Laptop', 
'Space Grey - Apple M3 Chip w/ 8BG 512SSD');


--EX 5 Task 2 Command 4 - Select the Data
--Trinity Klein
--Implementing: (1) Asset descriptions (comprised of three columns) are unique.
select * from asset_desc where asset_desc_id = '7777';



/* EX 5 Task 3. Add Check Constraints to Assure Data Integrity
A check constraint can be added to a column to help assure domain
integrity. Check constraints are added using the alter table command as 
demonstrated in class. 
Here is an ITAM business rule that can be supported with a check constraint.
(1) An employee email address should use the company domain. That is, the 
email address should end with '@abcco.com'. 

Logged in as ITAM_USERNAME, add a check constraint to the corresponding column or
set of columns in the appropriate tables of the ITAM schema to support the 
stated business rule. After adding the constraint, write one or more commands to 
demonstrate that the check constraint works to prevent "bad" data from being 
inserted and that it works to allow "good" data to be inserted. */

--EX 5 Task 3 Command Set 1 - Create a Check Constraint for Stated Rule (1)
--Trinity Klein
--Connected as itam_tlklein
/*Implementing: (1) An employee email address should use the company domain. That
is, the email address should end with 'abcco.com'. */
alter table employee
add constraint uk_emp_email 
check(co_email like '%_____%@abcco.com')
enable novalidate;

--EX 5 Task 3 Command Set 2 - Demonstrate the Constraint Working (Prevent Bad Data)
--Trinity Klein
--Connected as user_you_are_connected_as (tell me which user you are connected as) 
/* Implementing: (1) An employee email address should use the company domain. That
is, the email address should end with 'abcco.com'.  */

update employee set co_email = 'jerso@gmail.com' where emp_id = 885;
--OR
select * from employee where emp_id = 885;

--EX 5 Task 3 Command Set 3 - Demonstrate each Constraint Working (Allow Good Data)
--Trinity Klein
--Connected as user_you_are_connected_as (tell me which user you are connected as)
/* Implementing: (1) An employee email address should use the company domain. That
is, the email address should end with 'abcco.com'. */

update employee set co_email = 'jerso@abcco.com' where emp_id = 885;

select * from employee where emp_id = 885;




/* EX 5 Task 4. Add and Test Check Constraints to Assure Data Integrity
A check constraint can be added to a column to help assure domain
integrity. Check constraints are added using the alter table command as 
demonstrated in class. 
Here is an ITAM business rule that can be supported with a check constraint.
(2) The values allowed for the use or support attribute of the employee_CI 
table are either USE or SUPPORT (in all caps).

Logged in as ITAM_USERNAME, add a check constraint to the corresponding column or
set of columns in the appropriate tables of the ITAM schema to support the second
stated business rule. After adding the constraint, write one or more commands to 
demonstrate that the check constraint works to prevent "bad" data from being 
inserted and that it works to allow "good" data to be inserted. */

--EX 5 Task 4 Command Set 1 - Create a Check Constraint for Stated Rule (2)
--Trinity Klein
--Connected as itma_tlklein
/*Implementing: (2) The values allowed for the use or support attribute of the 
employee_CI table are either USE or SUPPORT (in all caps). */
alter table employee_ci
add constraint caps_use_support
check (use_or_support = upper(use_or_support));
--enable novalidate;


--EX 5 Task 4 Command Set 2 - Demonstrate a Constraint Working (Prevent Bad Data)
--Trinity Klein
--Connected as user_you_are_connected_as (tell me which user you are connected as) 
/* Implementing: (2) The values allowed for the use or support attribute of the 
employee_CI table are either USE or SUPPORT (in all caps). */

update employee_ci set use_or_support = 'use' where ci_inv_id = 845 
and emp_id = 101;

select * from employee_ci;


--EX 5 Task 4 Command Set 3 - Demonstrate a Constraint Working (Allow Good Data)
--Trinity Klein
--Connected as user_you_are_connected_as (tell me which user you are connected as)
/* Implementing: (2) The values allowed for the use or support attribute of the 
employee_CI table are either USE or SUPPORT (in all caps). */

update employee_ci set use_or_support = 'USE' where ci_inv_id = 512 
and emp_id = 817;

select * from employee_ci where ci_inv_id = 512 and emp_id = 817;


/*EX 5 Task 5. Add and Test a Check Constraint that Involves Multiple Columns */
/* The team wants to create infrastructure to assure a new business rule:
(3) New company email addresses will follow the naming convention of
  (a) first letter of first name
  (b) followed by last name truncated to 6 characters, excluding spaces
  (c) followed by 6th numeral of the employee's ssn
  (d) followed by 8th numeral of employee's ssn. 
Create a constraint in support of this business rule. Then test the constraint to 
verify that it allows "good" data to be inserted and prevents "bad" data from 
being inserted.
* Hint. Use the substr function to select parts of the fields that contain the data
on which the email address is based. Use the replace function to remove blank spaces 
from a name. */

--EX 5 Task 5 Command Set 1 - Create a Check Constraint for Stated Rule (3)
--Trinity Klein
--Connected as itam_tlklein
/*Implementing: (3) New company email addresses will follow the naming convention
of (a) first letter of first name, (b) followed by last name truncated to 6 
characters, excluding spaces, (c) followed by 6th numeral of the employee's ssn, 
(d) followed by 8th numeral of employee's ssn.  */

alter table employee
add constraint emp_email_standard
check (
    co_email = 
        substr(lower(first_name), 1, 1) || 
        replace(substr(lower(last_name), 1, 6), ' ', '') || 
        substr(lastfour_ssn, 1, 1) || 
        substr(lastfour_ssn, 3, 1) || 
        '@abcco.com'
) 
enable novalidate;



--EX 5 Task 5 Command Set 2 - Demonstrate a Constraint Working (Prevent Bad Data)
--Trinity Klein
--Connected as itam_tlklein
/* Implementing:  (3) New company email addresses will follow the naming convention
of (a) first letter of first name, (b) followed by last name truncated to 6 
characters, excluding spaces, (c) followed by 6th numeral of the employee's ssn, 
(d) followed by 8th numeral of employee's ssn. */

update employee set co_email = 'jerso@gmail.com' where emp_id = 885;

select * from employee where emp_id = 885;


--EX 5 Task 5 Command Set 3 - Demonstrate a Constraint Working (Allow Good Data)
--Trinity Klein
--Connected as itam_tlklein
/* Implementing:  (3) New company email addresses will follow the naming convention
of (a) first letter of first name, (b) followed by last name truncated to 6 
characters, excluding spaces, (c) followed by 6th numeral of the employee's ssn, 
(d) followed by 8th numeral of employee's ssn. */

update employee set co_email = 'jerso80@abcco.com' where emp_id = 885;

select * from employee where emp_id = 885;






