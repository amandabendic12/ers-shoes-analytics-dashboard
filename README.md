# Ers Shoes Sales and Inventory Analytics Dashboard

## Project Overview

**Ers Shoes Sales and Inventory Analytics Dashboard** is a web-based sales, inventory, and transaction management system developed using **PHP**, **MySQL**, **HTML**, **CSS**, and **Bootstrap**. The project was enhanced with a data analytics dashboard to help monitor sales performance, inventory conditions, product trends, and restocking needs.

This project is positioned as a **Data Analyst portfolio project** because it focuses on extracting, aggregating, visualizing, and interpreting business data from a relational database.

## Business Problem

Ers Shoes needs a system that can manage product and transaction data while also providing business insights. Without an analytics dashboard, the store owner may find it difficult to monitor total revenue, identify best-selling products, detect low-stock items, and evaluate sales performance by category or period.

This project addresses that problem by turning operational data into a dashboard that supports data-driven business decisions.

## Objectives

- Build a web-based inventory and transaction management system.
- Analyze sales and inventory data stored in a MySQL database.
- Display business KPIs such as revenue, transactions, quantity sold, and inventory value.
- Identify top-selling products and low-stock products.
- Provide visualizations for sales trends and category-based performance.
- Support reporting through CSV export.

## Tools and Technologies

- PHP
- MySQL / MariaDB
- SQL
- HTML
- CSS
- Bootstrap
- JavaScript
- XAMPP
- phpMyAdmin

## Dataset / Database Description

The project uses a relational database named `db_sepatu`. The main data sources include:

| Table | Description |
|---|---|
| `produk` | Product data, category, price, and stock quantity |
| `kategori` | Product category information |
| `resi` | Sales receipt / transaction header data |
| `transaksi` | Sales transaction details |
| `costumer` | Customer data |
| `staff` | Staff / cashier data |
| `user` | Login user data |
| `log_*` | Activity logs generated through database triggers |

The database also includes functions, procedures, views, and triggers to support transaction processing, stock updates, asset calculation, and activity logging.

## Data Analysis Focus

The analytics dashboard uses SQL-based aggregation to calculate and visualize business metrics such as:

- Total revenue
- Total transactions / receipts
- Total quantity sold
- Average transaction value
- Total products
- Total customers
- Inventory value
- Sales by category
- Monthly sales trend
- Top-selling products
- Low-stock products

## Dashboard Features

- Admin and cashier login
- Product management
- Category management
- Customer management
- Staff management
- Transaction and receipt management
- Sales analytics dashboard
- Inventory monitoring
- Low-stock product table
- Top-selling product table
- CSV export for reporting

## Key Business Insights

The dashboard helps answer business questions such as:

1. Which products generate the highest sales quantity?
2. Which products need to be prioritized for restocking?
3. Which product categories contribute the most revenue?
4. How does sales performance change over time?
5. What is the current inventory value of available products?

## SQL Analysis Examples

### Total Revenue

```sql
SELECT SUM(t.qty * p.harga) AS total_revenue
FROM transaksi t
JOIN produk p ON t.id_produk = p.id_produk
WHERE t.no_resi IS NOT NULL;
```

### Top-Selling Products

```sql
SELECT 
    p.produk,
    SUM(t.qty) AS total_quantity_sold,
    SUM(t.qty * p.harga) AS total_sales
FROM transaksi t
JOIN produk p ON t.id_produk = p.id_produk
WHERE t.no_resi IS NOT NULL
GROUP BY p.id_produk, p.produk
ORDER BY total_quantity_sold DESC;
```

### Low-Stock Products

```sql
SELECT id_produk, produk, qty
FROM produk
WHERE qty <= 5
ORDER BY qty ASC;
```

### Sales by Category

```sql
SELECT 
    k.nama_kategori,
    SUM(t.qty * p.harga) AS total_sales
FROM transaksi t
JOIN produk p ON t.id_produk = p.id_produk
JOIN kategori k ON p.kategori = k.id_kategori
WHERE t.no_resi IS NOT NULL
GROUP BY k.id_kategori, k.nama_kategori
ORDER BY total_sales DESC;
```

## Project Structure

```text
ers-shoes-analytics-dashboard/
├── README.md
├── .gitignore
├── LICENSE
├── portfolio_description.md
├── docs/
│   ├── screenshot_guide.md
│   ├── sql_analysis_queries.md
│   └── screenshots/
└── MSBD/
    ├── index.php
    ├── cek_login.php
    ├── koneksi.php
    ├── logout.php
    ├── main.css
    ├── db_sepatu.sql
    ├── admin/
    │   ├── index.php
    │   ├── analytics.php
    │   └── ...
    ├── kasir/
    ├── assets/
    └── image/
```

## How to Run the Project Locally

### 1. Move Project Folder

Copy the `MSBD` folder into the XAMPP `htdocs` directory:

```text
C:\xampp\htdocs\MSBD
```

### 2. Start XAMPP

Start:

- Apache
- MySQL

### 3. Create Database

Open phpMyAdmin:

```text
http://localhost/phpmyadmin
```

Create a new database:

```text
db_sepatu
```

### 4. Import Database

Import this file:

```text
MSBD/db_sepatu.sql
```

### 5. Open the Website

```text
http://localhost/MSBD/
```

### 6. Open Analytics Dashboard

After logging in as admin, open:

```text
http://localhost/MSBD/admin/analytics.php
```

## Portfolio Positioning

This project can be presented as a **Data Analyst portfolio project** because it demonstrates:

- SQL data extraction and aggregation
- Relational database understanding
- KPI dashboard development
- Sales and inventory analysis
- Business insight generation
- Reporting and CSV export
- Data-driven restocking support

## Resume / CV Description

**Ers Shoes: Sales and Inventory Analytics Dashboard**  
- Developed a web-based sales and inventory analytics dashboard using PHP, MySQL, HTML, CSS, and Bootstrap to support product, customer, transaction, and stock management.  
- Designed SQL-based analytics to calculate key business metrics, including total revenue, total transactions, quantity sold, average transaction value, top-selling products, low-stock items, and monthly sales trends.  
- Created data visualizations and exportable reports to support inventory monitoring, sales performance analysis, and data-driven restocking decisions.

## Screenshots

Add dashboard screenshots inside:

```text
docs/screenshots/
```

Recommended screenshots:

- Login page
- Admin dashboard
- Analytics dashboard KPI cards
- Sales trend chart
- Top-selling product chart
- Low-stock product table
- CSV export result

## Notes

This project is designed for local development using XAMPP. It is not deployed to GitHub Pages because PHP and MySQL require a server-side environment.
