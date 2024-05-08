/* Highlight each create command one at a time and run each one to create 
the tables and other infrastructure for the accounts payable business process
used for most of the examples in the Murach book. */

create table general_ledger_accounts
(
  account_number        number(8),
  account_description   varchar2(50)    not null,
  constraint gl_accounts_pk primary key (account_number)
);--created

create table terms
(
  terms_id              number(8),
  terms_description     varchar2(50)    not null,
  terms_due_days        number(8)          not null,
  constraint terms_pk primary key (terms_id)
);--created 

create table vendors
(
  vendor_id                     number(8),
  vendor_name                   varchar2(50)    not null,
  vendor_address1               varchar2(50),
  vendor_address2               varchar2(50),
  vendor_city                   varchar2(50)    not null,
  vendor_state                  char(2)         not null,
  vendor_zip_code               varchar2(20)    not null,
  vendor_phone                  varchar2(50),
  vendor_contact_last_name      varchar2(50),
  vendor_contact_first_name     varchar2(50),
  default_terms_id              number(8)          not null,
  default_account_number        number(8)          not null,
  constraint vendors_pk primary key (vendor_id),
  constraint vendors_fk_terms foreign key (default_terms_id) 
    references terms (terms_id),
  constraint vendors_fk_accounts foreign key (default_account_number) 
    references general_ledger_accounts (account_number)
);--created

create table invoices
(
  invoice_id            number(8), 
  vendor_id             number(8)       not null,
  invoice_number        varchar2(50)    not null,
  invoice_date          date   not null,
  invoice_total         number(9,2)     null,
  payment_total         number(9,2),
  credit_total          number(9,2),
  terms_id              number(8)       not null,
  invoice_due_date      date            not null,
  payment_date          date,
  constraint invoices_pk primary key (invoice_id),
  constraint invoices_fk_vendors foreign key (vendor_id) 
    references vendors (vendor_id),
  constraint invoices_fk_terms foreign key (terms_id) 
    references terms (terms_id)
);--created

create table invoice_line_items
(
  invoice_id              number(8),
  invoice_sequence        number(8),
  account_number          number(8)    not null,
  line_item_amt           number(9,2)   not null,
  line_item_description   varchar2(100) not null,
  constraint line_items_pk primary key (invoice_id, invoice_sequence),
  constraint line_items_fk_invoices foreign key (invoice_id) 
     references invoices (invoice_id),
  constraint line_items_fk_accounts foreign key (account_number) 
     references general_ledger_accounts (account_number)
);--created


-- Create sequences
create sequence vendor_id_seq start with 90 increment by 3;
create sequence invoice_id_seq start with 120;  
--both done

/* Create some tables that are related to the previous five 
tables and that are used for some (not many) examples in Murach */
create table vendor_contacts
(
  vendor_id       number(8) not null,
  last_name       varchar2(50)  not null,
  first_name      varchar2(50)  not null,
  ven_con_cell_ph varchar2(50) not null,
  constraint ven_con_pk primary key (vendor_id, ven_con_cell_ph),
  constraint ven_con_fk_vendors foreign key (vendor_id) 
     references vendors (vendor_id)
);--created

create table invoice_archive
(
  invoice_id          number         not null,
  vendor_id           number          not null,
  invoice_number      varchar2(50)    not null,
  invoice_date        date            not null,
  invoice_total       number          not null,
  payment_total       number          not null,
  credit_total        number          not null,
  terms_id            number          not null,
  invoice_due_date    date            not null,
  payment_date        date
);--created

create table active_invoices
(
  invoice_id        number        not null,
  vendor_id         number        not null,
  invoice_number    varchar2(50)  not null,
  invoice_date      date          not null,
  invoice_total     number(9,2)   not null,
  payment_total     number(9,2)   not null,
  credit_total      number(9,2)   not null,
  terms_id          number        not null,
  invoice_due_date  date          not null,
  payment_date      date
);--created

create table  paid_invoices
(
  invoice_id            number          not null,
  vendor_id             number          not null,
  invoice_number        varchar2(50)    not null,
  invoice_date          date            not null,
  invoice_total         number(9,2)     not null,
  payment_total         number(9,2)     not null,
  credit_total          number(9,2)     not null,
  terms_id              number          not null,
  invoice_due_date      date            not null,
  payment_date          date
);--created

-- Disable substitution variable prompting
/***This is an important step. DO NOT MISS IT!!!!***/
set define off;

/* Run the insert statements for one table at a time by
highlighting all the statements for one table and then 
running that batch of commands. */

-- insert into general_ledger_accounts 
insert into general_ledger_accounts (account_number,account_description) 
values (100,'Cash');
insert into general_ledger_accounts (account_number,account_description) 
values (110,'Accounts Receivable');
insert into general_ledger_accounts (account_number,account_description) 
values (120,'Book Inventory');
insert into general_ledger_accounts (account_number,account_description) 
values (150,'Furniture');
insert into general_ledger_accounts (account_number,account_description) 
values (160,'Computer Equipment');
insert into general_ledger_accounts (account_number,account_description) 
values (162,'Capitalized Lease');
insert into general_ledger_accounts (account_number,account_description) 
values (167,'Software');
insert into general_ledger_accounts (account_number,account_description) 
values (170,'Other Equipment');
insert into general_ledger_accounts (account_number,account_description) 
values (181,'Book Development');
insert into general_ledger_accounts (account_number,account_description) 
values (200,'Accounts Payable');
insert into general_ledger_accounts (account_number,account_description) 
values (205,'Royalties Payable');
insert into general_ledger_accounts (account_number,account_description) 
values (221,'401K Employee Contributions');
insert into general_ledger_accounts (account_number,account_description) 
values (230,'Sales Taxes Payable');
insert into general_ledger_accounts (account_number,account_description) 
values (234,'Medicare Taxes Payable');
insert into general_ledger_accounts (account_number,account_description) 
values (235,'Income Taxes Payable');
insert into general_ledger_accounts (account_number,account_description) 
values (237,'State Payroll Taxes Payable');
insert into general_ledger_accounts (account_number,account_description) 
values (238,'Employee FICA Taxes Payable');
insert into general_ledger_accounts (account_number,account_description) 
values (239,'Employer FICA Taxes Payable');
insert into general_ledger_accounts (account_number,account_description) 
values (241,'Employer FUTA Taxes Payable');
insert into general_ledger_accounts (account_number,account_description) 
values (242,'Employee SDI Taxes Payable');
insert into general_ledger_accounts (account_number,account_description) 
values (243,'Employer UCI Taxes Payable');
insert into general_ledger_accounts (account_number,account_description) 
values (251,'IBM Credit Corporation Payable');
insert into general_ledger_accounts (account_number,account_description) 
values (280,'Capital Stock');
insert into general_ledger_accounts (account_number,account_description) 
values (290,'Retained Earnings');
insert into general_ledger_accounts (account_number,account_description) 
values (300,'Retail Sales');
insert into general_ledger_accounts (account_number,account_description) 
values (301,'College Sales');
insert into general_ledger_accounts (account_number,account_description) 
values (302,'Trade Sales');
insert into general_ledger_accounts (account_number,account_description) 
values (306,'Consignment Sales');
insert into general_ledger_accounts (account_number,account_description) 
values (310,'Compositing Revenue');
insert into general_ledger_accounts (account_number,account_description) 
values (394,'Book Club Royalties');
insert into general_ledger_accounts (account_number,account_description) 
values (400,'Book Printing Costs');
insert into general_ledger_accounts (account_number,account_description) 
values (403,'Book Production Costs');
insert into general_ledger_accounts (account_number,account_description) 
values (500,'Salaries and Wages');
insert into general_ledger_accounts (account_number,account_description) 
values (505,'FICA');
insert into general_ledger_accounts (account_number,account_description) 
values (506,'FUTA');
insert into general_ledger_accounts (account_number,account_description) 
values (507,'UCI');
insert into general_ledger_accounts (account_number,account_description) 
values (508,'Medicare');
insert into general_ledger_accounts (account_number,account_description) 
values (510,'Group Insurance');
insert into general_ledger_accounts (account_number,account_description) 
values (520,'Building Lease');
insert into general_ledger_accounts (account_number,account_description) 
values (521,'Utilities');
insert into general_ledger_accounts (account_number,account_description) 
values (522,'Telephone');
insert into general_ledger_accounts (account_number,account_description) 
values (523,'Building Maintenance');
insert into general_ledger_accounts (account_number,account_description) 
values (527,'Computer Equipment Maintenance');
insert into general_ledger_accounts (account_number,account_description) 
values (528,'IBM Lease');
insert into general_ledger_accounts (account_number,account_description) 
values (532,'Equipment Rental');
insert into general_ledger_accounts (account_number,account_description) 
values (536,'Card Deck Advertising');
insert into general_ledger_accounts (account_number,account_description) 
values (540,'Direct Mail Advertising');
insert into general_ledger_accounts (account_number,account_description) 
values (541,'Space Advertising');
insert into general_ledger_accounts (account_number,account_description) 
values (546,'Exhibits and Shows');
insert into general_ledger_accounts (account_number,account_description) 
values (548,'Web Site Production and Fees');
insert into general_ledger_accounts (account_number,account_description) 
values (550,'Packaging Materials');
insert into general_ledger_accounts (account_number,account_description) 
values (551,'Business Forms');
insert into general_ledger_accounts (account_number,account_description) 
values (552,'Postage');
insert into general_ledger_accounts (account_number,account_description) 
values (553,'Freight');
insert into general_ledger_accounts (account_number,account_description) 
values (555,'Collection Agency Fees');
insert into general_ledger_accounts (account_number,account_description) 
values (556,'Credit Card Handling');
insert into general_ledger_accounts (account_number,account_description) 
values (565,'Bank Fees');
insert into general_ledger_accounts (account_number,account_description) 
values (568,'Auto License Fee');
insert into general_ledger_accounts (account_number,account_description) 
values (569,'Auto Expense');
insert into general_ledger_accounts (account_number,account_description) 
values (570,'Office Supplies');
insert into general_ledger_accounts (account_number,account_description) 
values (572,'Books, Dues, and Subscriptions');
insert into general_ledger_accounts (account_number,account_description) 
values (574,'Business Licenses and Taxes');
insert into general_ledger_accounts (account_number,account_description) 
values (576,'PC Software');
insert into general_ledger_accounts (account_number,account_description) 
values (580,'Meals');
insert into general_ledger_accounts (account_number,account_description) 
values (582,'Travel and Accomodations');
insert into general_ledger_accounts (account_number,account_description) 
values (589,'Outside Services');
insert into general_ledger_accounts (account_number,account_description) 
values (590,'Business Insurance');
insert into general_ledger_accounts (account_number,account_description) 
values (591,'Accounting');
insert into general_ledger_accounts (account_number,account_description) 
values (610,'Charitable Contributions');
insert into general_ledger_accounts (account_number,account_description) 
values (611,'Profit Sharing Contributions');
insert into general_ledger_accounts (account_number,account_description) 
values (620,'Interest Paid to Banks');
insert into general_ledger_accounts (account_number,account_description) 
values (621,'Other Interest');
insert into general_ledger_accounts (account_number,account_description) 
values (630,'Federal Corporation Income Taxes');
insert into general_ledger_accounts (account_number,account_description) 
values (631,'State Corporation Income Taxes');


