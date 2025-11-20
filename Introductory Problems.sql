
-- Introdutory Problems.

-- 1) Which shippers do we have?
-- We have a table called Shippers. Return all the fields from all the shippers.

select * 
from Shippers

--2) Certain filds from Categories.

-- In the categories table, selecting all the fields using SQL.

select CategoryID, CategoryName, Description
from Categories

-- 3) Sales Representatives

-- We'd like to see just FirstName, LastName, and HireDate of all the employees with the title
-- of Sales Representative. Write a SQL statement that returns only those employees.

select *
from Employees

select FirstName, LastName, HireDate
from Employees
where 
	Title = Sales Representative
-- Incorrect syntax near 'Representative'.

select FirstName, LastName, HireDate
from Employees
where Title = 1
--Conversion failed when converting the nvarchar value 'Sales Representative' to data type int.

select FirstName, LastName, HireDate
from Employees
where 
	Title = 'Sales Representative'

-- 4) Sales Representavives in the United States.

-- Now we'd like to see the same columns as above, but only for those employees
-- that both have the title of Sales Representative, and also are in the United States.

select FirstName, LastName, HireDate
from employees
where title = 'Sales Representative' and Country = 'USA'

--5) Orders placed by specific employeeID.

-- Show all orders placed by a specific employee. The EmployeeID for this Employee (Steven Buchaman) is 5.

select OrderID, OrderDate
from Orders
where EmployeeID = 5

-- Hint: The EmployeeId is an integer field, and not a string field. So, the value "5" does not need 
-- to be surrounded by single qoutes in the where clause.

-- 6) Suppliers and ContactTitles.

--  In the Supplies table, show the SupplierID, ContactName, and ContactTitle for
-- those Suppliers whose ContactTitle is not Marketing Manager.

select SupplierID, ContactName, ContactName, ContactTitle
from Suppliers
where ContactTitle <> 'Marketing Manager'

-- Hint: To learn to do the "do", you can search online for SQL comparison operators.

-- 7) Products with "queso" in ProductName.

-- In the products table, we'd like to see the ProductID and ProductName for those products
-- where the ProductName  includes the string "queso".

select *
from Products

select ProductID, ProductName
from Products
where ProductName like '%queso%'

--Use "like" operator, with wildcard, inthe answer. 

-- 8) Orders shippingto France or Belgium.

--Looking at the order table, there is a field called ShipCountry. Write a query that show the OrderID, CustomerID, and ShipCountry
--for the orders where the ShipCountry is either France or Belgium

select OrderId, CustomerID, ShipCountry  
from Orders
where ShipCountry = 'France'
		or ShipCountry = 'Belgium'


--9) Orders shipping to any country in Latin America. Write a query that show the OrderID, CustomerID, and ShipCountry.

-- Select all the orders from any Latin American country. Use: Brazil, Mexico, Argentina, Venezuela.

select OrderID, CustomerID, ShipCountry
from Orders
	where ShipCountry = 'Brazil'
	or ShipCountry = 'Mexico'
	or ShipCountry = 'Argentina'
	or ShipCountry = 'Venezuela'

--  10) Employees, in order of age.

--For all the employees table, show the FirsName, LastName, Title, and Birthdate
-- Order the reuslt by BirthData, so we have the oldest employees first.

select * 
from Employees


select FirstName, LastName, Title,BirthDate
from Employees
order by BirthDate

--Notes: By default, SQL server sort by ascending order (first to last). To sort indescending order (last to first), run 
-- the follwing with the desc keyword:

select FirstName, LastName, Title,BirthDate
from Employees
order by BirthDate


-- 11) Showing only the date with a DateTime fild:

-- In the output of query abovew, showing the Employees in order of BithDate, we see the
-- time of the BirthDate field, which we do not want. Show only the date portion of the BirthDate field.

select FirstName, LastName, Title,convert(date, BirthDate) as BirthDate
from Employees
order by BirthDate

-- 12) Employees full name.

-- Show the FirstName columns from the Employees table, and then create a new column called FullName
-- showing FirstName and LastName jooined together in one columns, with a space in between.

select FirstName, LastName, FirstName + ' '+ LastName as FullName
from Employees

select FirstName, LastName, FullName = concat(FirstName, ' ', LastName)
from Employees

-- Joining two fields like this is called concatenation. 

--13) OrderDetails amount per line item.

--In the OrderDetails table, we have the fields UnitPrice and Quantity. Create a new field, TotalPrice, that multiple these two together
-- We will ingnorethe Discout field for now.

