use pizzahut;

-- Basic:
-- 1.Retrieve the total number of orders placed.
SELECT 
    COUNT(*) AS total_no_orders
FROM
    orders;

-- 2.Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(od.quantity * p.price), 2) AS Total_sales
FROM
    order_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id;


-- 3.Identify the highest-priced pizza.

SELECT 
    pt.name, p.price
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;


-- 4.Identify the most common pizza size ordered.
SELECT 
    p.size, COUNT(od.order_details_id) order_count
FROM
    pizzas p
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY order_count DESC;

-- 5.List the top 5 most ordered pizza types along with their quantities.
SELECT 
    pt.name, SUM(od.quantity) Quantity
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY Quantity DESC
LIMIT 5;

-- Intermediate:
-- 6.Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    pt.category, SUM(od.quantity) AS Quantity
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY Quantity DESC;

-- 7.Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(order_time), COUNT(order_id)
FROM
    orders
GROUP BY HOUR(order_time);

-- 8.Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;

-- 9.Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    ROUND(AVG(quantity), 0) avg_pizza_ordered_per_day
FROM
    (SELECT 
        o.order_date, SUM(od.quantity) AS quantity
    FROM
        orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.order_date) AS Order_quantity;

-- 10.Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    pt.name, SUM(od.quantity * p.price) AS revenue
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY revenue DESC
LIMIT 3;


-- Advanced:
-- 11.Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    pt.category,
    ROUND(SUM(od.quantity * p.price) / (SELECT 
                    ROUND(SUM(od.quantity * p.price), 2) AS total_sales
                FROM
                    order_details od
                        JOIN
                    pizzas p ON p.pizza_id = od.pizza_id) * 100,
            2) AS revenue
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.category
ORDER BY revenue DESC;

-- 12.Analyze the cumulative revenue generated over time.
WITH salesCTE AS
(
SELECT o.order_date AS order_date,
SUM(od.quantity * p.price) AS revenue
FROM order_details od JOIN pizzas p
ON od.pizza_id=p.pizza_id
JOIN orders o
on o.order_id=od.order_id
GROUP BY o.order_date
)
SELECT order_date,
ROUND(SUM(revenue)over(ORDER BY order_date) ,2)AS cum_revenue
FROM salesCTE;
-- 13.Determine the top 3 most ordered pizza types based on revenue for each pizza category.
WITH CTE AS
(
SELECT 
pt.category,pt.name,
SUM((od.quantity*p.price))AS revenue
FROM pizza_types pt JOIN pizzas p
ON pt.pizza_type_id=p.pizza_type_id
JOIN
order_details od
ON od.pizza_id=p.pizza_id 
GROUP BY pt.category,pt.name
)
SELECT category,name,revenue,
RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS rn
FROM CTE;