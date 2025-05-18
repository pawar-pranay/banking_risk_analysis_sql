# 🏦 Banking Risk Analysis Using SQL

This SQL-based data analysis project explores customer, loan, and payment datasets to classify banking customers into risk categories. The goal is to help banks understand risk profiles and improve loan management by identifying potential defaulters and analyzing branch-level performance.

---

## 🧩 Problem Statement

Banks often face challenges in assessing customer creditworthiness, tracking late payments, and predicting loan defaults. This project aims to build a risk analysis model using structured data and SQL, helping banks classify customers into High, Medium, and Low risk.

---

## 🎯 Project Goals

- Classify customers based on default history and payment behavior  
- Analyze loan defaults and late payments  
- Generate branch-level reports for loan performance  
- Support risk mitigation and decision-making with SQL queries

---

## 🔧 Project Workflow

- Created **dummy datasets** (`customers.csv`, `loans.csv`, `payments.csv`, `branches.csv`) with Indian names and realistic values using Chatgpt
- Imported CSVs into MySQL   
- Cleaned and joined datasets using SQL (`JOIN`, `GROUP BY`, etc.)  
- Applied business logic using `CASE` to classify risk levels  
- Used **aggregate functions** to find counts, sums, and trends  
- Wrote queries to track loan performance, customer behavior, and regional risk patterns

---

## 🗃️ Dataset Overview

| Table      | Description                          |
|------------|--------------------------------------|
| `customers` | Customer info – name, age, income, branch |
| `loans`     | Loan records – amount, status (active/defaulted) |
| `payments`  | Payment logs – paid amount, is_late flag, date |
| `branches`  | Bank branch info – name, region      |

---

## 🧮 Key Queries Performed

- Classify customers as **Low**, **Medium**, or **High Risk**
- Count total loans, defaults, and late payments
- Find **branch-wise default percentages**
- Detect **top high-risk customers**
- Monthly trend of **late payments** and **defaults**

---

## 🖼 Sample Output Table

| Customer ID | Name          | Defaults | Late Payments | Risk Level |
|-------------|---------------|----------|----------------|------------|
| C102        | Ankit Sharma  | 3        | 6              | High Risk  |
| C205        | Meena Joshi   | 0        | 1              | Low Risk   |
| C311        | Ravi Kulkarni | 1        | 5              | Medium Risk|

---

## 🔍 Key Insights

- **High-risk customers** usually have **multiple defaults and >5 late payments**
- **Some branches** (especially in East and South regions) show **higher default rates**
- **Income levels** below ₹30,000 often correlate with **higher risk**  
- There are **seasonal peaks** in late payments, especially during Q1 and Q4  
- **Early detection** of risky behavior can help prevent future loan losses

---

## 📖 Summary

This project demonstrates how SQL can be used to analyze banking data and make informed decisions. By classifying customers based on loan and payment behavior, banks can better manage risk and improve lending efficiency. The project also builds strong foundations in data transformation, business logic, and query optimization.

---
