/* EX 6 User-Defined Functions, Stored Procedures, and Triggers to Automate 
Processes */


/* EX 6 Task 1. Create and Use a Function for How Many CIs in USE 
Code is provided to create a function that derives how many of a particular 
asset, based on input of asset make, asset model, asset extended information, 
and asset type, are assigned for use. The function derives the count from the 
tables without relying on the ci_status value to be correctly set to INUSE. The 
team believes there is a error in the prototype system being built that results 
in the ci_status value being incorrect, so they are creating infrastructure to 
help verify the problem or determine that it does not exist. Note that assets  
should not be counted if they are disposed of or in repair or returned to 
inventory after beign assigned for use. Create the function from the code 
provided after you write comments explaining what each line of code is doing where 
prompted.*/

/* EX 6 Task 1 Create a Function for How Many CIs in USE */
-- Comment the code provided and use it to create the function
-- Trinity Klein
create or replace function get_how_many_in_use (
    p_asset_make asset_desc.asset_make%type,
    P_asset_model asset_desc.asset_model%type,-- getting the type from the data dictionary
    p_asset_ext asset_desc.asset_ext%type,
    p_asset_type asset_type.asset_type_desc%type
)
return number --  posting the total number of individual types of ci's in use in a variable 
as
    v_how_many number;
begin
  select count(cii.asset_desc_id)  into v_how_many
  from ci_inventory cii join asset_desc ad on cii.asset_desc_id = ad.asset_desc_id
  join asset_type at on ad.asset_type_id = at.asset_type_id
  where cii.ci_inv_id in
  (select ci_inv_id from employee_ci where 
  upper(use_or_support) = 'USE' and date_unassigned is null)-- define that a ci is in use and is has not been unassigned 
  and cii.ci_status_code not in ('DISPOSED','INREPAIR')-- and is not disposed or in repair
  and (ad.asset_make = p_asset_make and ad.asset_model = p_asset_model);-- and where it is in the asset model and asset make vars
  
  RETURN v_how_many;
end;


/* EX 6 Task 2. Use the Function to Return a Value > 1 and to Return a Value = 0
Use the function created in Task 1 two times. One use should show the function 
retrieving a number > 1 and the other use should show the function finding 0 
instances of the CI in use. */

-- Trinity Klein
/* Ex 6 Task 2 Command 1 Return a Value > 1 */
select * from asset_desc order by asset_make,asset_model,asset_ext,asset_type_id;

select * from employee_ci eci
join ci_inventory cii on eci.ci_inv_id = cii.ci_inv_id 
join asset_desc ad on ad.asset_desc_id = cii.asset_desc_id
where use_or_support = 'USE' and date_unassigned is null
order by ad.asset_desc_id; 

select ad.asset_desc_id, eci.ci_inv_id from employee_ci eci
join ci_inventory cii on eci.ci_inv_id = cii.ci_inv_id 
join asset_desc ad on ad.asset_desc_id = cii.asset_desc_id
where use_or_support = 'USE' and date_unassigned is null
order by ad.asset_desc_id; 

select * from asset_desc where asset_desc_id = 7;

select get_how_many_in_use('Dell', 
'XPS 15', '10th Generation Intel Core i5-10210U','Laptop')
from dual;


-- Trinity Klein
/* Ex 6 Task 2 Command 2 Return a Value = 0*/
select * from employee_ci eci
join ci_inventory cii on eci.ci_inv_id = cii.ci_inv_id 
join asset_desc ad on ad.asset_desc_id = cii.asset_desc_id
where use_or_support <> 'USE' and date_unassigned is null
order by ad.asset_desc_id; 

select * from asset_desc where asset_desc_id = 2;

select get_how_many_in_use('Hewlett Packard', 
'HPE ProLiant DL380', 'Gen10 Server 8SFF 2 X Intel Xeon Scalable 4210','Server Software' ) 
from dual;


/* EX 6 Task 3. Create a Function to Derive How Many CIs Available in Inventory
Create a function that returns how many there are of a particular IT asset 
description with one or more CI instances in inventory that are unassigned for 
use by an employee, are not disposed of and are not in repair. Not being assigned
for use or disposed of or in repair means the CI is, basically, in storage or 
it's a server or something else that gets assigned only for support. CIs like 
this are supposed to be marked with the status "Operational Available for 
Assignment for Use", but the team has been notified that some sample data in 
system under development seems to not be updating in this regard due to a fault 
in the apps being developed with automation for some aspects of the process. So,
until that but is found and fixed, be sure that that your function returns counts
of only CIs that are derived to be available from data in tables, disregarding 
the status recorded in the table for CI inventory. The function will need to 
accept as input four values of asset description, all or which are string 
literals, namely, the make, model, extended information, and type description of
the asset being counted. */


