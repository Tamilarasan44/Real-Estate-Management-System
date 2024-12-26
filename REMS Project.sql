--  Real Estate Management System(REMS) --

create database REMS;
use rems;


/* Table Contains 
1. Properties 
2. Seller
3. Buyer
4. Tenants
5. Lease */

-- Seller Table --

create table seller(
seller_id int primary key auto_increment , name varchar(20) not null,
phone char(10) unique not null,email varchar(30) default 'Null');

alter table seller auto_increment 101;

insert into seller(name,phone,email) values
('Ranjith','1234567890','ranjith@gmail.com'),
('Dhoni','1234567891','dhoni@gmail.com'),
('Virat','1234567892','virat@gmail.com'),
('Sachin','1234567893','sachin@gmail.com'),
('Rohit','1234567894','rohit@gmail.com');

select *from seller;

insert into seller(name,phone,email) values
('Hardik','1234567895','hardik@gmail.com'),
('Raina','1234567896','Rainagmail.com'),
('Bumrah','1234567897','bumrah@gmail.com'),
('Rachin','1234567898','rachin@gmail.com'),
('Smith','1234567899','smith@gmail.com');

-- Buyer Table--

create table buyers(
buyer_id int primary key auto_increment,name varchar(20) not null,
phone char(10) unique not null,email varchar(30) default 'Null');

alter table buyers auto_increment 201;

insert into buyers (name,phone,email) values
('Tamilarasan','9688223731','tamil@gmail.com'),
('Rajini','9688223732','tamil@gmail.com'),
('Vijay','9688223733','tamil@gmail.com'),
('Ajith','9688223734','tamil@gmail.com'),
('Sandy','9688223735','tamil@gmail.com');

select *from buyers;


-- Tenants table --
create table tenants(
tenants_id int primary key auto_increment,name varchar(20) not null,
phone char(10) unique not null,email varchar(30) default 'Null');

alter table tenants auto_increment 1001;

insert into tenants (name,phone,email) values
('Pavi','0987654321','pavi@gmail.com'),
('Anand','0987654322','anand@gmail.com'),
('Prabha','0987654323','prabha@gmail.com'),
('Shetu','0987654324','shetu@gmail.com'),
('Santhosh','9994708591','santhosh@gmail.com');

select *from tenants;

-- Properties Table --

create table properties(
property_id int primary key auto_increment,
type varchar(10) not null,check(type in('House','Land')),
Status varchar(20) default 'Available' ,check(status in('available','sold','lease')),
price int not null,check(price>=20000),
location varchar(20) default 'TamilNadu' not null,
owner_id int, foreign key (owner_id) references seller (seller_id));

insert into properties(type,price,location,owner_id) values
('House',2000000,'Chennai',105),
('Land',3000000,'Chennai',102),
('House',30000,'Chennai',107),
('Land',20000000,'Tiruppur',109),
('House',20000,'Tiruppur',103),
('House',25000,'Tirunelveli',101),
('Land',2000000,'Chennai',104),
('House',5000000,'Coimbatore',106),
('Land',700000,'Tirchy',108),
('House',300000,'Madurai',110);

Select *from properties;

-- Sales Table--

create table sales
(id int primary key auto_increment,
property_id int,
buyer_id int,
Final_Price int not null,
date date not null,
constraint fk foreign key (property_id) references properties(property_id),
constraint fk1 foreign key (buyer_id) references buyers(buyer_id));

-- Trigger Usage to change Status in Properties Table--

delimiter &&

create trigger sales_trigger
Before insert on sales
for each row
begin
update properties
set status='Sold'
where property_id=new.property_id;
end &&

delimiter ;

select * from properties;

select *from buyers;

insert into sales(property_id,buyer_id,final_price,date)
values
(4,201,20000000,date(now())),
(2,205,3000000,date(now())),
(10,203,300000,date(now())),
(9,204,700000,date(now())),
(6,202,25000,date(now()));


select *from sales;

