-- Q1: Create Customers Table
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    customer_email VARCHAR(100) UNIQUE NOT NULL,
    customer_city VARCHAR(50)
);

-- Q2: Create Products Table
CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    unit_price DECIMAL(10, 2) NOT NULL
);

-- Q3: Create Sales Representatives Table
CREATE TABLE sales_reps (
    sales_rep_id VARCHAR(50) PRIMARY KEY,
    sales_rep_name VARCHAR(100) NOT NULL,
    sales_rep_email VARCHAR(100) UNIQUE NOT NULL,
    office_address TEXT
);

-- Q4: Create Orders Table
CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id VARCHAR(50) NOT NULL,
    sales_rep_id VARCHAR(50) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (sales_rep_id) REFERENCES sales_reps(sales_rep_id)
);

-- Q5: Create Order Items (Line Items) Table
CREATE TABLE order_items (
    order_id VARCHAR(50) NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert into Customers
INSERT INTO customers (customer_id, customer_name, customer_email, customer_city)
SELECT DISTINCT customer_id, customer_name, customer_email, customer_city
FROM orders_flat;

-- Insert into Products
INSERT INTO products (product_id, product_name, category, unit_price)
SELECT DISTINCT product_id, product_name, category, unit_price
FROM orders_flat;

-- Insert into Sales Representatives
INSERT INTO sales_reps (sales_rep_id, sales_rep_name, sales_rep_email, office_address)
SELECT DISTINCT sales_rep_id, sales_rep_name, sales_rep_email, office_address
FROM orders_flat;

-- Insert into Orders
INSERT INTO orders (order_id, order_date, customer_id, sales_rep_id)
SELECT DISTINCT order_id, order_date, customer_id, sales_rep_id
FROM orders_flat;

-- Insert into Order Items
INSERT INTO order_items (order_id, product_id, quantity)
SELECT order_id, product_id, quantity
FROM orders_flat;