/*EX 6 Task 3 Create a Function to Derive How Many CIs Available in Inventory */
-- Trinity Klein
-- write the code to create the function and then create it
create or replace function get_how_many_in_support(
    p_asset_make asset_desc.asset_make%type,
    P_asset_model asset_desc.asset_model%type,
    p_asset_ext asset_desc.asset_ext%type,
    p_asset_type asset_type.asset_type_desc%type
)
return number
as
    v_how_many_in_support number;
begin
    select count(cii.asset_desc_id) into v_how_many_in_support
    from ci_inventory cii join asset_desc ad on cii.asset_desc_id = ad.asset_desc_id
    join asset_type at on at.asset_type_id = ad.asset_type_id
    where cii.ci_inv_id in
    (select ci_inv_id from employee_ci where upper(use_or_support) = 'SUPPORT' 
    and date_unassigned is null) and cii.ci_status_code <> 'DISPOSED'
    and (ad.asset_make = p_asset_make and ad.asset_model = p_asset_model);
    
  return v_how_many_in_support;
end;


/* EX 6 Task 4. Use the Function to Return a Value > 1 and to Return a Value = 0
Use the function from Task 3 two times. Show using the function to retrieve a 
number greater than 1 and show using the function to return a value of 0.


/*EX 6 Task 4 Use the Function to Return a Value > 1 and to Return a Value = 0 */
-- Trinity Klein
--EX 6 Task 4 Command 1 Return a Value > 1
select * from asset_desc order by asset_make,asset_model,asset_ext,asset_type_id;

select * from employee_ci eci
join ci_inventory cii on eci.ci_inv_id = cii.ci_inv_id 
join asset_desc ad on ad.asset_desc_id = cii.asset_desc_id
where upper(use_or_support) = 'SUPPORT' and date_unassigned is null 
and cii.ci_status_code <> 'DISPOSED'
order by asset_make,asset_model,asset_ext,asset_type_id; 

select * from asset_desc where asset_desc_id = 197;

select get_how_many_in_support('Acer', 
'Swift X 14-inch Laptop', '12th gen Intel i7','Laptop')
from dual;

-- Trinity Klein
--EX 6 Task 4 Command 2 Return a Value = 0 
select * from employee_ci eci
join ci_inventory cii on eci.ci_inv_id = cii.ci_inv_id 
join asset_desc ad on ad.asset_desc_id = cii.asset_desc_id
where date_unassigned is null 
and cii.ci_status_code <> 'DISPOSED'
order by asset_make,asset_model,asset_ext,asset_type_id; 

select * from asset_desc where asset_desc_id = 842;

select get_how_many_in_support('Microsoft', 
'Windows 11 Pro','Factory-installed on Lenovo ThinkPad X1', 'Application') 
from dual;

/* Task 5. Create a Stored Procedure to Insert a CI
Create a stored procedure named the insert_asset_CI_yourusername, replacing 
yourusername with your username on the class server (even though you are 
completing the exercise using your cloud infrastructure. The purpose of the 
procedure is to add a new configurartion item into inventory along with its 
new description, making sure that the new description is new and not a duplicate
of a set of description information already in the table. If the description 
is not new, that is, it is a duplicate of information already in the asset_desc
table, then the procedure should insert the new CI but not the asset description
data. The procedure must accept as input values for the type of asset (by 
description), the make of the asset, the model, and the extra attribute 
information. Input for inventory information for the CI must also be accepted, 
including information about whether the CI was purchased or leased, a unique ID 
from the manufacturer, and the date the CI was acquired (optional). Other values
needed for the inventory should be provided by the procedure based on business 
rules. The procedure should send an output value back to the calling application
that indicates success or failure.
 
Note a procedure was written in class for part of the functionality.  You could 
start with the code for that procedure and add to it and modify it as needed to 
help you create this procedure. For Task 7, you document the code of your
procedure and your success with creating it. For Task 8, you document testing it
in use.*/

-- Trinity Klein
--Ex 6 Task 5 Create a Procedure to Insert an Asset Description and a CI
create or replace procedure insert_asset_tlklein(
p_asset_make asset_desc.asset_make&type,
p_asset_model asset_desc.asset_model&type,
p_asset_ext asset_desc.asset_ext&type,
p_asset_type asset_type.asset_type_desc#type,
p_SF out varchar2)

v_asset_type_id number;
v_asset_desc_count number;
v_asset_desc_id number;
begin
p_SF := 'S';
select asset_type_id into v_asset_type_id from asset_type at
where asset_type_desc = p_asset_type;

select count (asset_desc_id) into v_asset_desc_count
from asset_desc ad where ad.asset_make = p_asset_make and
ad.asset_model = p_asset_model and ad.asset_ext = p_asset_ext and
ad.asset_type_id = v_asset_type_id;