select *from properties;

-- Lease Table --

drop table lease;

create table lease
(id int primary key auto_increment,
property_id int not null,
tenant_id int not null,
date_start date not null,
date_end date not null,
Amount int not null,
constraint fk2 foreign key (property_id) references properties(property_id),
constraint fk3 foreign key (tenant_id) references tenants(tenants_id));

-- Trigger to add lease end date--

create trigger tenant_date
before insert on lease
for each row
set new.date_end=new.date_start + Interval 1 year;

-- Trigger to change status in property table to lease--
create trigger tenant_status
before insert on lease
for each row
update properties set status='Lease' where property_id=new.property_id;


select*from properties;
select *from tenants;

insert into lease(property_id,tenant_id,date_start,amount)
values
(3,1001,curdate(),30000),
(5,1002,date(now()),20000),
(8,1003,date(now()),5000000);

select *from lease;

select *from properties;


-- To View All Tables with procedure--
delimiter &&

create procedure viewtables()
begin
    select *from Properties;
    select *from sales;
    select *from tenants;
    select *from buyers;
    select *from seller;
end&&

delimiter ;

call viewtables();

-- Aggreagte Functions --
select max(price) as max_land_price from properties;
select min(price) as min_land_price from properties;
select sum(price) as sum_land_price_in_selected_city from properties where location='Tiruppur';
select avg(price) as Avg_land_price_in_selected_district from properties where location='chennai';
select count(*) as Properties_count from properties;


-- Group by --

-- Count of properties location wise
select count(*) as Count,Location from properties
group by location;

-- Count of Properties in Particular location --

select count(*) from properties
group by location
having location='Chennai';

-- Max Price in chennai --
select max(price) as MaxLandPriceInChennai from properties
group by location
having location='Chennai';

-- Between & IN & Like Operations --
select property_id,type,location from properties
where price between 20000 and 30000;

select property_id,type,price from properties
where location in('chennai','Tiruppur');

call viewtables();

select name from seller 
where name like '%R%';
select name from seller 
where name like '%R';
select name from seller 
where name like 'R%';
select name from seller 
where name like '_R%';

-- Joins --
-- Fetch the property_id, type, buyer_id, and name of buyers who have purchased properties--
select p.property_id,p.type,b.buyer_id,b.name as Buyer_name
from properties p 
join sales s
on p.property_id=s.property_id
join buyers b
on s.buyer_id=b.buyer_id;


-- List all properties and their buyer details. If a property hasn’t been sold yet, show NULL for buyer details --

select p.property_id,p.type,b.buyer_id,b.name as Buyer_name
from properties p 
Left join sales s
on p.property_id=s.property_id
Left join buyers b
on s.buyer_id=b.buyer_id;


-- Fetch all buyers and the properties they purchased, if any. Show NULL for properties if the buyer hasn’t purchased anything.--
select p.property_id,p.type,b.buyer_id,b.name as Buyer_name
from properties p 
Right join sales s
on p.property_id=s.property_id
Right join buyers b
on s.buyer_id=b.buyer_id;



-- Get a combined list of all properties and their buyers. Include properties that haven't been sold and buyers who haven’t purchased properties.--
select property_id,type from properties
union
select buyer_id,name from buyers;


-- For each location, fetch the total number of properties sold and their total price --

call viewtables();
select location as City,count(p.property_id) as CountOfPropertySold,sum(s.final_price) as TotalPrice
from properties p
join sales s
on p.property_id=s.property_id
group by p.location;


call viewtables();


-- Views --

-- Uses Views to select property based on location --
create view chennaiproperty as
select property_id,type,price from properties
where location='Chennai';

create view tiruppurproperty as
select property_id,type,price from properties
where location='Tiruppur';

create view coimbatoreproperty as
select property_id,type,price from properties
where location='Coimbatore';

select *from chennaiproperty;

select *from tiruppurproperty;

select *from coimbatoreproperty;

call viewtables();


-- END--