-- insert into terms 
insert into terms (terms_id,terms_description,terms_due_days) values (1,'Net due 10 days',10);
insert into terms (terms_id,terms_description,terms_due_days) values (2,'Net due 20 days',20);
insert into terms (terms_id,terms_description,terms_due_days) values (3,'Net due 30 days',30);
insert into terms (terms_id,terms_description,terms_due_days) values (6,'Net due 60 days',60);
insert into terms (terms_id,terms_description,terms_due_days) values (9,'Net due 90 days',90);

select * from ap.vendors;

-- insert into vendors 
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (1,'US Postal Service','Attn:  Supt. Window Services','PO Box 7005','Madison','WI','53707','(800) 555-1205','Alberto','Francesco',1,552);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (2,'National Information Data Ctr','PO Box 96621',null,'Washington','DC','20090','(301) 555-8950','Irvin','Ania',3,540);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (3,'Register of Copyrights','Library Of Congress',null,'Washington','DC','20559',null,'Liana','Lukas',3,403);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (4,'Jobtrak','1990 Westwood Blvd Ste 260',null,'Los Angeles','CA','90025','(800) 555-8725','Quinn','Kenzie',3,572);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (5,'Newbrige Book Clubs','3000 Cindel Drive',null,'Washington','NJ','07882','(800) 555-9980','Marks','Michelle',6,394);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (6,'California Chamber Of Commerce','3255 Ramos Cir',null,'Sacramento','CA','95827','(916) 555-6670','Mauro','Anton',3,572);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (7,'Towne Advertiser''s Mailing Svcs','Kevin Minder','3441 W Macarthur Blvd','Santa Ana','CA','92704',null,'Maegen','Ted',3,540);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (8,'BFI Industries','PO Box 9369',null,'Fresno','CA','93792','(559) 555-1551','Kaleigh','Erick',3,521);
insert into vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (9,'Pacific Gas & Electric','Box 52001',null,'San Francisco','CA','94152','(800) 555-6081','Anthoni','Kaitlyn',3,521);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (10,'Robbins Mobile Lock And Key','4669 N Fresno',null,'Fresno','CA','93726','(559) 555-9375','Leigh','Bill',2,523);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (11,'Bill Marvin Electric Inc','4583 E Home',null,'Fresno','CA','93703','(559) 555-5106','Hostlery','Kaitlin',2,523);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (12,'City Of Fresno','PO Box 2069',null,'Fresno','CA','93718','(559) 555-9999','Mayte','Kendall',3,574);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (13,'Golden Eagle Insurance Co','PO Box 85826',null,'San Diego','CA','92186',null,'Blanca','Korah',3,590);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (14,'Expedata Inc','4420 N. First Street, Suite 108',null,'Fresno','CA','93726','(559) 555-9586','Quintin','Marvin',3,589);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (15,'ASC Signs','1528 N Sierra Vista',null,'Fresno','CA','93703',null,'Darien','Elisabeth',1,546);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (16,'Internal Revenue Service',null,null,'Fresno','CA','93888',null,'Aileen','Joan',1,235);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (17,'Blanchard & Johnson Associates','27371 Valderas',null,'Mission Viejo','CA','92691','(214) 555-3647','Keeton','Gonzalo',3,540);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (18,'Fresno Photoengraving Company','1952 "H" Street','P.O. Box 1952','Fresno','CA','93718','(559) 555-3005','Chaddick','Derek',3,403);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (19,'Crown Printing','1730 "H" St',null,'Fresno','CA','93721','(559) 555-7473','Randrup','Leann',2,400);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (20,'Diversified Printing & Pub','2632 Saturn St',null,'Brea','CA','92621','(714) 555-4541','Lane','Vanesa',3,400);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (21,'The Library Ltd','7700 Forsyth',null,'St Louis','MO','63105','(314) 555-8834','Marques','Malia',3,540);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (22,'Micro Center','1555 W Lane Ave',null,'Columbus','OH','43221','(614) 555-4435','Evan','Emily',2,160);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (23,'Yale Industrial Trucks-Fresno','3711 W Franklin',null,'Fresno','CA','93706','(559) 555-2993','Alexis','Alexandro',3,532);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (24,'Zee Medical Service Co','4221 W Sierra Madre #104',null,'Washington','IA','52353',null,'Hallie','Juliana',3,570);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (25,'California Data Marketing','2818 E Hamilton',null,'Fresno','CA','93721','(559) 555-3801','Jonessen','Moises',6,540);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (26,'Small Press','121 E Front St - 4th Floor',null,'Traverse City','MI','49684',null,'Colette','Dusty',3,540);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (27,'Rich Advertising','12 Daniel Road',null,'Fairfield','NJ','07004','(201) 555-9742','Neil','Ingrid',3,540);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (29,'Vision Envelope & Printing','PO Box 3100',null,'Gardena','CA','90247','(310) 555-7062','Raven','Jamari',3,551);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (30,'Costco','Fresno Warehouse','4500 W Shaw','Fresno','CA','93711',null,'Jaquan','Aaron',3,570);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (31,'Enterprise Communications Inc','1483 Chain Bridge Rd, Ste 202',null,'Mclean','VA','22101','(770) 555-9558','Lawrence','Eileen',2,536);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (32,'RR Bowker','PO Box 31',null,'East Brunswick','NJ','08810','(800) 555-8110','Essence','Marjorie',3,532);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (33,'Nielson','Ohio Valley Litho Division','Location #0470','Cincinnati','OH','45264',null,'Brooklynn','Keely',2,541);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (34,'IBM','PO Box 61000',null,'San Francisco','CA','94161','(800) 555-4426','Camron','Trentin',1,160);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (35,'Cal State Termite','PO Box 956',null,'Selma','CA','93662','(559) 555-1534','Hunter','Demetrius',2,523);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (36,'Graylift','PO Box 2808',null,'Fresno','CA','93745','(559) 555-6621','Sydney','Deangelo',3,532);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (37,'Blue Cross','PO Box 9061',null,'Oxnard','CA','93031','(800) 555-0912','Eliana','Nikolas',3,510);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (38,'Venture Communications Int''l','60 Madison Ave',null,'New York','NY','10010','(212) 555-4800','Neftaly','Thalia',3,540);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (39,'Custom Printing Company','PO Box 7028',null,'St Louis','MO','63177','(301) 555-1494','Myles','Harley',3,540);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (40,'Nat Assoc of College Stores','500 East Lorain Street',null,'Oberlin','OH','44074',null,'Bernard','Lucy',3,572);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (41,'Shields Design','415 E Olive Ave',null,'Fresno','CA','93728','(559) 555-8060','Kerry','Rowan',2,403);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (42,'Opamp Technical Books','1033 N Sycamore Ave.',null,'Los Angeles','CA','90038','(213) 555-4322','Paris','Gideon',3,572);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (43,'Capital Resource Credit','PO Box 39046',null,'Minneapolis','MN','55439','(612) 555-0057','Maxwell','Jayda',3,589);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (44,'Courier Companies, Inc','PO Box 5317',null,'Boston','MA','02206','(508) 555-6351','Antavius','Troy',6,400);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (45,'Naylor Publications Inc','PO Box 40513',null,'Jacksonville','FL','32231','(800) 555-6041','Gerald','Kristofer',3,572);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (46,'Open Horizons Publishing','Book Marketing Update','PO Box 205','Fairfield','IA','52556','(515) 555-6130','Damien','Deborah',2,540);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (47,'Baker & Taylor Books','Five Lakepointe Plaza, Ste 500','2709 Water Ridge Parkway','Charlotte','NC','28217','(704) 555-3500','Bernardo','Brittnee',3,572);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (48,'Fresno County Tax Collector','PO Box 1192',null,'Fresno','CA','93715','(559) 555-3482','Brenton','Kila',3,574);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (49,'Mcgraw Hill Companies','PO Box 87373',null,'Chicago','IL','60680','(614) 555-3663','Holbrooke','Rashad',3,572);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (50,'Publishers Weekly','Box 1979',null,'Marion','OH','43305','(800) 555-1669','Carrollton','Priscilla',3,572);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (51,'Blue Shield of California','PO Box 7021',null,'Anaheim','CA','92850','(415) 555-5103','Smith','Kylie',3,510);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (52,'Aztek Label','Accounts Payable','1150 N Tustin Ave','Anaheim','CA','92807','(714) 555-9000','Griffin','Brian',3,551);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (53,'Gary McKeighan Insurance','3649 W Beechwood Ave #101',null,'Fresno','CA','93711','(559) 555-2420','Jair','Caitlin',3,590);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (54,'Ph Photographic Services','2384 E Gettysburg',null,'Fresno','CA','93726','(559) 555-0765','Cheyenne','Kaylea',3,540);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (55,'Quality Education Data','PO Box 95857',null,'Chicago','IL','60694','(800) 555-5811','Misael','Kayle',2,540);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (56,'Springhouse Corp','PO Box 7247-7051',null,'Philadelphia','PA','19170','(215) 555-8700','Maeve','Clarence',3,523);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (57,'The Windows Deck','117 W Micheltorena Top Floor',null,'Santa Barbara','CA','93101','(800) 555-3353','Wood','Liam',3,536);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (58,'Fresno Rack & Shelving Inc','4718 N Bendel Ave',null,'Fresno','CA','93722',null,'Baylee','Dakota',2,523);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (59,'Publishers Marketing Assoc','627 Aviation Way',null,'Manhatttan Beach','CA','90266','(310) 555-2732','Walker','Jovon',3,572);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (60,'The Mailers Guide Co','PO Box 1550',null,'New Rochelle','NY','10802',null,'Lacy','Karina',3,540);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (61,'American Booksellers Assoc','828 S Broadway',null,'Tarrytown','NY','10591','(800) 555-0037','Angelica','Nashalie',3,574);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (62,'Cmg Information Services','PO Box 2283',null,'Boston','MA','02107','(508) 555-7000','Randall','Yash',3,540);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (63,'Lou Gentile''s Flower Basket','722 E Olive Ave',null,'Fresno','CA','93728','(559) 555-6643','Anum','Trisha',1,570);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (64,'Texaco','PO Box 6070',null,'Inglewood','CA','90312',null,'Oren','Grace',3,582);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (65,'The Drawing Board','PO Box 4758',null,'Carol Stream','IL','60197',null,'Mckayla','Jeffery',2,551);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (66,'Ascom Hasler Mailing Systems','PO Box 895',null,'Shelton','CT','06484',null,'Lewis','Darnell',3,532);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (67,'Bill Jones','Secretary Of State','PO Box 944230','Sacramento','CA','94244',null,'Deasia','Tristin',3,589);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (68,'Computer Library','3502 W Greenway #7',null,'Phoenix','AZ','85023','(602) 547-0331','Aryn','Leroy',3,540);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (69,'Frank E Wilber Co','2437 N Sunnyside',null,'Fresno','CA','93727','(559) 555-1881','Millerton','Johnathon',3,532);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (70,'Fresno Credit Bureau','PO Box 942',null,'Fresno','CA','93714','(559) 555-7900','Braydon','Anne',2,555);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (71,'The Fresno Bee','1626 E Street',null,'Fresno','CA','93786','(559) 555-4442','Colton','Leah',2,572);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (72,'Data Reproductions Corp','4545 Glenmeade Lane',null,'Auburn Hills','MI','48326','(810) 555-3700','Arodondo','Cesar',3,400);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (73,'Executive Office Products','353 E Shaw Ave',null,'Fresno','CA','93710','(559) 555-1704','Danielson','Rachael',2,570);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (74,'Leslie Company','PO Box 610',null,'Olathe','KS','66061','(800) 255-6210','Alondra','Zev',3,570);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (75,'Retirement Plan Consultants','6435 North Palm Ave, Ste 101',null,'Fresno','CA','93704','(559) 555-7070','Edgardo','Salina',3,589);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (76,'Simon Direct Inc','4 Cornwall Dr Ste 102',null,'East Brunswick','NJ','08816','(908) 555-7222','Bradlee','Daniel',2,540);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (77,'State Board Of Equalization','PO Box 942808',null,'Sacramento','CA','94208','(916) 555-4911','Dean','Julissa',1,631);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (78,'The Presort Center','1627 "E" Street',null,'Fresno','CA','93706','(559) 555-6151','Marissa','Kyle',3,540);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (79,'Valprint','PO Box 12332',null,'Fresno','CA','93777','(559) 555-3112','Warren','Quentin',3,551);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (80,'Cardinal Business Media, Inc.','P O Box 7247-7844',null,'Philadelphia','PA','19170','(215) 555-1500','Eulalia','Kelsey',2,540);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (81,'Wang Laboratories, Inc.','P.O. Box 21209',null,'Pasadena','CA','91185','(800) 555-0344','Kapil','Robert',2,160);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (82,'Reiter''s Scientific & Pro Books','2021 K Street Nw',null,'Washington','DC','20006','(202) 555-5561','Rodolfo','Carlee',2,572);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (83,'Ingram','PO Box 845361',null,'Dallas','TX','75284',null,'Yobani','Trey',2,572);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (84,'Boucher Communications Inc','1300 Virginia Dr. Ste 400',null,'Fort Washington','PA','19034','(215) 555-8000','Carson','Julian',3,540);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (85,'Champion Printing Company','3250 Spring Grove Ave',null,'Cincinnati','OH','45225','(800) 555-1957','Clifford','Jillian',3,540);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (86,'Computerworld','Department #1872','PO Box 61000','San Francisco','CA','94161','(617) 555-0700','Lloyd','Angel',1,572);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (87,'DMV Renewal','PO Box 942894',null,'Sacramento','CA','94294',null,'Josey','Lorena',6,568);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (88,'Edward Data Services','4775 E Miami River Rd',null,'Cleves','OH','45002','(513) 555-3043','Helena','Jeanette',1,540);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (89,'Evans Executone Inc','4918 Taylor Ct',null,'Turlock','CA','95380',null,'Royce','Hannah',1,522);

insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'Wakefield Co','295 W Cromwell Ave Ste 106',null,'Fresno','CA','93711','(559) 555-4744','Rothman','Nathanael',2,170);

insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'McKesson Water Products','P O Box 7126',null,'Pasadena','CA','91109','(800) 555-7009','Destin','Luciano',2,570);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'Zip Print & Copy Center','PO Box 12332',null,'Fresno','CA','93777','(233) 555-6400','Javen','Justin',2,540);

insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'AT&T','PO Box 78225',null,'Phoenix','AZ','85062',null,'Wesley','Alisha',3,522);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'Abbey Office Furnishings','4150 W Shaw Ave',null,'Fresno','CA','93722','(559) 555-8300','Francis','Kyra',2,150);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'Pacific Bell',null,null,'Sacramento','CA','95887','(209) 555-7500','Nickalus','Kurt',2,522);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'Wells Fargo Bank','Business Mastercard','P.O. Box 29479','Phoenix','AZ','85038','(947) 555-3900','Damion','Mikayla',2,160);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'Compuserve','Dept L-742',null,'Columbus','OH','43260','(614) 555-8600','Armando','Jan',2,572);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'American Express','Box 0001',null,'Los Angeles','CA','90096','(800) 555-3344','Story','Kirsten',2,160);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'Bertelsmann Industry Svcs. Inc','28210 N Avenue Stanford',null,'Valencia','CA','91355','(805) 555-0584','Potter','Lance',3,400);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'Cahners Publishing Company','Citibank Lock Box 4026','8725 W Sahara Zone 1127','The Lake','NV','89163','(301) 555-2162','Jacobsen','Samuel',6,540);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'California Business Machines','Gallery Plz','5091 N Fresno','Fresno','CA','93710','(559) 555-5570','Rohansen','Anders',2,170);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'Coffee Break Service','PO Box 1091',null,'Fresno','CA','93714','(559) 555-8700','Smitzen','Jeffrey',6,570);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'Dean Witter Reynolds','9 River Pk Pl E 400',null,'Boston','MA','02134','(508) 555-8737','Johnson','Vance',9,589);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'Digital Dreamworks','5070 N Sixth Ste. 71',null,'Fresno','CA','93711',null,'Elmert','Ron',3,589);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'Dristas Groom & McCormick','7112 N Fresno St Ste 200',null,'Fresno','CA','93720','(559) 555-8484','Aaronsen','Thom',3,591);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'Ford Motor Credit Company','Dept 0419',null,'Los Angeles','CA','90084','(800) 555-7000','Snyder','Karen',3,582);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'Franchise Tax Board','PO Box 942857',null,'Sacramento','CA','94257',null,'Prado','Anita',6,507);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'Gostanian General Building','427 W Bedford #102',null,'Fresno','CA','93711','(559) 555-5100','Bragg','Walter',6,523);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'Kent H Landsberg Co','File No 72686','PO Box 61000','San Francisco','CA','94160','(916) 555-8100','Stevens','Wendy',3,540);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'Malloy Lithographing Inc','5411 Jackson Road','PO Box 1124','Ann Arbor','MI','48106','(313) 555-6113','Regging','Abe',3,400);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'Net Asset, Llc','1315 Van Ness Ave Ste. 103',null,'Fresno','CA','93721',null,'Kraggin','Laura',1,572);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'Office Depot','File No 81901',null,'Los Angeles','CA','90074','(800) 555-1711','Pinsippi','Val',3,570);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'Pollstar','4697 W Jacquelyn Ave',null,'Fresno','CA','93722','(559) 555-2631','Aranovitch','Robert',9,520);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'Postmaster','Postage Due Technician','1900 E Street','Fresno','CA','93706','(559) 555-7785','Finklestein','Fyodor',1,552);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'Roadway Package System, Inc','Dept La 21095',null,'Pasadena','CA','91185',null,'Smith','Sam',6,553);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'State of California','Employment Development Dept','PO Box 826276','Sacramento','CA','94230','(209) 555-5132','Articunia','Mercedez',1,631);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'Suburban Propane','2874 S Cherry Ave',null,'Fresno','CA','93706','(559) 555-2770','Spivak','Harold',3,521);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'Unocal','P.O. Box 860070',null,'Pasadena','CA','91186','(415) 555-7600','Bluzinski','Rachael',3,582);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'Yesmed, Inc','PO Box 2061',null,'Fresno','CA','93718','(559) 555-0600','Hernandez','Reba',2,589);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'Dataforms/West','1617 W. Shaw Avenue','Suite F','Fresno','CA','93711',null,'Church','Charlie',3,551);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'Zylka Design','3467 W Shaw Ave #103',null,'Fresno','CA','93711','(559) 555-8625','Ronaldsen','Jaime',3,403);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'United Parcel Service','P.O. Box 505820',null,'Reno','NV','88905','(800) 555-0855','Beauregard','Violet',3,553);
insert into vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'Federal Express Corporation','P.O. Box 1140','Dept A','Memphis','TN','38101','(800) 555-4091','Bucket','Charlie',3,553);
insert into vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
values (vendor_id_seq.nextval,'Costco Wholesale','1150 Bunker Hill Rd.',null,'Houston','TX','77055','(713) 576-2053','Devolio','Lauren',3,570);

-- insert into vendor_contacts 
insert into vendor_contacts (vendor_id,last_name,first_name,ven_con_cell_ph) values 
(5,'Davison','Michelle','(832) 555-3344');
insert into vendor_contacts (vendor_id,last_name,first_name,ven_con_cell_ph) values 
(12,'Mayteh','Kendall','(832) 421-8335');
insert into vendor_contacts (vendor_id,last_name,first_name,ven_con_cell_ph) values 
(17,'Onandenga','Bruce','(713) 899-3319');
insert into vendor_contacts (vendor_id,last_name,first_name,ven_con_cell_ph) values 
(44,'Antavius','Anthony','(281) 946-1007');
insert into vendor_contacts (vendor_id,last_name,first_name,ven_con_cell_ph) values 
(76,'Bradlee','Danny','(713) 542-3318');
insert into vendor_contacts (vendor_id,last_name,first_name,ven_con_cell_ph) values 
(102,'Suscipe','Reynaldo','(409) 432-0006');
insert into vendor_contacts (vendor_id,last_name,first_name,ven_con_cell_ph) values 
(123,'O''Sullivan','Geraldine','(230) 651-9872');
insert into vendor_contacts (vendor_id,last_name,first_name,ven_con_cell_ph) values 
(192,'Bucket','Charles','(832) 677-9902');

