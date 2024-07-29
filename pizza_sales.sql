CREATE DATABASE pizzahut;

USE pizzahut;

CREATE TABLE pizzas
(
pizza_id TEXT NOT NULL PRIMARY KEY,
pizza_type_id TEXT NOT NULL,
size TEXT NOT NULL,
price double NOT NULL
);

CREATE TABLE pizza_types
(
pizza_type_id TEXT NOT NULL,
name TEXT NOT NULL,
category TEXT NOT NULL,
ingredients TEXT NOT NULL,
PRIMARY KEY(pizza_type_id)
);


CREATE TABLE orders(
order_id INT NOT NULL,
order_date date NOT NULL,
order_time TIME NOT NULL,
PRIMARY KEY(order_id)
);


CREATE TABLE order_details(
order_details_id int NOT NULL PRIMARY KEY,
order_id INT NOT NULL,
pizza_id TEXT NOT NULL,
quantity INT NOT NULL
);

