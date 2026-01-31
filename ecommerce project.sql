-- =========================
-- TABLE 1: Users
-- =========================
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50)
);
select * from Users;

INSERT INTO Users (name, city) VALUES
('Ali', 'Karachi'),
('Sara', 'Lahore'),
('Ahmed', 'Islamabad'),
('Fatima', 'Karachi'),
('Bilal', 'Lahore'),
('Zainab', 'Karachi'),
('Usman', 'Islamabad'),
('Hina', 'Lahore'),
('Omar', 'Karachi'),
('Ayesha', 'Islamabad');

-- =========================
-- TABLE 2: Products
-- =========================
CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(50),
    price NUMERIC(10,2)
);
  select * from products;

INSERT INTO Products (product_name, category, price) VALUES
('Laptop', 'Electronics', 1200),
('Mouse', 'Electronics', 25),
('Keyboard', 'Electronics', 45),
('T-shirt', 'Apparel', 15),
('Jeans', 'Apparel', 40),
('Jacket', 'Apparel', 60),
('Coffee Mug', 'Home', 10),
('Notebook', 'Stationery', 5),
('Pen', 'Stationery', 2),
('Headphones', 'Electronics', 80);

-- =========================
-- TABLE 3: Orders
-- =========================
CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    product_id INT REFERENCES Products(product_id),
    quantity INT,
    order_date DATE
);

select * from Orders;

INSERT INTO Orders (user_id, product_id, quantity, order_date) VALUES
(1, 1, 1, '2026-01-05'),
(2, 4, 3, '2026-01-06'),
(3, 5, 2, '2026-01-07'),
(1, 2, 2, '2026-01-08'),
(4, 7, 4, '2026-01-10'),
(5, 1, 1, '2026-01-12'),
(2, 5, 1, '2026-01-13'),
(3, 2, 5, '2026-01-15'),
(4, 4, 2, '2026-01-16'),
(5, 7, 3, '2026-01-18'),
(6, 3, 1, '2026-01-20'),
(7, 6, 2, '2026-01-22'),
(8, 8, 5, '2026-01-23'),
(9, 9, 10, '2026-01-24'),
(10, 10, 1, '2026-01-25'),
(1, 5, 1, '2026-01-26'),
(2, 6, 2, '2026-01-27'),
(3, 7, 3, '2026-01-28'),
(4, 8, 2, '2026-01-29'),
(5, 9, 5, '2026-01-30');



select * from Users;

 
 select * from products;


select * from Orders;

--Total Number of users in Users table--
select count(*) as total_users from Users;

-- Total no of products from products table--
select count(*) As Total_products from products;

-- Total no of orders from Orders table--
select count(*) As Total_orders from orders;

--List all users from karachi with their user_id and name--

select user_id,name from users
       where city='Karachi';

--List all products in the Electronics category with their product_name and price--
  select product_name,price from products 
                           where category='Electronics';

-- Find total quantity sold for each products in the Order table--
SELECT p.product_name , sum(o.quantity) as Total_quantity from Orders as o 
                                                 JOIN  Products AS p ON o.product_id=p.product_id
												 group by p.product_name;

--Find total revenue per category combining products and orders--
SELECT p.category,SUM(p.price*o.quantity) as TOTAL_REVENUE from Products 
                                                                        AS p join Orders as o
		ON 	p.product_id=o.product_id
		                                  Group by p.category;
--List each user with total orders and total amount spent--
select u.user_id, u.name,COUNT(o.order_id) as TOTAL_ORDERS,sum (p.price*o.quantity) as Total_amount from Orders
                                                               AS o
		JOIN Products As p	ON o.product_id=p.product_id join Users as u ON	 u.user_id=o.user_id
		group  by u.name,u.user_id
		order by u.user_id;

--Top 2 cities with higest number of orders--
SELECT u.city,count(o.order_id) as NO_orders from Users as u join Orders as o 
                                                on u.user_id=o.user_id
												group by u.city
												order by u.city desc limit 2;
--Create a coloum "High value Ordered" for ecch order 'IF Total order Amount >50 Then 1 else 0'--
	Select o.order_id ,o.quantity,p.price,
	    CASE
		WHEN(p.price*o.quantity)>50 then 1 else 0 end AS  High_value_ORDER
		FROM Products as p JOIN Orders AS  o
		                                 ON p.product_id = o.product_id;

--Find Users who have orderd more Then Two Times--
SELECT u.name,
                          COUNT(DISTINCT o.product_id) AS Diff_Orders
						  from Users AS u Join
						 ORDERS As o
						 ON u.user_id=o.user_id
						 Group by u.name
						 Having Count(DISTINCT o.product_id)>2;

--Find Products Which Were Never Ordred--
SELECT p.product_id,p.product_name
FROM Products as p
LEFT JOIN Orders AS o
                    ON p.product_id=o.product_id
	Where o.product_id IS NULL;	
	
--List Top 3 users who spent the most along with total amount--
SELECT u.name,u.user_id ,SUM(p.price*o.quantity) As total_Amount
         FROM Users AS u
		 JOIN Orders AS o
		  ON u.user_id=o.user_id
		 JOIN Products AS p
		 ON o.product_id=p.product_id
		  GROUP by u.user_id
		 ORDER by total_Amount DESC LIMIT 3;

--Show Monthly Revenue Trend--
SELECT  SUM(p.price*o.quantity) As Monthly_revenue 
, EXTRACT(Month from o.order_date) as Monthly_date
		FROM Products AS p JOIN Orders as o
		  ON p.product_id=o.product_id
			GROUP BY Monthly_date
			order by Monthly_date;

--Find users who ordered more then one category of products--
Select u.name,u.user_id ,Count(Distinct p.category)  as total_category
                        FROM Users as u JOIN Orders as o on 
						u.user_id=o.user_id
						JOIN Products as p 
						On o.product_id=p.product_id
						Group by u.name,u.user_id
						having count(Distinct p.category)>1 ;

--TOTAL QUANTITY PER CITY AND PER CATEGORY--
SELECT  u.city,p.category,SUM(o.quantity) AS total_quantity
                       FROM Users AS u JOIN Orders AS o
					   ON u.user_id=o.user_id
					   JOIN Products As p
					   ON p.product_id=o.product_id
					   GROUP by u.city,p.category
					   ORDER BY total_quantity desc;

--Identify Repeat Customer (Users with more then 1)--
SELECT u.user_id ,COUNT(o.order_id) AS total_orders
                         FROM Users As u JOIN Orders As o 
						 ON u.user_id=o.user_id
						 Group by u.user_id
						 having COUNT(o.order_id)>1 ;
			
											  
--TOP 3 Product by Total Revenue;  
SELECT o.user_id ,sum(p.price*o.quantity) AS Total_revenue
   From Products As p JOIN Orders AS o
   ON p.product_id=o.product_id
   Group By o.user_id
   ORDER by Total_revenue DESC Limit 3;

--Average Order Value per Users--
 SELECT u.user_id,u.name,  
                  SUM(p.price*o.quantity)/COUNT(O.order_id) As AVG_Order_Value
				  FROM Users As u Join Orders As o
				  ON u.user_id=o.user_id
				  JOIN Products As p 
				  ON p.product_id=o.product_id
				  Group by u.user_id,u.name;
 
   
   
                                       
		 
									
		