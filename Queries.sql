
--Find the supplied product count and their group for each product 

select retail_db.supplier.Supplier_ID,retail_db.supplier.Supplier_Name, Count(retail_db.product.Group_ID) AS `Product Count`, retail_db.`product group`.Group_Name
from
    retail_db.supplier
        inner join 
    retail_db.product
        on  retail_db.supplier.Supplier_ID=retail_db.product.Supplier_ID 
        inner join 
    retail_db.`product group`
        on retail_db.product.Group_ID=retail_db.`product group`.Group_ID
        
Group by Supplier_ID Asc


--Total number of orders to be shipped immediate and is partially Shipped

  SELECT Order_ID, Order_Date,`Status`,count(Order_ID) as Total
  FROM   retail_db.orders
  WHERE (Shippent_Duration= 'Immediate' and`Status`='Partially Shipped')
  ORDER BY Order_ID DESC;


--List of products by department which has high defect%

SELECT retail_db.reviews.Product_ID,retail_db.product.Product_Name,
MAX(retail_db.reviews.`Defect%`) As `Defect%`, retail_db.`product group`.Group_Name
from
    retail_db.reviews
        inner join 
    retail_db.product
        on  retail_db.reviews.Product_ID=retail_db.product.Product_ID
        inner join 
    retail_db.`product group`
        on retail_db.product.Group_ID=retail_db.`product group`.Group_ID
 Group by `product group`.Group_ID
 
 
 --Total amount of revenue earned with respect to their purchasing modes
 
Select  count(Payment_Mode) As Total_Cutomers, retail_db.payment.Payment_Mode,Sum(retail_db.bill.Amount_Paid) 
As Total_Amount
from retail_db.payment 
inner join
retail_db.bill
on retail_db.payment.Payment_ID=retail_db.bill.Payment_ID
group by Payment_Mode




 --Find The quantity of products available whose status is in progress and shipment duration is immediate
 
 
 SELECT retail_db.product.Product_Name,retail_db.product.Available_Number,`order product`.Quantity,orders.Order_Date, orders.`Status`,orders.Shippent_Duration
from
    retail_db.orders
        inner join 
    retail_db.`order product`
        on  retail_db.orders.Order_ID=retail_db.`order product`.Order_ID
        inner join
       retail_db.product
       on  retail_db.`order product`.Product_ID=retail_db.product.Product_ID
   where 
   orders.`Status`='In Progress' and orders.Shippent_Duration='Immediate';


--Find the names and defect% order by defect
SELECT Product_Name,`Defect%`
FROM retail_db.product
INNER JOIN retail_db.reviews
ON retail_db.reviews.Product_ID=retail_db.product.Product_ID
ORDER BY `Defect%` Desc;

--Find Customers payment ID,mode, vocher applied and their visist number
SELECT retail_db.bill.Voucher_id, retail_db.payment.Payment_ID, retail_db.payment.Payment_Mode, retail_db.payment.Visit_Number 
FROM   retail_db.bill,retail_db.payment
WHERE retail_db.payment.Payment_ID=retail_db.bill.Payment_ID 
AND retail_db.bill.Amount_Paid> 1000;


--Find product and their respective colour
SELECT Product_Name, Colour
FROM retail_db.`product details`
INNER JOIN retail_db.product
ON retail_db.`product details`.Product_ID=retail_db.product.Product_ID order by colour


--Find the product Names their respective groups
SELECT
Group_Name, Product_Name
FROM retail_db.`product group`
INNER JOIN retail_db.product
ON retail_db.`product group`.Group_ID=retail_db.product.Group_ID Order by Group_Name




--TRIGGERS
_________________________________________________________________________________________________________________________________________________
--Trigger1
--Find Customer name and updated time on customers table 
create table 
UpdateCustomerDetails
(Customer_id int, First_Name varchar(20), update_time Datetime)