if v_asset_desc_count = 0 then
select asset_desc_id_seq.nextval into v_asset_desc_id from dual;
insert into asset_desc
values (v_asset_desc_id, v_asset_type_id, p_asset_make,
p_asset_model, p_asset_ext);
p_SF := p_SF || ' insert asset desc' || v_asset_desc_id;

select asset_desc_id into v_asset_desc_id from asset_desc ad
where ad.asset_make = p_asset_make and ad.asset_model =
p_asset_model and ad.asset_ext = p_asset_ext and
ad.asset_type_id = v_asset_type_id;
raise value_error;
end if;





/* Task 6. Demonstrate Using the Procedure from the Previous Task
Provide examples of calling the stored procedure created in Task 5. Capture the 
value passed back by the output variable that could be used to communication 
success or failure type to a calling application. The call examples should 
demonstrate two success state results and a failure state result. */

-- Trinity Klein
-- Ex 6 Task 6 Command 5 Demonstrate a Success Result with a New Description
declare
    success_or_fail varchar2 (100) := 'Not good';
begin
    insert_asset_tlklein('Azuz', 'Swiftbook 16 Laptop',
    '16 in Full HD Intel Core i5 8GB 256GB',
    'Laptop', success_or_fail);
    dbms_output.put_line (success_or_fail);
end;
/


--Trinity Klein
--Ex 6 Task 6 Command 2 Verify Data Inserted Into Asset_Desc Table
--Verify that a record was inserted into the asset_desc table by the call to the sp.
select * from asset_desc where asset_type_id = 2
and asset_make = 'Azuz';


--Trinity Klein
--Ex 6 Task 6 Command 5
select * from ci_inventory where asset_desc_id = 1112;







/* Getting accurate data into the IT asset inventory summary is tricky because 
the data could be handled different ways. When/why should a value get written 
into the IT asset inventory summary?
Here are business rules that describe how data should be put into the 
it_asset_inv_summary table. Some of the data in the table does not match these
business rules.
(1) When a CI is placed in inventory for the first time it should be marked 
unavailable because it has not yet been assigned for support. Also, if no other 
CIs of the same description have gone into inventory before it, the first 
entry for the description should be placed into it_asset_inv_summary with number 
available, number assigned for use, and number assigned for support all being 0.
(2) When a CI is assigned for support, the CI should be marked available for use, 
provided it is of one of the types that can be assigned for use. Otherwise, it 
should remain unavailable. The IT asset inventory summary should get another 
record for the corresponding description where the number assigned for support 
increases by 1 and the number available increases by 1 when appropriate.
(3) When a CI is unassigned for support the CI should be marked as disposed (if
that's the reason the CI is not being supported any more) or it can be marked 
unavailable under the circumstance that it is unassigned for support from
one person because it is being assigned to someone else. The IT asset inventory
summary should get another record with the number assigned for support reduced 
by 1.
(4) When a CI is assigned for use, it should be marked 'INUSE'. The IT asset
inventory summary should get another record, with the number available being 
reduced by 1 and the number assigned for use increased by 1.
(5) When a CI is unassigned for use, it should be marked available or in repair, 
depending on the reason. The IT asset inventory summary should get another record
for that CI's description, with the number available increasing by 1 or staying 
unchanged, and the number assigned for use decreasing by 1.
(6) When a CI is marked INREPAIR it should be unassigned for use, 
but not unassigned for support since the person supporting it would shepherd it
through the repair process.
(7) When a CI is marked DISPOSED it should be unassigned for support. It should 
already be unassigned for use.
(8) When a CI is marked INUSE, it should already be assigned for use.
(9) If a CI is marked INREPAIR, it should already be unassigned for USE.

These business rules can all (probably) be enforced with complex processing 
logic that uses triggers.*/

/* Task 7. Create Trigger for First Insert of CI to Mark CI 'UNAVAIL'
Consider the first part of business rule (1). When a CI is placed in
inventory for the first time it should be marked unavailable because it has not 
yet been assigned for support. Write code to create a before trigger to enforce  
this business rule */

--Trinity Klein
--EX 6 Task 7 Create Trigger for First Insert of CI to Mark CI 'UNAVAIL'

create or replace trigger trg_ci_inv_unavail
before insert on ci_inventory
for each row
declare
    v_ci_inv_id number;
    v_asset_desc_id number;
    l_existing_ci number;
    
begin
    --select asset_desc_id_seq.nextval into v_asset_desc_id from dual;
    select ci_inv_id_seq.nextval into v_ci_inv_id from dual;
    
    select count(*) into l_existing_ci from ci_inventory
    where unique_id = :NEW.unique_id;
    
    if l_existing_ci = 0 then
        :new.ci_status_code := 'UNAVAIL';
        :new.ci_status_date := sysdate;
        :new.ci_inv_id := v_ci_inv_id;
    end if;
end;
/



