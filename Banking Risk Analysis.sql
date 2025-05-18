-- Project: Banking Risk Analysis 
-- Dataset: customers_indian.csv, loans_data.csv, payments_data.csv, branches_dataS.csv

-- Create Database
CREATE DATABASE bank_loan_analysis;
USE bank_loan_analysis;

-- 1. Create Tables
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    gender VARCHAR(10),
    age INT,
    income DECIMAL(15,2),
    region VARCHAR(50),
    join_date DATE
);

CREATE TABLE loans (
    loan_id INT PRIMARY KEY,
    customer_id INT,
    loan_type VARCHAR(50),
    loan_amount DECIMAL(15,2),
    interest_rate DECIMAL(5,2),
    start_date DATE,
    end_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    loan_id INT,
    payment_date DATE,
    amount_paid DECIMAL(15,2),
    is_late BOOLEAN,
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);

CREATE TABLE branches (
    branch_id INT PRIMARY KEY,
    region VARCHAR(50),
    manager_name VARCHAR(100)
);

-- 2. Tables Overlooks
select * from customers;
select * from loans;
select * from branches;
select * from payments;


-- 3.  Data Analysis

--  Customer Aggregation CTE: Calculate total loans and counts per customer

WITH customer_agg AS (
    SELECT 
        c.customer_id,
        c.name,
        c.age,
        c.income,
        COUNT(DISTINCT l.loan_id) AS total_loans,
        SUM(CASE WHEN l.status = 'Defaulted' THEN 1 ELSE 0 END) AS defaults,
        COALESCE(SUM(CASE WHEN p.is_late = 1 THEN 1 ELSE 0 END), 0) AS late_payments
    FROM customers c
    JOIN loans l ON c.customer_id = l.customer_id
    LEFT JOIN payments p ON l.loan_id = p.loan_id
    GROUP BY c.customer_id, c.name, c.age, c.income
)

-- Final risk classification and customer analysis

SELECT
    customer_id,
    name,
    age,
    income,
    total_loans,
    defaults,
    late_payments,
    CASE 
        WHEN defaults >= 2 THEN 'High Risk'
        WHEN late_payments >= 5 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_level
FROM customer_agg
ORDER BY risk_level DESC, defaults DESC, late_payments DESC;


--  Branch-level default rate analysis

SELECT 
    b.region,
    COUNT(DISTINCT l.loan_id) AS total_loans,
    SUM(CASE WHEN l.status = 'Defaulted' THEN 1 ELSE 0 END) AS defaulted_loans,
    ROUND(SUM(CASE WHEN l.status = 'Defaulted' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT l.loan_id), 2) AS default_rate_percent
FROM branches b
JOIN customers c ON b.region = c.region
JOIN loans l ON c.customer_id = l.customer_id
GROUP BY b.region
ORDER BY default_rate_percent DESC;


-- Monthly late payment trends

SELECT 
    DATE_FORMAT(payment_date, '%Y-%m') AS month,
    COUNT(*) AS total_payments,
    SUM(is_late) AS late_payments,
    ROUND(SUM(is_late) * 100.0 / COUNT(*), 2) AS late_payment_rate_percent
FROM payments
GROUP BY month
ORDER BY month;


-- Top 10 customers by on-time payment rate


WITH payment_stats AS (
    SELECT 
        c.customer_id,
        c.name,
        COUNT(p.payment_id) AS total_payments,
        SUM(CASE WHEN p.is_late = 0 THEN 1 ELSE 0 END) AS on_time_payments
    FROM customers c
    JOIN loans l ON c.customer_id = l.customer_id
    JOIN payments p ON l.loan_id = p.loan_id
    GROUP BY c.customer_id, c.name
)

SELECT
    customer_id,
    name,
    total_payments,
    on_time_payments,
    ROUND(on_time_payments * 100.0 / total_payments, 2) AS on_time_payment_rate_percent
FROM payment_stats
WHERE total_payments > 0
ORDER BY on_time_payment_rate_percent DESC
LIMIT 10;


--  Average loan amount and interest rate by region and loan type

SELECT 
    c.region,
    l.loan_type,
    COUNT(*) AS number_of_loans,
    ROUND(AVG(l.loan_amount), 2) AS avg_loan_amount,
    ROUND(AVG(l.interest_rate), 2) AS avg_interest_rate
FROM loans l
JOIN customers c ON l.customer_id = c.customer_id
GROUP BY c.region, l.loan_type
ORDER BY c.region, l.loan_type;