-- insert into invoices 
insert into invoices  values (1,34,'QP58872',to_date('06-OCT-22','DD-MON-RR'),116.54,116.54,0,6,to_date('05-DEC-22','DD-MON-RR'),to_date('20-NOV-22','DD-MON-RR'));
insert into invoices  values (2,34,'Q545443',to_date('23-OCT-22','DD-MON-RR'),1083.58,1083.58,0,6,to_date('22-DEC-22','DD-MON-RR'),to_date('21-DEC-22','DD-MON-RR'));
insert into invoices  values (3,150,'P-0608',to_date('11-APR-22','DD-MON-RR'),20551.18,0,1200,9,to_date('10-JUL-22','DD-MON-RR'),null);
insert into invoices  values (4,150,'P-0259',to_date('25-NOV-22','DD-MON-RR'),26881.4,26881.4,0,3,to_date('25-DEC-22','DD-MON-RR'),to_date('21-DEC-22','DD-MON-RR'));
insert into invoices  values (5,81,'MABO1489',to_date('25-NOV-22','DD-MON-RR'),936.93,936.93,0,3,to_date('25-DEC-22','DD-MON-RR'),to_date('22-DEC-22','DD-MON-RR'));
insert into invoices  values (6,186,'989319-497',to_date('17-APR-22','DD-MON-RR'),2312.2,0,0,6,to_date('16-JUN-22','DD-MON-RR'),null);
insert into invoices  values (7,82,'C73-24',to_date('26-NOV-22','DD-MON-RR'),600,600,0,2,to_date('16-DEC-22','DD-MON-RR'),to_date('14-DEC-22','DD-MON-RR'));
insert into invoices  values (8,186,'989319-487',to_date('18-APR-22','DD-MON-RR'),1927.54,0,0,6,to_date('17-JUN-22','DD-MON-RR'),null);
insert into invoices  values (9,186,'989319-477',to_date('28-NOV-22','DD-MON-RR'),2184.11,2184.11,0,6,to_date('27-JAN-23','DD-MON-RR'),to_date('16-JAN-23','DD-MON-RR'));
insert into invoices  values (10,186,'989319-467',to_date('03-DEC-22','DD-MON-RR'),2318.03,2318.03,0,6,to_date('01-FEB-23','DD-MON-RR'),to_date('07-JAN-23','DD-MON-RR'));
insert into invoices  values (11,186,'989319-457',to_date('03-DEC-22','DD-MON-RR'),3813.33,3813.33,0,3,to_date('02-JAN-23','DD-MON-RR'),to_date('29-DEC-22','DD-MON-RR'));
insert into invoices  values (12,186,'989319-447',to_date('03-DEC-22','DD-MON-RR'),3689.99,3689.99,0,3,to_date('02-JAN-23','DD-MON-RR'),to_date('21-DEC-22','DD-MON-RR'));
insert into invoices  values (13,186,'989319-437',to_date('03-DEC-22','DD-MON-RR'),2765.36,2765.36,0,2,to_date('23-DEC-22','DD-MON-RR'),to_date('12-DEC-22','DD-MON-RR'));
insert into invoices  values (14,186,'989319-427',to_date('04-DEC-22','DD-MON-RR'),2115.81,2115.81,0,1,to_date('14-DEC-22','DD-MON-RR'),to_date('14-DEC-22','DD-MON-RR'));
insert into invoices  values (15,183,'97/553B',to_date('26-APR-22','DD-MON-RR'),313.55,0,0,6,to_date('09-JUL-22','DD-MON-RR'),null);
insert into invoices  values (16,186,'989319-417',to_date('05-DEC-22','DD-MON-RR'),2051.59,2051.59,0,1,to_date('15-DEC-22','DD-MON-RR'),to_date('07-DEC-22','DD-MON-RR'));
insert into invoices  values (17,90,'97-1024A',to_date('05-DEC-22','DD-MON-RR'),356.48,356.48,0,3,to_date('04-JAN-23','DD-MON-RR'),to_date('12-JAN-23','DD-MON-RR'));
insert into invoices  values (18,183,'97/553',to_date('27-APR-22','DD-MON-RR'),904.14,0,0,6,to_date('26-JUN-22','DD-MON-RR'),null);
insert into invoices  values (19,183,'97/522',to_date('30-APR-22','DD-MON-RR'),1962.13,0,200,6,to_date('29-JUN-22','DD-MON-RR'),null);
insert into invoices  values (20,183,'97/503',to_date('09-DEC-22','DD-MON-RR'),639.77,639.77,0,6,to_date('07-FEB-23','DD-MON-RR'),to_date('14-JAN-23','DD-MON-RR'));
insert into invoices  values (21,183,'97/488',to_date('09-DEC-22','DD-MON-RR'),601.95,601.95,0,3,to_date('08-JAN-23','DD-MON-RR'),to_date('05-JAN-23','DD-MON-RR'));
insert into invoices  values (22,183,'97/486',to_date('09-DEC-22','DD-MON-RR'),953.1,953.1,0,2,to_date('29-DEC-22','DD-MON-RR'),to_date('22-DEC-22','DD-MON-RR'));
insert into invoices  values (23,183,'97/465',to_date('10-DEC-22','DD-MON-RR'),565.15,565.15,0,1,to_date('20-DEC-22','DD-MON-RR'),to_date('14-DEC-22','DD-MON-RR'));
insert into invoices  values (24,183,'97/222',to_date('10-DEC-22','DD-MON-RR'),1000.46,1000.46,0,3,to_date('09-JAN-23','DD-MON-RR'),to_date('03-JAN-23','DD-MON-RR'));
insert into invoices  values (25,189,'4-342-8069',to_date('10-DEC-22','DD-MON-RR'),10,10,0,6,to_date('08-FEB-23','DD-MON-RR'),to_date('05-JAN-23','DD-MON-RR'));
insert into invoices  values (26,189,'4-327-7357',to_date('10-DEC-22','DD-MON-RR'),162.75,162.75,0,3,to_date('09-JAN-23','DD-MON-RR'),to_date('30-DEC-22','DD-MON-RR'));
insert into invoices  values (27,189,'4-321-2596',to_date('10-DEC-22','DD-MON-RR'),10,10,0,2,to_date('30-DEC-22','DD-MON-RR'),to_date('20-DEC-22','DD-MON-RR'));
insert into invoices  values (28,189,'7548906-20',to_date('10-DEC-22','DD-MON-RR'),27,27,0,3,to_date('09-JAN-23','DD-MON-RR'),to_date('04-JAN-23','DD-MON-RR'));
insert into invoices  values (29,189,'4-314-3057',to_date('11-DEC-22','DD-MON-RR'),13.75,13.75,0,1,to_date('21-DEC-22','DD-MON-RR'),to_date('16-DEC-22','DD-MON-RR'));
insert into invoices  values (30,102,'203339-13',to_date('02-MAY-22','DD-MON-RR'),17.5,0,0,3,to_date('01-JUN-22','DD-MON-RR'),null);
insert into invoices  values (31,189,'2-000-2993',to_date('12-DEC-22','DD-MON-RR'),144.7,144.7,0,1,to_date('22-DEC-22','DD-MON-RR'),to_date('13-DEC-22','DD-MON-RR'));
insert into invoices  values (32,89,'125520-1',to_date('14-DEC-22','DD-MON-RR'),95,95,0,3,to_date('13-JAN-23','DD-MON-RR'),to_date('31-DEC-22','DD-MON-RR'));
insert into invoices  values (33,189,'1-202-2978',to_date('15-DEC-22','DD-MON-RR'),33,33,0,1,to_date('25-DEC-22','DD-MON-RR'),to_date('22-DEC-22','DD-MON-RR'));
insert into invoices  values (34,150,'0-2436',to_date('07-MAY-22','DD-MON-RR'),10976.06,0,0,6,to_date('06-JUL-22','DD-MON-RR'),null);
insert into invoices  values (35,189,'1-200-5164',to_date('16-DEC-22','DD-MON-RR'),63.4,63.4,0,1,to_date('26-DEC-22','DD-MON-RR'),to_date('19-DEC-22','DD-MON-RR'));
insert into invoices  values (36,150,'0-2060',to_date('17-DEC-22','DD-MON-RR'),23517.58,21221.63,2295.95,3,to_date('18-JAN-23','DD-MON-RR'),to_date('19-JAN-23','DD-MON-RR'));
insert into invoices  values (37,150,'0-2058',to_date('17-DEC-22','DD-MON-RR'),37966.19,37966.19,0,3,to_date('16-JAN-23','DD-MON-RR'),to_date('09-JAN-23','DD-MON-RR'));
insert into invoices  values (38,189,'963253272',to_date('09-MAY-22','DD-MON-RR'),61.5,0,0,6,to_date('08-JUL-22','DD-MON-RR'),null);
insert into invoices  values (39,189,'963253271',to_date('09-MAY-22','DD-MON-RR'),158,0,0,6,to_date('08-JUL-22','DD-MON-RR'),null);
insert into invoices  values (40,189,'963253269',to_date('09-MAY-22','DD-MON-RR'),26.75,0,0,6,to_date('08-JUL-22','DD-MON-RR'),null);
insert into invoices  values (41,189,'963253267',to_date('09-MAY-22','DD-MON-RR'),23.5,0,0,6,to_date('08-JUL-22','DD-MON-RR'),null);
insert into invoices  values (42,111,'21-4748363',to_date('09-MAY-22','DD-MON-RR'),9.95,0,0,6,to_date('08-JUL-22','DD-MON-RR'),null);
insert into invoices  values (43,111,'21-4923721',to_date('18-DEC-22','DD-MON-RR'),9.95,9.95,0,1,to_date('28-DEC-22','DD-MON-RR'),to_date('22-DEC-22','DD-MON-RR'));
insert into invoices  values (44,189,'963253264',to_date('10-MAY-22','DD-MON-RR'),52.25,0,0,6,to_date('09-JUL-22','DD-MON-RR'),null);
insert into invoices  values (45,189,'963253263',to_date('10-MAY-22','DD-MON-RR'),109.5,0,0,6,to_date('09-JUL-22','DD-MON-RR'),null);
insert into invoices  values (46,189,'963253261',to_date('19-DEC-22','DD-MON-RR'),42.75,42.75,0,3,to_date('18-JAN-23','DD-MON-RR'),to_date('19-JAN-23','DD-MON-RR'));
insert into invoices  values (47,189,'963253260',to_date('19-DEC-22','DD-MON-RR'),36,36,0,3,to_date('18-JAN-23','DD-MON-RR'),to_date('15-JAN-23','DD-MON-RR'));
insert into invoices  values (48,189,'963253258',to_date('19-DEC-22','DD-MON-RR'),111,111,0,3,to_date('18-JAN-23','DD-MON-RR'),to_date('09-JAN-23','DD-MON-RR'));
insert into invoices  values (49,189,'963253256',to_date('19-DEC-22','DD-MON-RR'),53.25,53.25,0,3,to_date('18-JAN-23','DD-MON-RR'),to_date('05-JAN-23','DD-MON-RR'));
insert into invoices  values (50,189,'963253255',to_date('20-DEC-22','DD-MON-RR'),53.75,53.75,0,3,to_date('19-JAN-23','DD-MON-RR'),to_date('12-JAN-23','DD-MON-RR'));
insert into invoices  values (51,189,'963253254',to_date('20-DEC-22','DD-MON-RR'),108.5,108.5,0,3,to_date('19-JAN-23','DD-MON-RR'),to_date('08-JAN-23','DD-MON-RR'));
insert into invoices  values (52,189,'963253252',to_date('20-DEC-22','DD-MON-RR'),38.75,38.75,0,3,to_date('19-JAN-23','DD-MON-RR'),to_date('05-JAN-23','DD-MON-RR'));
insert into invoices  values (53,189,'963253251',to_date('20-DEC-22','DD-MON-RR'),15.5,15.5,0,3,to_date('19-JAN-23','DD-MON-RR'),to_date('30-DEC-22','DD-MON-RR'));
insert into invoices  values (54,189,'963253249',to_date('21-DEC-22','DD-MON-RR'),127.75,127.75,0,2,to_date('10-JAN-23','DD-MON-RR'),to_date('06-JAN-23','DD-MON-RR'));
insert into invoices  values (55,189,'963253248',to_date('22-DEC-22','DD-MON-RR'),241,241,0,2,to_date('11-JAN-23','DD-MON-RR'),to_date('02-JAN-23','DD-MON-RR'));
insert into invoices  values (56,189,'963253246',to_date('22-DEC-22','DD-MON-RR'),129,129,0,2,to_date('11-JAN-23','DD-MON-RR'),to_date('29-DEC-22','DD-MON-RR'));
insert into invoices  values (57,189,'963253245',to_date('22-DEC-22','DD-MON-RR'),40.75,40.75,0,2,to_date('11-JAN-23','DD-MON-RR'),to_date('23-DEC-22','DD-MON-RR'));
insert into invoices  values (58,189,'963253244',to_date('22-DEC-22','DD-MON-RR'),60,60,0,2,to_date('11-JAN-23','DD-MON-RR'),to_date('30-DEC-22','DD-MON-RR'));
insert into invoices  values (59,189,'963253242',to_date('22-DEC-22','DD-MON-RR'),104,104,0,2,to_date('11-JAN-23','DD-MON-RR'),to_date('26-DEC-22','DD-MON-RR'));
insert into invoices  values (60,189,'963253240',to_date('01-JAN-23','DD-MON-RR'),67,67,0,1,to_date('11-JAN-23','DD-MON-RR'),to_date('06-JAN-23','DD-MON-RR'));
insert into invoices  values (61,189,'963253239',to_date('01-JAN-23','DD-MON-RR'),147.25,147.25,0,1,to_date('11-JAN-23','DD-MON-RR'),to_date('06-JAN-23','DD-MON-RR'));
insert into invoices  values (62,189,'963253237',to_date('01-JAN-23','DD-MON-RR'),172.5,172.5,0,1,to_date('11-JAN-23','DD-MON-RR'),to_date('02-JAN-23','DD-MON-RR'));
insert into invoices  values (63,189,'963253235',to_date('23-DEC-22','DD-MON-RR'),108.25,108.25,0,1,to_date('02-JAN-23','DD-MON-RR'),to_date('26-DEC-22','DD-MON-RR'));
insert into invoices  values (64,189,'963253234',to_date('23-DEC-22','DD-MON-RR'),138.75,138.75,0,1,to_date('02-JAN-23','DD-MON-RR'),to_date('25-DEC-22','DD-MON-RR'));
insert into invoices  values (65,189,'963253232',to_date('23-DEC-22','DD-MON-RR'),127.75,127.75,0,1,to_date('02-JAN-23','DD-MON-RR'),to_date('25-DEC-22','DD-MON-RR'));
insert into invoices  values (66,189,'963253230',to_date('24-DEC-22','DD-MON-RR'),739.2,739.2,0,1,to_date('03-JAN-23','DD-MON-RR'),to_date('25-DEC-22','DD-MON-RR'));
insert into invoices  values (67,189,'43966316',to_date('17-MAY-22','DD-MON-RR'),10,0,0,3,to_date('16-JUN-22','DD-MON-RR'),null);
insert into invoices  values (68,189,'263253273',to_date('17-MAY-22','DD-MON-RR'),30.75,0,0,6,to_date('16-JUL-22','DD-MON-RR'),null);
insert into invoices  values (69,37,'547479217',to_date('17-MAY-22','DD-MON-RR'),116,0,0,3,to_date('16-JUN-22','DD-MON-RR'),null);
insert into invoices  values (70,189,'263253270',to_date('18-MAY-22','DD-MON-RR'),67.92,0,0,3,to_date('17-JUN-22','DD-MON-RR'),null);
insert into invoices  values (71,189,'263253268',to_date('18-MAY-22','DD-MON-RR'),59.97,0,0,3,to_date('17-JUN-22','DD-MON-RR'),null);
insert into invoices  values (72,189,'263253265',to_date('18-MAY-22','DD-MON-RR'),26.25,0,0,3,to_date('17-JUN-22','DD-MON-RR'),null);
insert into invoices  values (73,189,'263253257',to_date('27-DEC-22','DD-MON-RR'),22.57,22.57,0,2,to_date('16-JAN-23','DD-MON-RR'),to_date('05-JAN-23','DD-MON-RR'));
insert into invoices  values (74,189,'263253253',to_date('27-DEC-22','DD-MON-RR'),31.95,31.95,0,2,to_date('16-JAN-23','DD-MON-RR'),to_date('10-JAN-23','DD-MON-RR'));
insert into invoices  values (75,189,'263253250',to_date('28-DEC-22','DD-MON-RR'),42.67,42.67,0,2,to_date('17-JAN-23','DD-MON-RR'),to_date('03-JAN-23','DD-MON-RR'));
insert into invoices  values (76,189,'263253243',to_date('29-DEC-22','DD-MON-RR'),44.44,44.44,0,1,to_date('08-JAN-23','DD-MON-RR'),to_date('01-JAN-23','DD-MON-RR'));
insert into invoices  values (77,189,'263253241',to_date('31-DEC-22','DD-MON-RR'),40.2,40.2,0,1,to_date('10-JAN-23','DD-MON-RR'),to_date('31-DEC-22','DD-MON-RR'));
insert into invoices  values (78,189,'94007069',to_date('31-DEC-22','DD-MON-RR'),400,400,0,3,to_date('30-JAN-23','DD-MON-RR'),to_date('03-FEB-23','DD-MON-RR'));
insert into invoices  values (79,189,'963253262',to_date('22-MAY-22','DD-MON-RR'),42.5,0,0,3,to_date('21-JUN-22','DD-MON-RR'),null);
insert into invoices  values (80,135,'94007005',to_date('01-JAN-23','DD-MON-RR'),220,220,0,1,to_date('11-JAN-23','DD-MON-RR'),to_date('04-JAN-23','DD-MON-RR'));
insert into invoices  values (81,83,'31359783',to_date('23-MAY-22','DD-MON-RR'),1575,0,0,2,to_date('12-JUN-22','DD-MON-RR'),null);
insert into invoices  values (82,165,'25022117',to_date('24-MAY-22','DD-MON-RR'),6,0,0,3,to_date('23-JUN-22','DD-MON-RR'),null);
insert into invoices  values (83,165,'24946731',to_date('03-JAN-23','DD-MON-RR'),25.67,25.67,0,2,to_date('23-JAN-23','DD-MON-RR'),to_date('06-JAN-23','DD-MON-RR'));
insert into invoices  values (84,165,'24863706',to_date('05-JAN-23','DD-MON-RR'),6,6,0,1,to_date('15-JAN-23','DD-MON-RR'),to_date('10-JAN-23','DD-MON-RR'));
insert into invoices  values (85,165,'24780512',to_date('07-JAN-23','DD-MON-RR'),6,6,0,1,to_date('17-JAN-23','DD-MON-RR'),to_date('08-JAN-23','DD-MON-RR'));
insert into invoices  values (86,88,'972110',to_date('08-JAN-23','DD-MON-RR'),207.78,207.78,0,1,to_date('18-JAN-23','DD-MON-RR'),to_date('11-JAN-23','DD-MON-RR'));
insert into invoices  values (87,120,'587056',to_date('09-JAN-23','DD-MON-RR'),2184.5,2184.5,0,3,to_date('08-FEB-23','DD-MON-RR'),to_date('31-JAN-23','DD-MON-RR'));
insert into invoices  values (88,86,'367447',to_date('31-MAY-22','DD-MON-RR'),2433,0,0,3,to_date('30-JUN-22','DD-MON-RR'),null);
insert into invoices  values (89,117,'509786',to_date('09-JAN-23','DD-MON-RR'),6940.25,6940.25,0,2,to_date('29-JAN-23','DD-MON-RR'),to_date('17-JAN-23','DD-MON-RR'));
insert into invoices  values (90,144,'121897',to_date('10-JAN-23','DD-MON-RR'),450,450,0,2,to_date('30-JAN-23','DD-MON-RR'),to_date('23-JAN-23','DD-MON-RR'));
insert into invoices  values (91,80,'134116',to_date('01-JUN-22','DD-MON-RR'),90.36,0,0,3,to_date('01-JUL-22','DD-MON-RR'),null);
insert into invoices  values (92,80,'133560',to_date('10-JAN-23','DD-MON-RR'),175,175,0,2,to_date('30-JAN-23','DD-MON-RR'),to_date('12-JAN-23','DD-MON-RR'));
insert into invoices  values (93,132,'P02-3772',to_date('12-JAN-23','DD-MON-RR'),7125.34,7125.34,0,2,to_date('01-FEB-23','DD-MON-RR'),to_date('17-JAN-23','DD-MON-RR'));
insert into invoices  values (94,138,'9982771',to_date('03-JUN-22','DD-MON-RR'),503.2,0,0,2,to_date('23-JUN-22','DD-MON-RR'),null);
insert into invoices  values (95,141,'RTR-72-3662-X',to_date('13-JAN-23','DD-MON-RR'),1600,1600,0,2,to_date('02-FEB-23','DD-MON-RR'),to_date('20-JAN-23','DD-MON-RR'));
insert into invoices  values (96,159,'77290',to_date('13-JAN-23','DD-MON-RR'),1750,1750,0,2,to_date('02-FEB-23','DD-MON-RR'),to_date('17-JAN-23','DD-MON-RR'));
insert into invoices  values (97,177,'10843',to_date('13-JAN-23','DD-MON-RR'),4901.26,4901.26,0,2,to_date('02-FEB-23','DD-MON-RR'),to_date('20-JAN-23','DD-MON-RR'));
insert into invoices  values (98,105,'111-92R-10092',to_date('04-JUN-22','DD-MON-RR'),46.21,0,0,1,to_date('14-JUN-22','DD-MON-RR'),null);
insert into invoices  values (99,105,'111-92R-10093',to_date('05-JUN-22','DD-MON-RR'),39.77,0,0,2,to_date('25-JUN-22','DD-MON-RR'),null);
insert into invoices  values (100,108,'I77271-O01',to_date('05-JUN-22','DD-MON-RR'),662,0,0,2,to_date('25-JUN-22','DD-MON-RR'),null);
insert into invoices  values (101,129,'75C-90227',to_date('15-JAN-23','DD-MON-RR'),1367.5,1367.5,0,1,to_date('25-JAN-23','DD-MON-RR'),to_date('18-JAN-23','DD-MON-RR'));
insert into invoices  values (102,48,'P02-88D77S7',to_date('15-JAN-23','DD-MON-RR'),856.92,856.92,0,1,to_date('25-JAN-23','DD-MON-RR'),to_date('18-JAN-23','DD-MON-RR'));
insert into invoices  values (103,105,'111-92R-10094',to_date('06-JUN-22','DD-MON-RR'),19.67,0,0,1,to_date('16-JUN-22','DD-MON-RR'),null);
insert into invoices  values (104,162,'CBM9920-M-T77109',to_date('16-JAN-23','DD-MON-RR'),290,290,0,1,to_date('26-JAN-23','DD-MON-RR'),to_date('18-JAN-23','DD-MON-RR'));
insert into invoices  values (105,105,'111-92R-10095',to_date('07-JUN-22','DD-MON-RR'),32.7,0,0,3,to_date('07-JUL-22','DD-MON-RR'),null);
insert into invoices  values (106,105,'111-92R-10096',to_date('08-JUN-22','DD-MON-RR'),16.33,0,0,2,to_date('28-JUN-22','DD-MON-RR'),null);
insert into invoices  values (107,105,'111-92R-10097',to_date('08-JUN-22','DD-MON-RR'),16.33,0,0,1,to_date('18-JUN-22','DD-MON-RR'),null);
insert into invoices  values (108,171,'111897',to_date('20-JAN-23','DD-MON-RR'),16.62,16.62,0,1,to_date('30-JAN-23','DD-MON-RR'),to_date('21-JAN-23','DD-MON-RR'));
insert into invoices  values (109,126,'109596',to_date('14-JUN-22','DD-MON-RR'),41.8,0,0,3,to_date('14-JUL-22','DD-MON-RR'),null);
insert into invoices  values (110,72,'39104',to_date('20-JUN-22','DD-MON-RR'),85.31,0,0,3,to_date('20-JUL-22','DD-MON-RR'),null);
insert into invoices  values (111,37,'547480102',to_date('19-MAY-22','DD-MON-RR'),224,0,0,3,to_date('18-JUN-22','DD-MON-RR'),null);
insert into invoices  values (112,37,'547481328',to_date('20-MAY-22','DD-MON-RR'),224,0,0,3,to_date('19-JUN-22','DD-MON-RR'),null);
insert into invoices  values (113,72,'40318',to_date('18-JUL-22','DD-MON-RR'),21842,0,0,3,to_date('17-AUG-22','DD-MON-RR'),null);
insert into invoices  values (114,83,'31361833',to_date('23-MAY-22','DD-MON-RR'),579.42,0,0,2,to_date('12-JUN-22','DD-MON-RR'),null);