/* Task 8. Verify Trigger Prevent Data Being Inserted that Violates the 
Business Rule 
Write code to demonstrate the trigger working to assure only accurate 
data is inserted into ci_inventory with respect to ci_status_code. */

--Trinity Klein
--EX 6 Task 8 Command 1 Verify Trigger Prevents Data Being Inserted that  
--Violates the Business Rule
--Write the dml command that will fire the trigger.
insert into ci_inventory (ci_inv_id, asset_desc_id, purchase_or_rental,
unique_id,ci_acquired_date, ci_status_code,ci_status_date) 
values
(ci_inv_id_seq.nextval, 10040,'PURCHASE', 'ABCD 123456', 
sysdate, 'AVAIL', sysdate);

--Write commands that verify that data changes were not made.
select * from ci_inventory
where unique_id = 'ABCD 123456';


--Trinity Klein
--EX 6 Task 8 Command 2 Verify Trigger Does not Prevent Good Data that does Not
--Violate the Business Rule
--Write the dml command that will fire the trigger.
insert into ci_inventory(ci_inv_id, asset_desc_id, purchase_or_rental,
unique_id, ci_acquired_date, ci_status_code, ci_status_date) 
values(ci_inv_id_seq.nextval, 10025,'PURCHASE','DELL-5420-003',
sysdate,'UNAVAIL',sysdate);

--Write commands that verify that the data changes were made.
select * from ci_inventory 
where unique_id = 'DELL-5420-003';

/* Task 9. Create a Compound Trigger
Now consider the second part of business rule (1). If no other 
CIs of the same description have gone into inventory before it, the first 
entry for the description should be placed into it_asset_inv_summary with number 
available, number assigned for use, and number assigned for support all being 0.
Write a command to create a compound trigger that enforces this part of business
rule (1). 
Trinity Klein
EX 6 Task 9*/
create or replace trigger trg_ci_inv_summary
for insert on ci_inventory
compound trigger
    type t_summary_rec is record (
        asset_desc_id ci_inventory.asset_desc_id%type,
        summary_exists number);
    type t_summary_table is table of t_summary_rec;
    l_summary_table t_summary_table := t_summary_table();
    after each row is
        v_it_asset_inv_summary_id number;
    begin
        l_summary_table.extend;
        select count(*)
        into l_summary_table(l_summary_table.last).summary_exists
        from it_asset_inv_summary
        where asset_desc_id = :new.asset_desc_id;
        if l_summary_table(l_summary_table.last).summary_exists = 0 then
            insert into it_asset_inv_summary (
                it_asset_inv_summary_id, asset_desc_id,
                inv_summary_date, num_available, 
                num_assgnd_use, num_assgnd_support
            ) values (
                it_asset_inv_summary_id_seq.nextval,
                :new.asset_desc_id, sysdate, 0,0,0);
        end if;
    end after each row;
end trg_ci_inv_summary;
/



/* Task 10. Test the Trigger
Write commands to test the trigger. */

-- Trinity Klein
--EX 6 Task 10 Command 1 Test the After Insert Trigger - It Writes a Row of Data
--Write a command that will fire the trigger and demonstrate that the correct 
--row gets written to the IT asset inventory summary by the trigger.
-- Assuming ci_inventory table has columns: ci_inv_id, asset_desc_id, purchase_or_rental, unique_id, ci_acquired_date, ci_status_code, ci_status_date
insert into ci_inventory (ci_inv_id, asset_desc_id, purchase_or_rental,
unique_id,ci_acquired_date, ci_status_code,ci_status_date) 
values
(716, 6945,'PURCHASE', 'Serial No. 1238934543767', 
sysdate, 'DISPOSED', sysdate);

--Write commands that verify that the data changes were made to all tables 
--where data was changed. Capture results with each command run.
select * from ci_inventory asset_desc_id = 6945;
select * from it_asset_inv_summary where asset_desc_id = 6945;


-- Trinity Klein
--EX 6 Task 10 Command 2 Test the After Insert Trigger - It Does not Write a Row of Data
--Write a command that will fire the trigger and demonstrate that no row is 
--written to the IT asset inventory summary by the trigger for a CI with an 
--asset description that is already matched to other CIs.
insert into ci_inventory (ci_inv_id, asset_desc_id, purchase_or_rental,
unique_id,ci_acquired_date, ci_status_code,ci_status_date) 
values
(ci_inv_id_seq.nextval, asset_desc_id_seq.nextval,'PURCHASE', 'Serial No. 123893454376', 
sysdate, 'DISPOSED', sysdate);

--Trinity Klein
--EX 6 Task 10
--Write commands that verify that the data changes were made to all tables 
--where data was changed. Capture results with each command run.
select * from ci_inventory where asset_desc_id = 141;
select * from it_asset_inv_summary where asset_desc_id = 141;