delimiter \\
create trigger UpdateCustomerDetails_trigger
after update on customer
for each row
begin
declare new_date datetime;
set new_date=now();

insert into UpdateCustomerDetails(Customer_id,First_Name,update_time)
values(old.Customer_ID,old.First_Name, new_date);

end \\

--when customers details are updated the trigger is set
update customer set Email_Address='naynaa@gmail.com'
where Customer_ID=10000

--updates can be seen in the newly created table
select * from UpdateCustomerDetails



--Trigger2
--Trigger3
--Trigger4

--Stored_Procedure
_______________________________________________________________________________________________________________________________________________
--1
--Stored procedure to find most deffective product from each product group
call GetMostDeffective_Product()

delimiter//
Create Procedure GetMostDeffective_Product()
Begin
SELECT retail_db.reviews.Product_ID,retail_db.product.Product_Name,MAX(retail_db.reviews.`Defect%`) As `Defect%`, retail_db.`product group`.Group_Name
from
    retail_db.reviews
        inner join 
    retail_db.product
        on  retail_db.reviews.Product_ID=retail_db.product.Product_ID
        inner join 
    retail_db.`product group`
        on retail_db.product.Group_ID=retail_db.`product group`.Group_ID
 Group by `product group`.Group_Name
 end//

--2
--Stored procedure for employee assesment
call GetEmployee_Assesment ()

delimiter//
Create Procedure GetEmployee_Assesment ()
Begin
Select count(retail_db.customer.Customer_ID) as Total_Cutomers ,retail_db.customer.Employee_ID,retail_db.employee.Designation,Salary
from  retail_db.customer
Inner Join
retail_db.employee
on
retail_db.employee.Employee_ID=retail_db.customer.Employee_ID 
group by Employee_ID
order by count(retail_db.customer.Customer_ID) ;
end//

--3
--Stored procedure to find customer details of highest Amount_Paid
call findMaxBill()

delimiter//
Create Procedure findMaxBill() 
Begin
	select Max(retail_db.bill.Amount_Paid) As GreatestPurchase, retail_db.customer.Customer_ID,retail_db.customer.First_Name from retail_db.bill
        inner join 
    retail_db.payment
        on  retail_db.payment.Payment_ID=retail_db.bill.Payment_ID
        inner join 
    retail_db.Customer
        on retail_db.payment.Customer_ID=retail_db.customer.Customer_ID;
end//

--Views


--Student as customer views

create view StudentAsCustomer as ( select * from customer where Customer_Type = 'Student')


--Product details with minimum defect and high rating
create view LeastDefectHighRating as
(select product.Product_Name, min(reviews.`Defect%`), max(reviews.Quality_Rating)
from retail_db.reviews
inner join 
retail_db.product
on retail_db.reviews.Product_ID=retail_db.product.Product_ID)


--3
--Products and the colours available
create view ProductandAvailableColours as
(SELECT Product_Name, Colour
FROM retail_db.`product details`
INNER JOIN retail_db.product
ON retail_db.`product details`.Product_ID=retail_db.product.Product_ID order by colour)


--4
--Distinct employee departments whose salary is greater than 1200 limit to 4
create view DistinctEmployeeDepartments as
(Select DISTINCT retail_db.employee.Designation,retail_db.employee.Employee_Name,retail_db.employee.Department
From retail_db.employee
Where retail_db.employee.salary>1200 limit 4)


--6
Select count(retail_db.customer.Customer_ID) as Total_Customers, retail_db.customer.Emploee_ID,retail_db.emploee.Designation
From retail_db.customer
Inner Join
retail_db.employee
on retail_db.employee.Employee_ID=retail_db.customer.Employee_ID
group by Employee_ID
order by count(retail_db.customers.Customer_ID) desc

--7
--View Salary of employee group by type and department
create view SalaryGroupbyType as
(Select Salary, Employee_Type,Department
From retail_db.employee
Group by Employee_Type,Department)