-- In addition, show the OrderID, UnitPrice, and Quantity. Order by OrderID and ProductID.

select OrderID, ProductID, UnitPrice, Quantity, (UnitPrice * Quantity) as TotalPrice
from OrderDetails
order by OrderID

select OrderID, ProductID, UnitPrice, Quantity, TotalPrice = UnitPrice * Quantity
from OrderDetails
order by TotalPrice desc

-- Here we have another example of a computed column, this time using the aritmetic operator. * for multiplication.

--14) How many customers ?

-- how many customers do we have in the Customers table? Show one value only, and do not rely on
-- getting the record count at the end of a result.

select count(CustomerID) as TotalCustomers
from Customers


select TotalCostumers = count(CustomerID)
from Customers


select count(CustomerID) = TotalCostumers  
from Customers

-- In order to get total number of customers, we need to need to use whatis called an aggregate function. 

--15) What was the first order?
--Show the date ofthe first order ever made in the Orders table.

select min(Orderdate) as FirstOrder
from Orders

-- There is an aggregate functions called Min that you will need for this problem.

-- 16) Countries where there are customers.
--Show a list of countries where the Northwind company has customers.


select Country
from customers
group by Country

-- The group by clause is used to group rows that have the same values in specified columns. It is often used with
-- aggregate functions like count(), sum(), avg(), min(), or max() to summarize data. Every column in the slect statement must either be included in the Group by.
-- or be part of an aggregate funcition otherwise, SQL Server will throw error.

-- You can gorup by one or multiple columns. Use Order By to sort the grouped result, and use Having to filter group after aggregation (not Where). 

-- Remember: aggregate functions ignore Null values, except count(*) wich all rows. Group by is powerfull for reports and summaries like 'sales per region' or 'average salary by departmente'


--17) Contact titles for customers.

-- show a list of all the different values in the Customers table for ContactTitle. Also include a count for each ContactTile.

select *
from customers

SELECT ContactTitle, COUNT(ContactTitle) AS TotalContacttitle
FROM customers
GROUP BY ContactTitle
ORDER BY COUNT(ContactTitle) DESC

-- Hint: the answer for this problem bluild on multiple concept introduced in previous problems,
-- such as grouping, aggregate functions, and aliases.

--18) Products with associated supplier names.

-- We'd like to show, for each product, the associated Supplier. Show the ProductID, ProductName, and the CompanyName of the Supplier.
-- Sort the result by ProductID.

-- This question will introduce what may be a new concept. the Join clause in SQL. The Join clause is used to join two or more relational database tables
-- together in a  logical way. In this case, you will join Suppliers to the Prpducts table by SupplierID.

select  *
from Suppliers


select  *
from Products

--Obtienes una lista de IDs de producto, nombres de producto y nombres de proveedor. Solo aparecen los productos que tienen proveedor asociado.


SELECT Products.ProductID,Products.ProductName, Suppliers.CompanyName as Supplier
FROM Products
JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID


--SELECT
--"I want to see these columns in my result."
--"Quiero ver estas columnas en mi resultado."

--Products.ProductID
--Get the Product ID from the Products table.
--Obtiene el ID del producto desde la tabla Products.

--Products.ProductName
--Get the name of the product from the Products table.	
--Obtiene el nombre del producto desde la tabla Products.

--Suppliers.CompanyName AS Supplier	
--Get the supplier’s name from Suppliers, and rename it as Supplier.
--Obtiene el nombre del proveedor desde Suppliers, y lo renombra como Supplier.

--FROM Products
--Start with the Products table (main table).
--Empieza desde la tabla Products (tabla base o principal).

--JOIN Suppliers
--Combine the Suppliers table with the main one.
--Combina la tabla Suppliers con la principal.

--ON Products.SupplierID = Suppliers.SupplierID	
--Match rows where supplier IDs are the same.	
--Une las filas donde los SupplierID son iguales.


--19)  Orders and the shippers that was used.

-- We'd like to show a list of the Orders that were made, including the Shipper that was used. Show the OrderID, OrderDate (dateonly), and CompanyName of the Shipper,
-- and sort by OrderID.

-- In order to not show all the orders (there is more than 800), show only those rows with an OrderID of less than 10270.

select * 
from Orders

select * 
from Shippers

SELECT Orders.OrderID, Orders.OrderDate, Shippers.CompanyName
FROM Orders
JOIN Shippers ON Orders.ShipVia = Shippers.ShipperID
WHERE Orders.OrderID < 10270
ORDER BY Orders.OrderID












































