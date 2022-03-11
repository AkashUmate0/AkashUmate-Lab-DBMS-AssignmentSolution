drop database order_directory;
create database order_directory;
use order_directory;
create table if not exists `supplier`(`SUPP_ID` int primary key, `SUPP_NAME` varchar(50),`SUPP_CITY` varchar(50), `SUPP_PHONE` varchar(10));
create table if not exists `customer`(`CUS__ID` int not null, `CUS_NAME` varchar(20) null default null, `CUS_PHONE` varchar(10), `CUS_CITY` varchar(20), `CUS_GENDER` char);	
alter table `customer` modify column `CUS__ID` int primary key;
create table if not exists `category`(`CAT_ID` int not null, `CAT_NAME` varchar(20) null default null, primary key (`CAT_ID`));
create table if not exists `product`(`PRO_ID` int not null, `PRO_NAME` varchar(30) null default null, `PRO_DESC` varchar(50) null default null, `CAT_ID` int not null, primary key(`PRO_ID`), foreign key(`CAT_ID`) references category(`CAT_ID`));
create table if not exists `product_details` (`PROD_ID` int not null,`PRO_ID` int not null,`SUPP_ID` int not null,`PROD_PRICE` int not null, primary key(`PROD_ID`),foreign key (`PRO_ID`) references product (`PRO_ID`),foreign key (`SUPP_ID`) references supplier (`SUPP_ID`));
alter table `customer`rename column CUS__ID to CUS_ID;
create table if not exists `order` (`ORD_ID` int not null,`ORD_AMOUNT` int not null,`ORD_DATE` date,`CUS_ID` int not null,`PROD_ID` int not null, primary key (`ORD_ID`), foreign key (`CUS_ID`) references customer (`CUS_ID`), foreign key(`PROD_ID`) references product_details (`PROD_ID`));
create table if not exists `rating` (`RAT_ID` int not null,`CUS_ID` int not null,`SUPP_ID` int not null,`RAT_RATSTARS` int not null, primary key (`RAT_ID`), foreign key (`SUPP_ID`) references supplier (`SUPP_ID`), foreign key (`CUS_ID`) references customer (`CUS_ID`));

insert into `supplier` values(1,"Rajesh Retails","Delhi",'1234567890');
insert into `supplier` values(2,"Appario Ltd.","Mumbai",'2589631470');
insert into `supplier` values(3,"Knome products","Banglore",'9785462315');
insert into `supplier` values(4,"Bansal Retails","Kochi",'8975463285');
insert into `supplier` values(5,"Mittal Ltd.","Lucknow",'7898456532');

insert into `customer` values(1,"Aakash",'9999999999',"Delhi",'M');
insert into `customer` values(2,"Aman",'9785463215',"Noida",'M');
insert into `customer` values(3,"Neha",'9999999999',"Mumbai",'F');
insert into `customer` values(4,"Megha",'9994562399',"Kolkata",'F');
insert into `customer` values(5,"Pulkit",'7895999999',"Lucknow",'M');

insert into `category` values(1,"BOOKS");
insert into `category` values(2,"GAMES");
insert into `category` values(3,"GROCERIES");
insert into `category` values(4,"ELECTRONICS");
insert into `category` values(5,"CLOTHES");

insert into `product` values(1,"GTA V","Dfjdjfdjfdjfdjfjf",2);
insert into `product` values(2,"TSHIRT","Dfdfjdfjdkfd",5);
insert into `product` values(3,"ROG LAPTOP","Dfnttntnternd",4);
insert into `product` values(4,"OATS","Reurentbtoth",3);
insert into `product` values(5,"HARRY POTTER","Nbemcthtjth",1);

insert into `product_details` values(1,1,2,1500);
insert into `product_details` values(2,3,5,30000);
insert into `product_details` values(3,5,1,3000);
insert into `product_details` values(4,2,3,2500);
insert into `product_details` values(5,4,1,1000);
  
insert into `order` values(20,1500,"2021-10-12",3,5);
insert into `order` values(25,30500,"2021-09-16",5,2);
insert into `order` values(26,2000,"2021-10-05",1,1);
insert into `order` values(30,3500,"2021-08-16",4,3);
insert into `order` values (50,2000,"2021-10-06",2,1); 
   
insert into `rating` values(1,2,2,4);
insert into `rating` values(2,3,4,3);
insert into `rating` values(3,5,1,5);
insert into `rating` values(4,1,3,2);
insert into `rating` values(5,4,5,4);

use order_directory;

-- Display the number of the customer group by their genders who have placed any order of amount greater than or equal to Rs.3000.
select customer.CUS_GENDER,count(customer.CUS_GENDER) as count from customer inner join `order` on customer.CUS_ID=`order`.CUS_ID where `order`.ORD_AMOUNT >=3000 group by customer.CUS_GENDER;

-- Display all the orders along with the product name ordered by a customer having Customer_Id=2.
select `order`.*, product.PRO_NAME from `order`, product_details, product where `order`.CUS_ID=2 and `order`.PROD_ID = product_details.PROD_ID and product_details.PROD_ID = product.PRO_ID;

-- Display the Supplier details who can supply more than one product.
select supplier.* from supplier, product_details where supplier.SUPP_ID in (select product_details.SUPP_ID from product_details group by product_details.SUPP_ID having count(product_details.SUPP_ID) > 1) group by supplier.SUPP_ID;

-- Find the category of the product whose order amount is minimum.
select category.*, `order`.ORD_ID from `order` inner join product_details on `order`.PROD_ID = product_details.PROD_ID inner join product on product.PRO_ID = product_details.PRO_ID inner join category on category.CAT_ID = product.CAT_ID having min(`order`.ORD_AMOUNT);

-- 7. Display the Id and Name of the Product ordered after “2021-10-05”.
select product.PRO_ID, product.PRO_NAME from product join product_details on product.PRO_ID = product_details.PRO_ID join `ORDER` on product_details.PROD_ID = `ORDER`.PROD_ID where `ORDER`.ORD_DATE > '2021-10-05';

-- 8. Display customer name and gender whose names start or end with character 'A'.
select CUS_NAME,CUS_ID from customer where CUS_NAME like 'A%' or cus_name like '%A';

-- 9. Create a stored procedure to display the Rating for a Supplier if any along with the Verdict on that rating if any like if rating >4 then “Genuine Supplier” if rating >2 “Average Supplier” else “Supplier should not be considered”.
DELIMITER &&
create procedure prc()
BEGIN
select supplier.supp_id, supplier.supp_name, rating.rat_ratstars,
case
	when rating.rat_ratstars >4 then 'GENUINE Supplier'
    when rating.rat_ratstars >2 then 'Average  Supplier'
    Else 'Supplier should not be considered'
END as verdict from rating inner join supplier on supplier.supp_id = rating.supp_id;
END 
&& DELIMITER ;

call prc();
