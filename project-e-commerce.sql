CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    gender VARCHAR(10),
    city VARCHAR(50),
    signup_date DATE
);
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_status VARCHAR(30),
    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id)
    REFERENCES orders(order_id),
    FOREIGN KEY (product_id)
    REFERENCES products(product_id)
);

INSERT INTO customers VALUES
(1,'Arun','Male','Chennai','2026-01-09'),
(2,'Aamna','Female','Kerala','2026-03-12'),
(3,'Roshni','Female','Pune','2026-04-16'),
(4,'Sumita','Female','Bangalore','2026-05-21'),
(5,'Ahmed','Male','Hyderabad','2026-05-23'),
(6,'Ali','Male','Delhi','2026-06-30');

INSERT INTO products VALUES
(001,'Laptop','Electronics',75000),
(002,'Headphones','Electronics',3000),
(003,'Table','Furniture',9000),
(004,'Keyboard','Electronics',1800),
(005,'Water Bottle','Home',600),
(006,'TV','Home',27900);

INSERT INTO orders VALUES
(0001,1,'2026-01-25','Delivered'),
(0002,2,'2026-03-29','Delivered'),
(0003,1,'2026-05-03','Delivered'),
(0004,3,'2026-06-01','Cancelled'),
(0005,4,'2026-06-12','Delivered'),
(0006,5,'2026-07-05','Cancelled');

INSERT INTO order_items VALUES
(1,0001,001,1,75000),
(2,0002,002,2,3000),
(3,0003,003,1,9000),
(4,0004,004,1,1800),
(5,0005,005,3,600),
(6,0006,001,1,75000);

ALTER TABLE orders ADD COLUMN payment_method VARCHAR(30);

UPDATE orders SET payment_method = 'Debit Card' WHERE order_id = 1;
UPDATE orders SET payment_method = 'UPI' WHERE order_id = 2;
UPDATE orders SET payment_method = 'Cash on Delivery' WHERE order_id = 3;
UPDATE orders SET payment_method = 'UPI' WHERE order_id = 4;
UPDATE orders SET payment_method = 'Credit Card' WHERE order_id = 5;
UPDATE orders SET payment_method = 'Cash on Delivery' WHERE order_id = 6;

-- Revenue by payment method
SELECT o.payment_method,
       SUM(oi.quantity * oi.unit_price) AS total_revenue,
       COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY o.payment_method
ORDER BY total_revenue DESC;

SELECT o.payment_method,
       SUM(oi.quantity * oi.unit_price) AS total_revenue,
       COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY o.payment_method
ORDER BY total_revenue DESC;

SELECT c.customer_name,
       SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 5;

SELECT DATE_TRUNC('month', o.order_date) AS month,
       SUM(oi.quantity * oi.unit_price) AS monthly_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY month
ORDER BY month;

SELECT 
  ROUND(100.0 * COUNT(*) FILTER (WHERE payment_method = 'Cash on Delivery') / COUNT(*), 2) AS cod_percentage
FROM orders;

-- Order Status & Cancellation Rate
SELECT order_status, COUNT(*) AS num_orders
FROM orders
GROUP BY order_status;

SELECT ROUND(100.0 * COUNT(*) FILTER (WHERE order_status = 'Cancelled') / COUNT(*), 1) AS cancellation_rate
FROM orders;

-- Bigger realistic dataset: 30 customers, 15 products, 100 orders

TRUNCATE order_items, orders, products, customers RESTART IDENTITY CASCADE;