-- inserting into invoice_line_items
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (1,1,572,116.54,'MVS Online Library');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (2,1,572,1083.58,'MSDN');

insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (3,1,181,20551.18,'CICS Part 2');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (4,1,167,26881.4,'MVS JCL');

insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (5,1,527,936.93,'Quarterly Maintenance');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (6,1,553,2312.2,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (7,1,541,600,'Trade advertising');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (8,1,553,1927.54,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (9,1,553,2184.11,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (10,1,553,2318.03,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (11,1,553,3813.33,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (12,1,553,3689.99,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (13,1,553,2765.36,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (14,1,553,2115.81,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (15,1,540,313.55,'Card revision');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (16,1,553,2051.59,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (17,1,523,356.48,'Network wiring');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (18,1,540,904.14,'DB2 Card decks');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (19,1,536,1197,'MC Bouncebacks');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (19,2,540,765.13,'SCMD Flyer');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (20,1,536,639.77,'Card deck');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (21,1,536,601.95,'Card deck revision');

insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (22,1,536,953.1,'Crash Course revision');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (23,1,541,565.15,'Crash Course Ad');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (24,1,540,1000.46,'Crash Course Cover');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (25,1,553,10,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (26,1,553,162.75,'International shipment');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (27,1,553,10,'Address correction');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (28,1,553,27,'Freight');

insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (29,1,553,13.75,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (30,1,570,17.5,'Supplies');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (31,1,553,144.7,'Int''l shipment');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (32,1,523,95.00,'Telephone service');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (33,1,553,33.00,'Freight');

insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (34,1,181,10976.06,'VSAM for the Cobol Programmer');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (35,1,553,63.4,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (36,1,181,23517.58,'DB2 Part 1');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (37,1,181,37966.19,'CICS Desk Reference');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (38,1,553,61.5,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (39,1,553,158,'Int''l shipment');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (40,1,553,26.75,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (41,1,553,23.5,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (42,1,572,9.95,'Monthly access fee');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (43,1,572,9.95,'Monthly access fee');

insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (44,1,553,52.25,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (45,1,553,109.5,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (46,1,553,42.75,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (47,1,553,36,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (48,1,553,111,'Freight');

insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (49,1,553,53.25,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (50,1,553,53.75,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (51,1,553,108.5,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (52,1,553,38.75,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (53,1,553,15.5,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (54,1,553,127.75,'Freight');

insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (55,1,553,241,'Int''l shipment');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (56,1,553,129,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (57,1,553,40.75,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (58,1,553,60,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (59,1,553,104.00,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (60,1,553,67,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (61,1,553,147.25,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (62,1,553,172.5,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (63,1,553,108.25,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (64,1,553,138.75,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (65,1,553,127.75,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (66,1,553,739.2,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (67,1,553,10,'Address correction');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (68,1,553,30.75,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (69,1,510,116,'Health Insurance');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (70,1,553,67.92,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (71,1,553,59.97,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (72,1,553,26.25,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (73,1,553,22.57,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (74,1,553,31.95,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (75,1,553,42.67,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (76,1,553,44.44,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (77,1,553,40.2,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (78,1,553,400,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (79,1,553,42.5,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (80,1,591,220,'Form 571-L');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (81,1,541,1575,'Catalog ad');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (82,1,553,6,'Freight out');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (83,1,553,25.67,'Freight out');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (84,1,552,6,'Freight out');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (85,1,553,6,'Freight');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (86,1,540,207.78,'Prospect list');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (87,1,536,2184.5,'PC card deck');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (88,1,536,2433,'Card deck');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (89,1,181,6940.25,'OS Utilities');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (90,1,523,450,'Back office additions');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (91,1,536,90.36,'Card deck advertising');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (92,1,536,175,'Card deck advertising');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (93,1,548,7125.34,'Web site design');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (94,1,569,503.2,'Bronco lease');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (95,1,235,1600,'Income Tax');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (96,1,520,1750,'Warehouse lease');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (97,1,520,4901.26,'Office lease');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (98,1,522,46.21,'Telephone (Line 1)');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (99,1,522,39.77,'Telephone (Line 2)');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (100,1,580,50,'DiCicco''s');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (100,2,540,75.6,'Kinko''s');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (100,3,570,58.4,'Office Max');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (100,4,546,478,'Publishers Marketing');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (101,1,221,1367.5,'401K Contributions');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (102,1,574,856.92,'Property Taxes');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (103,1,522,19.67,'Telephone (Line 3)');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (104,1,552,290,'International pkg.');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (105,1,522,32.7,'Telephone (line 4)');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (106,1,522,16.33,'Telephone (line 5)');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (107,1,522,16.33,'Telephone (line 6)');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (108,1,589,16.62,'Propane-forklift');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (109,1,580,41.8,'Coffee');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (110,1,540,85.31,'Book copy');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (111,1,510,224,'Health Insurance');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (112,1,510,224,'Health Insurance');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (113,1,540,21842,'Book repro');
insert into invoice_line_items 
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description) 
values (114,1,541,579.42,'Catalog ad');

-- inserting into active_invoices

insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(3,150,'P-0608',to_date('11-APR-22','DD-MON-RR'),20551.18,0,1200.00,9,to_date('10-JUL-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(6,186,'989319-497',to_date('17-APR-22','DD-MON-RR'),2312.20,0,0,6,to_date('16-JUN-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(8,186,'989319-487',to_date('18-APR-22','DD-MON-RR'),1927.54,0,0,6,to_date('17-JUN-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(15,183,'97/553B',to_date('26-APR-22','DD-MON-RR'),313.55,0,0,6,to_date('09-JUL-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(18,183,'97/553',to_date('27-APR-22','DD-MON-RR'),904.14,0,0,6,to_date('26-JUN-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(19,183,'97/522',to_date('30-APR-22','DD-MON-RR'),1962.13,0,200,6,to_date('29-JUN-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(30,102,'203339-13',to_date('02-MAY-22','DD-MON-RR'),17.50,0,0,3,to_date('01-JUN-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(34,150,'0-2436',to_date('07-MAY-22','DD-MON-RR'),10976.06,0,0,6,to_date('06-JUL-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(38,189,'963253272',to_date('09-MAY-22','DD-MON-RR'),61.50,0,0,6,to_date('08-JUL-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(39,189,'963253271',to_date('09-MAY-22','DD-MON-RR'),158.00,0,0,6,to_date('08-JUL-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(40,189,'963253269',to_date('09-MAY-22','DD-MON-RR'),26.75,0,0,6,to_date('08-JUN-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(41,189,'963253267',to_date('09-MAY-22','DD-MON-RR'),23.50,0,0,6,to_date('08-JUN-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(42,111,'21-4748363',to_date('09-MAY-22','DD-MON-RR'),9.95,0,0,6,to_date('08-JUN-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(44,189,'963253264',to_date('10-MAY-22','DD-MON-RR'),52.25,0,0,6,to_date('09-JUL-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(45,189,'963253263',to_date('10-MAY-22','DD-MON-RR'),109.5,0,0,6,to_date('09-JUL-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(67,189,'43966316',to_date('17-MAY-22','DD-MON-RR'),10.00,0,0,3,to_date('16-JUN-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(68,189,'263253273',to_date('17-MAY-22','DD-MON-RR'),30.75,0,0,6,to_date('16-JUL-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(69,37,'547479217',to_date('17-MAY-22','DD-MON-RR'),116.00,0,0,3,to_date('16-JUN-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(70,189,'263253270',to_date('18-MAY-22','DD-MON-RR'),67.92,0,0,3,to_date('17-JUN-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(71,189,'263253268',to_date('18-MAY-22','DD-MON-RR'),59.97,0,0,3,to_date('17-JUN-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(72,189,'263253265',to_date('18-MAY-22','DD-MON-RR'),26.25,0,0,3,to_date('17-JUN-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(79,189,'963253262',to_date('22-MAY-22','DD-MON-RR'),42.50,0,0,3,to_date('21-JUN-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(81,83,'31359783',to_date('23-MAY-22','DD-MON-RR'),1575.00,0,0,2,to_date('12-JUN-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(82,165,'25022117',to_date('24-MAY-22','DD-MON-RR'),6.00,0,0,3,to_date('23-JUN-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(88,86,'367447',to_date('31-MAY-22','DD-MON-RR'),2433,0,0,3,to_date('30-JUN-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(91,80,'134116',to_date('01-JUN-22','DD-MON-RR'),90.36,0,0,3,to_date('01-JUL-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(94,138,'9982771',to_date('03-JUN-22','DD-MON-RR'),503.20,0,0,2,to_date('23-JUN-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(98,105,'111-92R-10092',to_date('04-JUN-22','DD-MON-RR'),46.21,0,0,1,to_date('14-JUN-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(99,105,'111-92R-10093',to_date('05-JUN-22','DD-MON-RR'),39.77,0,0,2,to_date('25-JUN-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(100,108,'I77271-O01',to_date('05-JUN-22','DD-MON-RR'),662.00,0,0,2,to_date('25-JUN-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(103,105,'111-92R-10094',to_date('06-JUN-22','DD-MON-RR'),19.67,0,0,1,to_date('16-JUN-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(105,105,'111-92R-10095',to_date('07-JUN-22','DD-MON-RR'),32.70,0,0,3,to_date('07-JUL-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(106,105,'111-92R-10096',to_date('08-JUN-22','DD-MON-RR'),16.33,0,0,2,to_date('28-JUN-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(107,105,'111-92R-10097',to_date('08-JUN-22','DD-MON-RR'),16.33,0,0,1,to_date('18-JUN-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(109,126,'109596',to_date('14-JUN-22','DD-MON-RR'),41.80,0,0,3,to_date('14-JUL-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(110,72,'39104',to_date('20-JUN-22','DD-MON-RR'),85.31,0,0,3,to_date('20-JUL-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(111,37,'547480102',to_date('19-MAY-22','DD-MON-RR'),224.00,0,0,3,to_date('18-JUN-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(112,37,'547481328',to_date('20-MAY-22','DD-MON-RR'),224.00,0,0,3,to_date('19-JUN-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(113,72,'40318',to_date('18-JUL-22','DD-MON-RR'),21842.00,0,0,3,to_date('17-AUG-22','DD-MON-RR'),null);
insert into active_invoices 
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date) 
values 
(114,83,'31361833',to_date('23-MAY-22','DD-MON-RR'),579.42,0,0,2,to_date('12-JUN-22','DD-MON-RR'),null);


-- inserting into paid_invoices

insert into paid_invoices  values (1,34,'QP58872',to_date('06-OCT-22','DD-MON-RR'),116.54,116.54,0,6,to_date('05-DEC-22','DD-MON-RR'),to_date('20-NOV-22','DD-MON-RR'));
insert into paid_invoices  values (2,34,'Q545443',to_date('23-OCT-22','DD-MON-RR'),1083.58,1083.58,0,6,to_date('22-DEC-22','DD-MON-RR'),to_date('21-DEC-22','DD-MON-RR'));
insert into paid_invoices  values (4,150,'P-0259',to_date('25-NOV-22','DD-MON-RR'),26881.4,26881.4,0,3,to_date('25-DEC-22','DD-MON-RR'),to_date('21-DEC-22','DD-MON-RR'));
insert into paid_invoices  values (5,81,'MABO1489',to_date('25-NOV-22','DD-MON-RR'),936.93,936.93,0,3,to_date('25-DEC-22','DD-MON-RR'),to_date('22-DEC-22','DD-MON-RR'));
insert into paid_invoices  values (7,82,'C73-24',to_date('26-NOV-22','DD-MON-RR'),600,600,0,2,to_date('16-DEC-22','DD-MON-RR'),to_date('14-DEC-22','DD-MON-RR'));
insert into paid_invoices  values (9,186,'989319-477',to_date('28-NOV-22','DD-MON-RR'),2184.11,2184.11,0,6,to_date('27-JAN-23','DD-MON-RR'),to_date('16-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (10,186,'989319-467',to_date('03-DEC-22','DD-MON-RR'),2318.03,2318.03,0,6,to_date('01-FEB-23','DD-MON-RR'),to_date('07-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (11,186,'989319-457',to_date('03-DEC-22','DD-MON-RR'),3813.33,3813.33,0,3,to_date('02-JAN-23','DD-MON-RR'),to_date('29-DEC-22','DD-MON-RR'));
insert into paid_invoices  values (12,186,'989319-447',to_date('03-DEC-22','DD-MON-RR'),3689.99,3689.99,0,3,to_date('02-JAN-23','DD-MON-RR'),to_date('21-DEC-22','DD-MON-RR'));
insert into paid_invoices  values (13,186,'989319-437',to_date('03-DEC-22','DD-MON-RR'),2765.36,2765.36,0,2,to_date('23-DEC-22','DD-MON-RR'),to_date('12-DEC-22','DD-MON-RR'));
insert into paid_invoices  values (14,186,'989319-427',to_date('04-DEC-22','DD-MON-RR'),2115.81,2115.81,0,1,to_date('14-DEC-22','DD-MON-RR'),to_date('14-DEC-22','DD-MON-RR'));
insert into paid_invoices  values (16,186,'989319-417',to_date('05-DEC-22','DD-MON-RR'),2051.59,2051.59,0,1,to_date('15-DEC-22','DD-MON-RR'),to_date('07-DEC-22','DD-MON-RR'));
insert into paid_invoices  values (17,90,'97-1024A',to_date('05-DEC-22','DD-MON-RR'),356.48,356.48,0,3,to_date('04-JAN-23','DD-MON-RR'),to_date('12-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (20,183,'97/503',to_date('09-DEC-22','DD-MON-RR'),639.77,639.77,0,6,to_date('07-FEB-23','DD-MON-RR'),to_date('14-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (21,183,'97/488',to_date('09-DEC-22','DD-MON-RR'),601.95,601.95,0,3,to_date('08-JAN-23','DD-MON-RR'),to_date('05-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (22,183,'97/486',to_date('09-DEC-22','DD-MON-RR'),953.1,953.1,0,2,to_date('29-DEC-22','DD-MON-RR'),to_date('22-DEC-22','DD-MON-RR'));
insert into paid_invoices  values (23,183,'97/465',to_date('10-DEC-22','DD-MON-RR'),565.15,565.15,0,1,to_date('20-DEC-22','DD-MON-RR'),to_date('14-DEC-22','DD-MON-RR'));
insert into paid_invoices  values (24,183,'97/222',to_date('10-DEC-22','DD-MON-RR'),1000.46,1000.46,0,3,to_date('09-JAN-23','DD-MON-RR'),to_date('03-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (25,189,'4-342-8069',to_date('10-DEC-22','DD-MON-RR'),10,10,0,6,to_date('08-FEB-23','DD-MON-RR'),to_date('05-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (26,189,'4-327-7357',to_date('10-DEC-22','DD-MON-RR'),162.75,162.75,0,3,to_date('09-JAN-23','DD-MON-RR'),to_date('30-DEC-22','DD-MON-RR'));
insert into paid_invoices  values (27,189,'4-321-2596',to_date('10-DEC-22','DD-MON-RR'),10,10,0,2,to_date('30-DEC-22','DD-MON-RR'),to_date('20-DEC-22','DD-MON-RR'));
insert into paid_invoices  values (28,189,'7548906-20',to_date('10-DEC-22','DD-MON-RR'),27,27,0,3,to_date('09-JAN-23','DD-MON-RR'),to_date('04-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (29,189,'4-314-3057',to_date('11-DEC-22','DD-MON-RR'),13.75,13.75,0,1,to_date('21-DEC-22','DD-MON-RR'),to_date('16-DEC-22','DD-MON-RR'));
insert into paid_invoices  values (31,189,'2-000-2993',to_date('12-DEC-22','DD-MON-RR'),144.7,144.7,0,1,to_date('22-DEC-22','DD-MON-RR'),to_date('13-DEC-22','DD-MON-RR'));
insert into paid_invoices  values (32,89,'125520-1',to_date('14-DEC-22','DD-MON-RR'),95,95,0,3,to_date('13-JAN-23','DD-MON-RR'),to_date('31-DEC-22','DD-MON-RR'));
insert into paid_invoices  values (33,189,'1-202-2978',to_date('15-DEC-22','DD-MON-RR'),33,33,0,1,to_date('25-DEC-22','DD-MON-RR'),to_date('22-DEC-22','DD-MON-RR'));
insert into paid_invoices  values (35,189,'1-200-5164',to_date('16-DEC-22','DD-MON-RR'),63.4,63.4,0,1,to_date('26-DEC-22','DD-MON-RR'),to_date('19-DEC-22','DD-MON-RR'));
insert into paid_invoices  values (36,150,'0-2060',to_date('17-DEC-22','DD-MON-RR'),23517.58,21221.63,2295.95,3,to_date('18-JAN-23','DD-MON-RR'),to_date('19-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (37,150,'0-2058',to_date('17-DEC-22','DD-MON-RR'),37966.19,37966.19,0,3,to_date('16-JAN-23','DD-MON-RR'),to_date('09-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (43,111,'21-4923721',to_date('18-DEC-22','DD-MON-RR'),9.95,9.95,0,1,to_date('28-DEC-22','DD-MON-RR'),to_date('22-DEC-22','DD-MON-RR'));
insert into paid_invoices  values (46,189,'963253261',to_date('19-DEC-22','DD-MON-RR'),42.75,42.75,0,3,to_date('18-JAN-23','DD-MON-RR'),to_date('19-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (47,189,'963253260',to_date('19-DEC-22','DD-MON-RR'),36,36,0,3,to_date('18-JAN-23','DD-MON-RR'),to_date('15-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (48,189,'963253258',to_date('19-DEC-22','DD-MON-RR'),111,111,0,3,to_date('18-JAN-23','DD-MON-RR'),to_date('09-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (49,189,'963253256',to_date('19-DEC-22','DD-MON-RR'),53.25,53.25,0,3,to_date('18-JAN-23','DD-MON-RR'),to_date('05-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (50,189,'963253255',to_date('20-DEC-22','DD-MON-RR'),53.75,53.75,0,3,to_date('19-JAN-23','DD-MON-RR'),to_date('12-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (51,189,'963253254',to_date('20-DEC-22','DD-MON-RR'),108.5,108.5,0,3,to_date('19-JAN-23','DD-MON-RR'),to_date('08-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (52,189,'963253252',to_date('20-DEC-22','DD-MON-RR'),38.75,38.75,0,3,to_date('19-JAN-23','DD-MON-RR'),to_date('05-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (53,189,'963253251',to_date('20-DEC-22','DD-MON-RR'),15.5,15.5,0,3,to_date('19-JAN-23','DD-MON-RR'),to_date('30-DEC-22','DD-MON-RR'));
insert into paid_invoices  values (54,189,'963253249',to_date('21-DEC-22','DD-MON-RR'),127.75,127.75,0,2,to_date('10-JAN-23','DD-MON-RR'),to_date('06-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (55,189,'963253248',to_date('22-DEC-22','DD-MON-RR'),241,241,0,2,to_date('11-JAN-23','DD-MON-RR'),to_date('02-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (56,189,'963253246',to_date('22-DEC-22','DD-MON-RR'),129,129,0,2,to_date('11-JAN-23','DD-MON-RR'),to_date('29-DEC-22','DD-MON-RR'));
insert into paid_invoices  values (57,189,'963253245',to_date('22-DEC-22','DD-MON-RR'),40.75,40.75,0,2,to_date('11-JAN-23','DD-MON-RR'),to_date('23-DEC-22','DD-MON-RR'));
insert into paid_invoices  values (58,189,'963253244',to_date('22-DEC-22','DD-MON-RR'),60,60,0,2,to_date('11-JAN-23','DD-MON-RR'),to_date('30-DEC-22','DD-MON-RR'));
insert into paid_invoices  values (59,189,'963253242',to_date('22-DEC-22','DD-MON-RR'),104,104,0,2,to_date('11-JAN-23','DD-MON-RR'),to_date('26-DEC-22','DD-MON-RR'));
insert into paid_invoices  values (60,189,'963253240',to_date('01-JAN-23','DD-MON-RR'),67,67,0,1,to_date('11-JAN-23','DD-MON-RR'),to_date('06-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (61,189,'963253239',to_date('01-JAN-23','DD-MON-RR'),147.25,147.25,0,1,to_date('11-JAN-23','DD-MON-RR'),to_date('06-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (62,189,'963253237',to_date('01-JAN-23','DD-MON-RR'),172.5,172.5,0,1,to_date('11-JAN-23','DD-MON-RR'),to_date('02-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (63,189,'963253235',to_date('23-DEC-22','DD-MON-RR'),108.25,108.25,0,1,to_date('02-JAN-23','DD-MON-RR'),to_date('26-DEC-22','DD-MON-RR'));
insert into paid_invoices  values (64,189,'963253234',to_date('23-DEC-22','DD-MON-RR'),138.75,138.75,0,1,to_date('02-JAN-23','DD-MON-RR'),to_date('25-DEC-22','DD-MON-RR'));
insert into paid_invoices  values (65,189,'963253232',to_date('23-DEC-22','DD-MON-RR'),127.75,127.75,0,1,to_date('02-JAN-23','DD-MON-RR'),to_date('25-DEC-22','DD-MON-RR'));
insert into paid_invoices  values (66,189,'963253230',to_date('24-DEC-22','DD-MON-RR'),739.2,739.2,0,1,to_date('03-JAN-23','DD-MON-RR'),to_date('25-DEC-22','DD-MON-RR'));
insert into paid_invoices  values (73,189,'263253257',to_date('27-DEC-22','DD-MON-RR'),22.57,22.57,0,2,to_date('16-JAN-23','DD-MON-RR'),to_date('05-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (74,189,'263253253',to_date('27-DEC-22','DD-MON-RR'),31.95,31.95,0,2,to_date('16-JAN-23','DD-MON-RR'),to_date('10-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (75,189,'263253250',to_date('28-DEC-22','DD-MON-RR'),42.67,42.67,0,2,to_date('17-JAN-23','DD-MON-RR'),to_date('03-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (76,189,'263253243',to_date('29-DEC-22','DD-MON-RR'),44.44,44.44,0,1,to_date('08-JAN-23','DD-MON-RR'),to_date('01-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (77,189,'263253241',to_date('31-DEC-22','DD-MON-RR'),40.2,40.2,0,1,to_date('10-JAN-23','DD-MON-RR'),to_date('31-DEC-22','DD-MON-RR'));
insert into paid_invoices  values (78,189,'94007069',to_date('31-DEC-22','DD-MON-RR'),400,400,0,3,to_date('30-JAN-23','DD-MON-RR'),to_date('03-FEB-23','DD-MON-RR'));
insert into paid_invoices  values (80,135,'94007005',to_date('01-JAN-23','DD-MON-RR'),220,220,0,1,to_date('11-JAN-23','DD-MON-RR'),to_date('04-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (83,165,'24946731',to_date('03-JAN-23','DD-MON-RR'),25.67,25.67,0,2,to_date('23-JAN-23','DD-MON-RR'),to_date('06-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (84,165,'24863706',to_date('05-JAN-23','DD-MON-RR'),6,6,0,1,to_date('15-JAN-23','DD-MON-RR'),to_date('10-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (85,165,'24780512',to_date('07-JAN-23','DD-MON-RR'),6,6,0,1,to_date('17-JAN-23','DD-MON-RR'),to_date('08-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (86,88,'972110',to_date('08-JAN-23','DD-MON-RR'),207.78,207.78,0,1,to_date('18-JAN-23','DD-MON-RR'),to_date('11-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (87,120,'587056',to_date('09-JAN-23','DD-MON-RR'),2184.5,2184.5,0,3,to_date('08-FEB-23','DD-MON-RR'),to_date('31-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (89,117,'509786',to_date('09-JAN-23','DD-MON-RR'),6940.25,6940.25,0,2,to_date('29-JAN-23','DD-MON-RR'),to_date('17-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (90,144,'121897',to_date('10-JAN-23','DD-MON-RR'),450,450,0,2,to_date('30-JAN-23','DD-MON-RR'),to_date('23-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (92,80,'133560',to_date('10-JAN-23','DD-MON-RR'),175,175,0,2,to_date('30-JAN-23','DD-MON-RR'),to_date('12-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (93,132,'P02-3772',to_date('12-JAN-23','DD-MON-RR'),7125.34,7125.34,0,2,to_date('01-FEB-23','DD-MON-RR'),to_date('17-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (95,141,'RTR-72-3662-X',to_date('13-JAN-23','DD-MON-RR'),1600,1600,0,2,to_date('02-FEB-23','DD-MON-RR'),to_date('20-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (96,159,'77290',to_date('13-JAN-23','DD-MON-RR'),1750,1750,0,2,to_date('02-FEB-23','DD-MON-RR'),to_date('17-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (97,177,'10843',to_date('13-JAN-23','DD-MON-RR'),4901.26,4901.26,0,2,to_date('02-FEB-23','DD-MON-RR'),to_date('20-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (101,129,'75C-90227',to_date('15-JAN-23','DD-MON-RR'),1367.5,1367.5,0,1,to_date('25-JAN-23','DD-MON-RR'),to_date('18-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (102,48,'P02-88D77S7',to_date('15-JAN-23','DD-MON-RR'),856.92,856.92,0,1,to_date('25-JAN-23','DD-MON-RR'),to_date('18-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (104,162,'CBM9920-M-T77109',to_date('16-JAN-23','DD-MON-RR'),290,290,0,1,to_date('26-JAN-23','DD-MON-RR'),to_date('18-JAN-23','DD-MON-RR'));
insert into paid_invoices  values (108,171,'111897',to_date('20-JAN-23','DD-MON-RR'),16.62,16.62,0,1,to_date('30-JAN-23','DD-MON-RR'),to_date('21-JAN-23','DD-MON-RR'));

--Commit the data changes
/*** This is an important step. DO NOT MISS IT! ***/
commit;

