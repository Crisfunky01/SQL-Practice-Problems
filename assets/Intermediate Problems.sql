
--  Intermediete Problems

--20) Categories, and the total products in each category.

-- For this problem, we'd like  to see the total number of products in each category. Sort the 
-- result by the total number of product, in descending order.

SELECT * 
FROM Products

SELECT * 
FROM Categories

SELECT Categories.CategoryName, COUNT(Products.ProductName) AS TotalProduct
FROM Categories
JOIN Products ON Categories.CategoryID = Products.CategoryID
GROUP BY Categories.CategoryName
ORDER BY COUNT(Products.ProductName) DESC

--HINT: To solve this problem you need to combine a join, and a group by.
-- A good way to start is by creating a query that show the CategoryNAme and all
-- ProductID associated with it, without grouping. Then, add theGroup by.

--21) Total custumers per country/city.

-- In the Custumers table, show the total number of customers per Country and City.

SELECT Country, City, Count(*) AS TotalCustomers
FROM Customers
GROUP BY Country, City
ORDER BY TotalCustomers DESC

--22) Product that need reordering.

-- What products do we have in our inventory that shoul be recordered? . For now, just use the fields UnitsInStock and ReorderLevel, where UnitsStock is
-- less than or equal to the ReorderLevel, Ignore the fields UnitsOnOrder and Discontinued.

--Sort result by ProductID.

SELECT ProductID, ProductName, UnitsInStock, ReorderLevel
FROM Products
WHERE UnitsInStock < ReorderLevel

--Hint: We want to show all fields where UnitsInStock is less or equal  to ReorderLevel. So, in the Where clause, use:
-- UnitsInStock < ReorderLevel


-- 23) Products that need recoirdering, continued.

SELECT ProductID, ProductName, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued
FROM Products
WHERE UnitsInStock + UnitsOnOrder <= ReorderLevel AND Discontinued = 0

-- 24) Customer list by region.

-- A salesperson for Northwind is going on a business trip to visit customers, and would like
-- to see a list of all customers, sorted by region, alphabetically.

-- However, he want the custumers no region (null in the Region field) to be at the end, insted of at the top.
-- Where you'd normally find the null values. Within the same region, compaines should be sorted by CustomerID.

SELECT CustomerID, CompanyName, Region,
	CASE
		WHEN Region is Null then 1
		ELSE 0
		END  AS CODE
FROM Customers
ORDER BY CODE asc


SELECT CustomerID, CompanyName, Region, RegionOrder = 
			CASE
			WHEN Region is Null then 1
			ELSE 0
			END
FROM Customers
ORDER BY RegionOrder

-- 25) High freight charges.

-- Some countries we ship to have very high freight charges. We'd like to investigate some more shipping options for our customers, to be 
-- able to offer them lower freight charges. Return the three ship countries with the highest average fright overall, in descending order by average freight.

SELECT TOP 3 ShipCountry, AVG(freight) as FreightAvg
FROM Orders
Group By ShipCountry
ORDER BY FreightAvg DESC

-- 26) High freight charges -2015.

-- We are continuing on the question above on high freight charges. Now, instead of using all
-- hte orders we have, we only want to see orders from the years 2015.

SELECT TOP 3  ShipCountry, AVG(freight) as FreightAvg
FROM Orders
WHERE
	YEAR(OrderDate) = 2015
Group By ShipCountry
ORDER BY FreightAvg DESC

-- 🧠 HINT: Orden correcto de una consulta SQL
-- 1. SELECT      → columnas que quieres ver
-- 2. FROM        → tabla(s) de origen
-- 3. WHERE       → filtra filas antes de agrupar
-- 4. GROUP BY    → agrupa datos por columnas
-- 5. HAVING      → filtra después del GROUP BY (usa funciones agregadas)
-- 6. ORDER BY    → ordena el resultado final

-- 🧠 TIP: Uso de alias en SQL Server

-- ✅ Puedes usar el alias del SELECT en:
--    - ORDER BY (sí se permite)
--    - A veces en HAVING (pero es mejor usar la función directamente)

-- ❌ No puedes usar el alias en:
--    - WHERE (porque el alias no existe aún)
--    - GROUP BY (debes repetir la expresión original)

-- 💡 SQL se procesa así:
-- FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY
-- Por eso, el alias del SELECT aún no existe cuando se evalúa WHERE o GROUP BY.

-- 27) High freight charges with between.

--Another (incorrect) answer to the problems above is this"

SELECT TOP 3
	ShipCountry,
	AverageFreight = AVG(Freight)
FROM Orders
WHERE
	OrderDate BETWEEN '20150101' AND '20151231'
GROUP BY ShipCountry
ORDER BY AverageFreight DESC

SELECT * 
FROM Orders
ORDER BY OrderDate 

-- ⚠️ Cuidado: si OrderDate es DATETIME,
-- BETWEEN '2015-01-01' AND '2015-12-31' NO incluye todo el 31/dic
-- ✅ Solución profesional:
-- Usar: OrderDate >= '2015-01-01' AND OrderDate < '2016-01-01'
-- Así se incluye todo el año, incluso fechas con hora.


-- 28) High freight charges - last year.

-- We are continuing to work on high freight charges. We now want to get the three ship countries with the hightest 
-- average freight charges. But instead of filtering for a particular year, we want to use last 12 month of order data, using 
--as the end date the last OrderDate in Orders.

SELECT TOP 3 ShipCountry, AVG(Freight) AS AverageFreight
FROM Orders
WHERE OrderDate >= DATEADD(yy, -1, (SELECT MAX(OrderDate) From Orders))  --SUBCONSULTA: Toma la fecha de la ultima orden. Dateadd-- Sirve para sumar o restar tiempo. DATEADD(parte_de_tiempo, cantidad, fecha_base)
GROUP BY ShipCountry 
ORDER BY AverageFreight DESC