INSERT INTO customers (customer_id, customer_name, gender, city, signup_date) VALUES
(1, 'Rahul', 'Male', 'Mumbai', '2026-04-08'),
(2, 'Priya', 'Female', 'Bangalore', '2025-11-27'),
(3, 'Amit', 'Male', 'Delhi', '2026-03-23'),
(4, 'Sneha', 'Male', 'Lucknow', '2026-01-17'),
(5, 'Rohan', 'Male', 'Mumbai', '2025-10-24'),
(6, 'Ali', 'Male', 'Bangalore', '2026-02-07'),
(7, 'Fatima', 'Male', 'Jaipur', '2025-11-20'),
(8, 'Vikram', 'Female', 'Bangalore', '2026-01-23'),
(9, 'Anjali', 'Female', 'Mumbai', '2026-04-13'),
(10, 'Karan', 'Male', 'Kolkata', '2025-12-27'),
(11, 'Neha', 'Female', 'Pune', '2025-11-25'),
(12, 'Suresh', 'Female', 'Delhi', '2025-10-24'),
(13, 'Pooja', 'Female', 'Delhi', '2025-12-31'),
(14, 'Arjun', 'Female', 'Lucknow', '2025-12-07'),
(15, 'Divya', 'Male', 'Ahmedabad', '2026-02-15'),
(16, 'Manoj', 'Male', 'Kolkata', '2025-10-21'),
(17, 'Kavya', 'Female', 'Lucknow', '2026-01-01'),
(18, 'Rajesh', 'Male', 'Delhi', '2025-10-12'),
(19, 'Meera', 'Male', 'Hyderabad', '2025-10-21'),
(20, 'Sanjay', 'Male', 'Delhi', '2026-01-06'),
(21, 'Nisha', 'Female', 'Ahmedabad', '2026-03-12'),
(22, 'Vivek', 'Female', 'Pune', '2026-01-03'),
(23, 'Riya', 'Female', 'Bangalore', '2026-03-21'),
(24, 'Aditya', 'Female', 'Delhi', '2026-03-05'),
(25, 'Swati', 'Male', 'Jaipur', '2026-04-05'),
(26, 'Gaurav', 'Male', 'Pune', '2026-01-27'),
(27, 'Shreya', 'Female', 'Hyderabad', '2026-03-13'),
(28, 'Nikhil', 'Male', 'Chennai', '2026-04-15'),
(29, 'Anita', 'Male', 'Bangalore', '2025-10-09'),
(30, 'Deepak', 'Female', 'Kolkata', '2025-12-08');

INSERT INTO products (product_id, product_name, category, price) VALUES
(1, 'Laptop', 'Electronics', 65000),
(2, 'Headphones', 'Electronics', 2500),
(3, 'Office Chair', 'Furniture', 7000),
(4, 'Keyboard', 'Electronics', 1800),
(5, 'Water Bottle', 'Home', 600),
(6, 'Smartwatch', 'Electronics', 4500),
(7, 'Study Table', 'Furniture', 5500),
(8, 'Desk Lamp', 'Home', 900),
(9, 'Backpack', 'Accessories', 1500),
(10, 'Wireless Mouse', 'Electronics', 1200),
(11, 'Bookshelf', 'Furniture', 6200),
(12, 'Coffee Mug', 'Home', 300),
(13, 'Bluetooth Speaker', 'Electronics', 2800),
(14, 'Yoga Mat', 'Sports', 1100),
(15, 'Running Shoes', 'Sports', 3200);

ALTER TABLE orders ADD COLUMN IF NOT EXISTS payment_method VARCHAR(30);