-- RESUMEN DE LO APRENDIDO:

-- Esta consulta muestra los 3 países con mayor promedio de flete (Freight) en el último año,
-- calculado de forma dinámica desde la última fecha de orden en la tabla.

-- CONCEPTOS CLAVE:
-- - DATEADD(yy, -1, fecha): resta 1 año a la fecha dada.
-- - (SELECT MAX(OrderDate) FROM Orders): subconsulta que busca la última fecha en la tabla.
-- - WHERE OrderDate >= ...: filtra solo las órdenes de los últimos 12 meses.
-- - AVG(Freight): calcula el promedio de flete por país.
-- - GROUP BY ShipCountry: agrupa los datos para aplicar la función de agregación.
-- - ORDER BY AverageFreight DESC: ordena del país con mayor flete promedio al menor.
-- - TOP 3: limita la salida a los 3 primeros resultados.


--29) Employee / Order Detail report.

-- we are doing inventory, and need to show Employee and Order Detail information like the below, for all orders. 
-- Sort by OrderID and Product ID.

SELECT *
FROM Employees

SELECT *
FROM Orders

SELECT *
FROM OrderDetails

SELECT *
FROM Products

SELECT Employees.EmployeeID, Employees.LastName, Orders.OrderID, Products.ProductName, OrderDetails.Quantity
FROM Employees
	JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID  
	JOIN Products ON Products.ProductID = OrderDetails.ProductID
	JOIN Orders ON Orders.OrderID = OrderDetails.OrderID

-- 🔹 Siempre hacer JOIN en el orden lógico: de la tabla base hacia las relacionadas.
-- 🔹 No usar dos veces el mismo JOIN a la misma tabla, salvo que uses alias diferentes.
-- 🔹 No referenciar columnas de una tabla que aún no ha sido introducida en el FROM o JOIN.
-- 🔹 Orden típico: Employees → Orders → OrderDetails → Products

--SOLUCION:

SELECT Employees.EmployeeID, Employees.LastName, Orders.OrderID, Products.ProductName, OrderDetails.Quantity
FROM Employees
	JOIN Orders 
		ON Employees.EmployeeID = Orders.EmployeeID  
	JOIN OrderDetails
		ON Orders.OrderID = OrderDetails.OrderID
	JOIN Products 
		ON Products.ProductID = OrderDetails.ProductID


-- 30) Customers with no orders.

-- There are some customers who have never actually placed an order. Show these customers.

SELECT *
FROM Customers

SELECT *
FROM Orders

-- Hint: One way of doing this is to use a left join, also know as left outer join.

SELECT Customers.CustomerID, Orders.CustomerID AS Orders_CustomerID
FROM Customers
LEFT JOIN ORDERS ON Customers.CustomerID = Orders.CustomerID
WHERE Orders.CustomerID IS NULL

-- This is a good start. It show all records from the Customers table, and matching record from the Orders table.
-- However, we only want those records where the CustomerID in Orders in null. You still need a filter.

--Other way:

SELECT 
	Customers_CustomersID = Customers.CustomerID,
	Orders_CustomersID = Orders.CustomerID
FROM Customers
	left join Orders
		ON Orders.CustomerID = Customers.CustomerID
WHERE
	Orders.CustomerID is null

-- 31) Customers with no orders for EmployeeID 4
-- One employee (Margaret Peacok, Employee ID 4 ) has places the most orders. However, there are some customers who've never placed an order with her.
-- Show only those customers who have placed an order with her.

SELECT *
FROM Customers

SELECT *
FROM Orders

-- Building on the previuo problem, you might (incorrectly) think you need to do something like this:

SELECT Customers.CustomerID, Orders.CustomerID AS Orders_CustomerID, Orders.EmployeeID
FROM Customers
LEFT JOIN ORDERS ON Customers.CustomerID = Orders.CustomerID
WHERE Orders.EmployeeID = 4 and Orders.CustomerID IS NULL

-- However outer joins, the filters on the where clase are applied after the join.

SELECT Customers.CustomerID, Orders.CustomerID AS Orders_CustomerID, Orders.EmployeeID
FROM Customers
LEFT JOIN ORDERS ON Customers.CustomerID = Orders.CustomerID AND Orders.EmployeeID = 4 
WHERE Orders.CustomerID IS NULL

-- Because the filter in the Where clause are applied after the result on the join, we need the EmployeeID = 4 filter in 
-- the Join clause, instead of the Where clause.


-- 🧠 LEFT JOIN + filtros:
-- Si querés conservar NULLs (para detectar ausencias), poné los filtros en el JOIN ON.
-- Si ponés filtros en WHERE, el LEFT JOIN puede comportarse como INNER JOIN sin que lo notes.



SELECT Customers.CustomerID, Orders.CustomerID AS Orders_CustomerID, Orders.EmployeeID
FROM Customers
LEFT JOIN ORDERS ON Customers.CustomerID = Orders.CustomerID AND Orders.EmployeeID = 4


-- JOIN simple: una condición en el ON (la clave primaria/foránea)
-- JOIN compuesto: varias condiciones en el ON usando AND
-- Siempre recordá: JOIN ON ... filtra el match, no el resultado


-- Tipos de JOIN
INNER JOIN → Solo los que coinciden en ambas tablas
LEFT JOIN  → Todos de la izquierda, coincidan o no
RIGHT JOIN → Todos de la derecha, coincidan o no
FULL JOIN  → Todos de ambas tablas, con o sin coincidencia

-- Dónde filtrar:
ON → controla cómo se unen (filtra el match)
WHERE → filtra después del match (filtra el resultado final)
