INSERT INTO orders (order_id, customer_id, order_date, order_status, payment_method) VALUES
(1, 3, '2026-02-24', 'Cancelled', 'Debit Card'),
(2, 13, '2026-06-14', 'Delivered', 'Credit Card'),
(3, 18, '2026-03-09', 'Cancelled', 'Cash on Delivery'),
(4, 3, '2026-01-13', 'Delivered', 'Credit Card'),
(5, 13, '2026-04-08', 'Cancelled', 'Cash on Delivery'),
(6, 22, '2026-05-18', 'Delivered', 'Debit Card'),
(7, 6, '2026-04-27', 'Delivered', 'Debit Card'),
(8, 27, '2026-06-13', 'Cancelled', 'Net Banking'),
(9, 25, '2026-02-11', 'Cancelled', 'Net Banking'),
(10, 16, '2026-01-05', 'Delivered', 'Debit Card'),
(11, 3, '2026-01-22', 'Delivered', 'UPI'),
(12, 6, '2026-03-09', 'Cancelled', 'Net Banking'),
(13, 7, '2026-07-02', 'Delivered', 'Cash on Delivery'),
(14, 8, '2026-02-27', 'Delivered', 'Debit Card'),
(15, 8, '2026-05-31', 'Delivered', 'UPI'),
(16, 2, '2026-02-28', 'Delivered', 'UPI'),
(17, 22, '2026-05-05', 'Delivered', 'Net Banking'),
(18, 19, '2026-05-02', 'Delivered', 'Cash on Delivery'),
(19, 14, '2026-04-01', 'Delivered', 'Cash on Delivery'),
(20, 21, '2026-06-15', 'Delivered', 'UPI'),
(21, 7, '2026-02-18', 'Cancelled', 'Cash on Delivery'),
(22, 9, '2026-04-29', 'Delivered', 'UPI'),
(23, 2, '2026-06-16', 'Cancelled', 'UPI'),
(24, 6, '2026-04-15', 'Delivered', 'Cash on Delivery'),
(25, 29, '2026-01-16', 'Delivered', 'Cash on Delivery'),
(26, 30, '2026-04-27', 'Delivered', 'Cash on Delivery'),
(27, 5, '2026-02-18', 'Delivered', 'Credit Card'),
(28, 18, '2026-01-16', 'Delivered', 'UPI'),
(29, 17, '2026-05-16', 'Delivered', 'UPI'),
(30, 22, '2026-03-02', 'Delivered', 'UPI'),
(31, 14, '2026-06-18', 'Cancelled', 'Net Banking'),
(32, 8, '2026-03-09', 'Delivered', 'Credit Card'),
(33, 15, '2026-06-09', 'Cancelled', 'UPI'),
(34, 17, '2026-03-09', 'Delivered', 'Debit Card'),
(35, 12, '2026-03-14', 'Delivered', 'Cash on Delivery'),
(36, 22, '2026-05-22', 'Delivered', 'UPI'),
(37, 29, '2026-01-28', 'Cancelled', 'Credit Card'),
(38, 11, '2026-02-22', 'Delivered', 'Net Banking'),
(39, 21, '2026-04-19', 'Delivered', 'UPI'),
(40, 21, '2026-03-09', 'Delivered', 'Cash on Delivery'),
(41, 29, '2026-06-26', 'Delivered', 'Net Banking'),
(42, 19, '2026-05-22', 'Delivered', 'Cash on Delivery'),
(43, 12, '2026-01-11', 'Delivered', 'Credit Card'),
(44, 20, '2026-02-09', 'Delivered', 'Credit Card'),
(45, 1, '2026-02-15', 'Delivered', 'Cash on Delivery'),
(46, 26, '2026-06-29', 'Delivered', 'Cash on Delivery'),
(47, 8, '2026-02-21', 'Delivered', 'Debit Card'),
(48, 1, '2026-06-18', 'Delivered', 'Cash on Delivery'),
(49, 12, '2026-06-14', 'Cancelled', 'Cash on Delivery'),
(50, 6, '2026-05-29', 'Delivered', 'UPI'),
(51, 12, '2026-07-06', 'Delivered', 'Cash on Delivery'),
(52, 2, '2026-07-01', 'Delivered', 'UPI'),
(53, 24, '2026-06-21', 'Delivered', 'Debit Card'),
(54, 11, '2026-06-19', 'Delivered', 'Debit Card'),
(55, 10, '2026-05-22', 'Delivered', 'Credit Card'),
(56, 29, '2026-02-14', 'Cancelled', 'Net Banking'),
(57, 10, '2026-02-23', 'Delivered', 'Net Banking'),
(58, 7, '2026-05-11', 'Delivered', 'Credit Card'),
(59, 11, '2026-01-24', 'Delivered', 'Debit Card'),
(60, 5, '2026-01-07', 'Delivered', 'Credit Card'),
(61, 14, '2026-06-11', 'Cancelled', 'Credit Card'),
(62, 21, '2026-06-26', 'Delivered', 'UPI'),
(63, 15, '2026-01-13', 'Cancelled', 'Credit Card'),
(64, 26, '2026-04-29', 'Cancelled', 'Net Banking'),
(65, 14, '2026-05-21', 'Delivered', 'Credit Card'),
(66, 9, '2026-05-14', 'Delivered', 'Credit Card'),
(67, 8, '2026-03-11', 'Delivered', 'Debit Card'),
(68, 5, '2026-06-30', 'Delivered', 'UPI'),
(69, 14, '2026-01-16', 'Delivered', 'Cash on Delivery'),
(70, 1, '2026-05-28', 'Delivered', 'Cash on Delivery'),
(71, 25, '2026-04-10', 'Delivered', 'Net Banking'),
(72, 8, '2026-03-11', 'Delivered', 'Cash on Delivery'),
(73, 22, '2026-06-23', 'Delivered', 'Credit Card'),
(74, 1, '2026-04-11', 'Cancelled', 'Net Banking'),
(75, 6, '2026-01-13', 'Delivered', 'Cash on Delivery'),
(76, 25, '2026-04-08', 'Delivered', 'Cash on Delivery'),
(77, 24, '2026-05-19', 'Delivered', 'Debit Card'),
(78, 25, '2026-06-16', 'Delivered', 'UPI'),
(79, 20, '2026-02-09', 'Delivered', 'Credit Card'),
(80, 15, '2026-06-29', 'Delivered', 'Debit Card'),
(81, 24, '2026-07-03', 'Delivered', 'Credit Card'),
(82, 19, '2026-06-23', 'Delivered', 'Cash on Delivery'),
(83, 4, '2026-06-28', 'Delivered', 'Net Banking'),
(84, 26, '2026-01-11', 'Delivered', 'Net Banking'),
(85, 21, '2026-03-29', 'Delivered', 'Cash on Delivery'),
(86, 29, '2026-04-28', 'Delivered', 'Cash on Delivery'),
(87, 21, '2026-03-11', 'Cancelled', 'Net Banking'),
(88, 9, '2026-03-24', 'Delivered', 'UPI'),
(89, 19, '2026-06-06', 'Delivered', 'Debit Card'),
(90, 6, '2026-05-05', 'Delivered', 'Debit Card'),
(91, 29, '2026-03-12', 'Cancelled', 'UPI'),
(92, 18, '2026-03-03', 'Delivered', 'Cash on Delivery'),
(93, 8, '2026-04-14', 'Delivered', 'Debit Card'),
(94, 14, '2026-05-21', 'Delivered', 'Debit Card'),
(95, 24, '2026-02-19', 'Delivered', 'UPI'),
(96, 24, '2026-05-04', 'Delivered', 'Net Banking'),
(97, 12, '2026-02-15', 'Delivered', 'UPI'),
(98, 10, '2026-06-28', 'Delivered', 'Cash on Delivery'),
(99, 19, '2026-03-14', 'Delivered', 'Cash on Delivery'),
(100, 28, '2026-05-03', 'Delivered', 'UPI');

INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES
(1, 1, 11, 2, 6200),
(2, 2, 3, 3, 7000),
(3, 2, 4, 3, 1800),
(4, 3, 7, 1, 5500),
(5, 3, 6, 3, 4500),
(6, 3, 4, 2, 1800),
(7, 4, 3, 2, 7000),
(8, 4, 13, 3, 2800),
(9, 4, 11, 1, 6200),
(10, 5, 5, 3, 600),
(11, 5, 9, 3, 1500),
(12, 5, 1, 1, 65000),
(13, 6, 5, 2, 600),
(14, 7, 13, 1, 2800),
(15, 7, 3, 3, 7000),
(16, 7, 9, 2, 1500),
(17, 8, 3, 2, 7000),
(18, 9, 10, 2, 1200),
(19, 10, 4, 1, 1800),
(20, 10, 1, 3, 65000),
(21, 11, 13, 3, 2800),
(22, 11, 3, 2, 7000),
(23, 11, 14, 3, 1100),
(24, 12, 4, 3, 1800),
(25, 12, 9, 3, 1500),
(26, 13, 11, 3, 6200),
(27, 13, 6, 2, 4500),
(28, 13, 8, 1, 900),
(29, 14, 10, 3, 1200),
(30, 15, 12, 3, 300),
(31, 16, 2, 1, 2500),
(32, 16, 9, 2, 1500),
(33, 17, 12, 3, 300),
(34, 18, 4, 1, 1800),
(35, 18, 2, 3, 2500),
(36, 19, 14, 1, 1100),
(37, 19, 12, 3, 300),
(38, 20, 12, 1, 300),
(39, 20, 6, 1, 4500),
(40, 21, 7, 1, 5500),
(41, 22, 13, 3, 2800),
(42, 22, 14, 1, 1100),
(43, 23, 15, 1, 3200),
(44, 24, 14, 2, 1100),
(45, 25, 7, 2, 5500),
(46, 26, 12, 3, 300),
(47, 26, 13, 3, 2800),
(48, 26, 9, 2, 1500),
(49, 27, 10, 3, 1200),
(50, 28, 10, 2, 1200),
(51, 29, 2, 1, 2500),
(52, 29, 14, 3, 1100),
(53, 29, 3, 1, 7000),
(54, 30, 4, 1, 1800),
(55, 30, 10, 3, 1200),
(56, 30, 14, 1, 1100),
(57, 31, 6, 3, 4500),
(58, 31, 5, 3, 600),
(59, 31, 4, 2, 1800),
(60, 32, 11, 2, 6200),
(61, 32, 5, 1, 600),
(62, 32, 8, 1, 900),
(63, 33, 9, 1, 1500),
(64, 34, 15, 1, 3200),
(65, 35, 12, 3, 300),
(66, 35, 5, 3, 600),
(67, 35, 10, 1, 1200),
(68, 36, 5, 1, 600),
(69, 37, 5, 1, 600),
(70, 37, 10, 3, 1200),
(71, 38, 5, 1, 600),
(72, 38, 14, 1, 1100),
(73, 39, 6, 1, 4500),
(74, 40, 12, 1, 300),
(75, 40, 7, 1, 5500),
(76, 40, 9, 1, 1500),
(77, 41, 14, 2, 1100),
(78, 42, 1, 2, 65000),
(79, 43, 4, 2, 1800),
(80, 43, 11, 3, 6200),
(81, 43, 2, 2, 2500),
(82, 44, 15, 2, 3200),
(83, 45, 14, 1, 1100),
(84, 45, 12, 2, 300),
(85, 45, 13, 1, 2800),
(86, 46, 14, 2, 1100),
(87, 47, 14, 1, 1100),
(88, 47, 13, 1, 2800),
(89, 48, 5, 1, 600),
(90, 48, 14, 2, 1100),
(91, 49, 14, 1, 1100),
(92, 49, 9, 1, 1500),
(93, 49, 6, 2, 4500),
(94, 50, 10, 2, 1200),
(95, 51, 9, 3, 1500),
(96, 51, 2, 1, 2500),
(97, 51, 7, 2, 5500),
(98, 52, 15, 3, 3200),
(99, 52, 13, 3, 2800),
(100, 52, 9, 3, 1500),
(101, 53, 2, 2, 2500),
(102, 53, 11, 3, 6200),
(103, 54, 5, 2, 600),
(104, 54, 11, 2, 6200),
(105, 54, 7, 3, 5500),
(106, 55, 11, 3, 6200),
(107, 55, 7, 3, 5500),
(108, 56, 7, 1, 5500),
(109, 56, 9, 2, 1500),
(110, 57, 11, 2, 6200),
(111, 57, 6, 2, 4500),
(112, 57, 8, 3, 900),
(113, 58, 2, 3, 2500),
(114, 58, 5, 3, 600),
(115, 58, 9, 3, 1500),
(116, 59, 13, 1, 2800),
(117, 60, 10, 1, 1200),
(118, 60, 14, 2, 1100),
(119, 61, 12, 2, 300),
(120, 61, 7, 1, 5500),
(121, 61, 8, 1, 900),
(122, 62, 4, 3, 1800),
(123, 62, 3, 3, 7000),
(124, 63, 8, 1, 900),
(125, 64, 6, 3, 4500),
(126, 64, 13, 3, 2800),
(127, 64, 8, 3, 900),
(128, 65, 14, 2, 1100),
(129, 65, 8, 1, 900),
(130, 65, 15, 3, 3200),
(131, 66, 8, 3, 900),
(132, 66, 2, 2, 2500),
(133, 67, 2, 1, 2500),
(134, 67, 3, 2, 7000),
(135, 67, 14, 3, 1100),
(136, 68, 7, 3, 5500),
(137, 68, 6, 2, 4500),
(138, 69, 15, 3, 3200),
(139, 69, 13, 3, 2800),
(140, 70, 6, 2, 4500),
(141, 71, 12, 3, 300),
(142, 71, 9, 1, 1500),
(143, 71, 13, 2, 2800),
(144, 72, 7, 2, 5500),
(145, 73, 15, 3, 3200),
(146, 73, 3, 3, 7000),
(147, 74, 1, 2, 65000),
(148, 74, 2, 1, 2500),
(149, 74, 11, 2, 6200),
(150, 75, 4, 2, 1800),
(151, 75, 8, 2, 900),
(152, 76, 14, 2, 1100),
(153, 76, 2, 1, 2500),
(154, 77, 11, 1, 6200),
(155, 78, 4, 1, 1800),
(156, 79, 11, 3, 6200),
(157, 79, 2, 1, 2500),
(158, 80, 10, 3, 1200),
(159, 81, 2, 1, 2500),
(160, 81, 10, 2, 1200),
(161, 82, 4, 3, 1800),
(162, 82, 2, 3, 2500),
(163, 82, 10, 1, 1200),
(164, 83, 13, 3, 2800),
(165, 84, 11, 1, 6200),
(166, 84, 6, 3, 4500),
(167, 85, 2, 2, 2500),
(168, 85, 7, 3, 5500),
(169, 86, 12, 3, 300),
(170, 87, 8, 3, 900),
(171, 87, 7, 3, 5500),
(172, 88, 15, 1, 3200),
(173, 88, 8, 2, 900),
(174, 89, 8, 2, 900),
(175, 90, 6, 3, 4500),
(176, 90, 5, 3, 600),
(177, 91, 4, 3, 1800),
(178, 91, 2, 2, 2500),
(179, 91, 15, 2, 3200),
(180, 92, 13, 1, 2800),
(181, 92, 1, 2, 65000),
(182, 93, 10, 3, 1200),
(183, 93, 6, 3, 4500),
(184, 93, 8, 2, 900),
(185, 94, 8, 2, 900),
(186, 94, 5, 1, 600),
(187, 94, 14, 1, 1100),
(188, 95, 9, 1, 1500),
(189, 95, 13, 1, 2800),
(190, 95, 12, 1, 300),
(191, 96, 10, 1, 1200),
(192, 96, 5, 2, 600),
(193, 96, 2, 1, 2500),
(194, 97, 9, 1, 1500),
(195, 97, 3, 1, 7000),
(196, 97, 5, 3, 600),
(197, 98, 14, 1, 1100),
(198, 99, 6, 1, 4500),
(199, 99, 3, 2, 7000),
(200, 100, 8, 3, 900),
(201, 100, 2, 3, 2500);

-- ============================================
-- Best-Selling Products (Revenue)
-- ============================================
SELECT p.product_name, SUM(oi.quantity * oi.unit_price) AS product_revenue
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_name
ORDER BY product_revenue DESC
LIMIT 8;

-- ============================================
-- Revenue by Category
-- ============================================
SELECT p.category, SUM(oi.quantity * oi.unit_price) AS category_revenue
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.category
ORDER BY category_revenue DESC;

-- ============================================
-- City-Wise Revenue
-- ============================================
SELECT c.city, SUM(oi.quantity * oi.unit_price) AS city_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY c.city
ORDER BY city_revenue DESC
LIMIT 6;

-- ============================================
-- Customer Loyalty: Orders per Customer
-- (repeat vs one-time buyers, computed from this result in Python/Excel)
-- ============================================
SELECT customer_id, COUNT(*) AS num_orders
FROM orders
WHERE order_status = 'Delivered'
GROUP BY customer_id
ORDER BY num_orders DESC;
