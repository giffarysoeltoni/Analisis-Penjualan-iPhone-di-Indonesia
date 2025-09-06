create schema iphone_indonesia_market;

-- table customers
create table customers(
customer_id integer,
name varchar(50),
email varchar(50),
address varchar(50),
phone_number varchar(50),
age varchar(3),
city varchar(50),
preferred_product_id varchar(2)
);

--table products
create table products(
product_id varchar(2),
product_name varchar(50),
category char(10),
brand char(5),
price integer,
description varchar(150),
discount integer,
storage varchar(10),
color varchar(10),
release_year smallint,
years_since_release integer,
sales_factor integer, 
preferred_product_id varchar(2)
);


--table transaction_details
create table transaction_details(
transaction_id integer,
product_id varchar(2),
quantity integer,
unit_price integer,
discount integer,
total integer
);

--table transactions
create table transactions(
transaction_id integer,
customer_id integer, 
transaction_date date,
total_amount integer,
payment_method varchar(50),
shipping_method varchar(50),
delivery_time varchar(20),
coupon_code varchar(20),
city varchar(50),
product_id varchar(2),
sales_factor integer
);

select*from products;

ALTER TABLE iphone_indonesia_market.customers
ALTER COLUMN address TYPE TEXT;
;

-- cek null tabel customers
select count(*) as total_rows,
count(*) filter(where customer_id is null) as null_customer_id,
count(*) filter(where name is null) as null_name,
count(*) filter(where email is null) as null_email,
count(*) filter(where address is null) as null_address,
count(*) filter(where phone_number is null) as null_phone_number,
count(*) filter(where age is null) as null_age,
count(*) filter(where city is null) as null_city,
count(*) filter(where preferred_product_id is null) as null_preferred_product_id
from iphone_indonesia_market.customers;


-- cek null tabel products
select count(*) as table_rows,
count(*) filter(where product_id is null) as null_product_id,
count(*) filter(where product_name is null) as null_product_name,
count(*) filter(where category is null) as null_category,
count(*) filter(where brand is null) as null_brand,
count(*) filter(where price is null) as null_price,
count(*) filter(where description is null) as null_description,
count(*) filter(where discount is null) as null_discount,
count(*) filter(where storage is null) as null_storage,
count(*) filter(where color is null) as null_color,
count(*) filter(where release_year is null) as null_release_year,
count(*) filter(where years_since_release is null) as null_year_since_release,
count(*) filter(where sales_factor is null) as null_sales_factor,
count(*) filter(where preferred_product_id is null) as null_preferred_product_id
from iphone_indonesia_market.products;

-- cek null transaction_details
select count(*) as total_rows,
count(*) filter(where transaction_id is null) as null_transaction_id,
count(*) filter(where product_id is null) as null_product_id,
count(*) filter(where quantity is null) as null_quantity,
count(*) filter(where unit_price is null) as null_unit_price,
count(*) filter(where discount is null) as null_discount,
count(*) filter(where total is null) as null_total
from iphone_indonesia_market.transaction_details;


-- cek null transactions
select count(*) as total_row,
count(*) filter(where transaction_id is null) as null_transaction_id,
count(*) filter(where customer_id is null) as null_customer_id,
count(*) filter(where transaction_date is null) as null_transaction_date,
count(*) filter(where total_amount is null) as null_total_amount,
count(*) filter(where payment_method is null) as null_payment_method,
count(*) filter(where shipping_method is null) as null_shipping_method,
count(*) filter(where delivery_time is null) as null_delivery_time,
count(*) filter(where coupon_code is null) as null_coupon_code,
count(*) filter(where city is null) as null_city,
count(*) filter(where product_id is null) as null_product_id,
count(*) filter(where sales_factor is null) as null_sales_factor
from iphone_indonesia_market.transactions;


-- cek duplicate tabel customers
select 
customer_id, 
name, 
email, 
address,
phone_number,
age,
city,
preferred_product_id,
count(*) as jumlah
from customers
group by
customer_id, 
name, 
email, 
address,
phone_number,
age,
city,
preferred_product_id
having count(*) > 1; 


--cek duplicate table products
select 
product_id,
product_name,
category,
brand,
price,
description,
discount,
storage,
color,
release_year,
years_since_release,
sales_factor,
preferred_product_id,
count(*) as jumlah
from products
group by 
product_id,
product_name,
category,
brand,
price,
description,
discount,
storage,
color,
release_year,
years_since_release,
sales_factor,
preferred_product_id
having count(*) > 1;


-- cek duplicate table products
select 
product_id,
product_name,
category,
brand,
price,
description,
discount,
storage,
color,
release_year,
years_since_release,
sales_factor,
preferred_product_id,
count(*) as jumlah
from products 
group by 
product_id,
product_name,
category,
brand,
price,
description,
discount,
storage,
color,
release_year,
years_since_release,
sales_factor,
preferred_product_id
having count(*)>1;

--cek duplicate table transaction_details (ADA DUPLICATE)
select*from transaction_details;
select 
transaction_id,
product_id,
quantity,
unit_price,
discount,
total,
count(*) as jumlah
from transaction_details
group by 
transaction_id,
product_id,
quantity,
unit_price,
discount,
total
having count(*)>1;

--hapus duplicate di transaction_details dengan buat table baru
create table transaction_details_clean as
select distinct*
from transaction_details;

--hapus table transaction_details karena ada duplicate
drop table transaction_details;

--ubah kembali nama transaction_details_clean menjadi transaction_details
alter table transaction_details_clean 
rename to transaction_details;

--cek duplicate table transactions
select 
transaction_id,
customer_id,
transaction_date,
total_amount,
payment_method,
shipping_method,
delivery_time,
coupon_code,
city,
product_id,
sales_factor,
count(*) as jumlah
from transactions
group by
transaction_id,
customer_id,
transaction_date,
total_amount,
payment_method,
shipping_method,
delivery_time,
coupon_code,
city,
product_id,
sales_factor
having count(*)>1;

--outlier customers tidak ada, penjelasan ada di note

--outlier products tidak ada, penjelasan ada di note

--outlier transaction_details
select * from transaction_details;
select max(quantity)
from transaction_details;

select max(unit_price)
from transaction_details;

select total 
from transaction_details 
where not 
--dimana bukan (quantity x unit_price x discount)/100
SELECT 
    quantity,
    unit_price,
    discount,
    total,
    (quantity * unit_price) - ((quantity * unit_price * discount) / 100.0) AS seharusnya,
    total - ((quantity * unit_price) - ((quantity * unit_price * discount) / 100.0)) AS selisih
FROM transaction_details
WHERE total <> (quantity * unit_price) - ((quantity * unit_price * discount) / 100.0);

--outlier table transaction tidak ada

--cek typo table customers dengan cara membuat group setiap isi kolom city
SELECT city, COUNT(*) AS jumlah
FROM customers
GROUP BY city
ORDER BY jumlah ASC;
-- hasilnya tidak ada typo kota


--cek typo table products
-- kolom products_id
SELECT product_id, COUNT(*) AS jumlah
FROM products 
GROUP BY product_id 
ORDER BY jumlah ASC;

-- kolom products_name
SELECT product_name, COUNT(*) AS jumlah
FROM products 
GROUP BY product_name 
ORDER BY jumlah ASC;


--cek typo table transaction_details tidak ada


--cek typo table transactions kolom city
SELECT city, COUNT(*) AS jumlah
FROM transactions  
GROUP BY city  
ORDER BY jumlah ASC;


--wrong data type table customers
--check:
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'customers';

-- ubah type data
-- Age jadi integer
ALTER TABLE customers 
ALTER COLUMN age TYPE integer 
USING age::integer;

-- Preferred product id jadi integer
ALTER TABLE customers 
ALTER COLUMN preferred_product_id TYPE integer 
USING preferred_product_id::integer;

--wrong data type table products
--check:
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'products';

-- 1. product_id → integer
ALTER TABLE products 
ALTER COLUMN product_id TYPE INT 
USING product_id::INT;

-- 2. category → varchar(50)
ALTER TABLE products 
ALTER COLUMN category TYPE VARCHAR(50);

-- 3. brand → varchar(50)
ALTER TABLE products 
ALTER COLUMN brand TYPE VARCHAR(50);

-- 4. price → numeric(10,2)
ALTER TABLE products 
ALTER COLUMN price TYPE NUMERIC(10,2);

-- 5. description → text
ALTER TABLE products 
ALTER COLUMN description TYPE TEXT;

-- 6. discount → numeric(5,2)
ALTER TABLE products 
ALTER COLUMN discount TYPE NUMERIC(5,2);

-- 7. storage → varchar(20)
ALTER TABLE products 
ALTER COLUMN storage TYPE VARCHAR(20);

-- 8. color → varchar(30)
ALTER TABLE products 
ALTER COLUMN color TYPE VARCHAR(30);

-- 9. preferred_product_id → integer
ALTER TABLE products 
ALTER COLUMN preferred_product_id TYPE INT 
USING preferred_product_id::INT;

-- 10. Drop kolom redundant years_since_release
ALTER TABLE products DROP COLUMN years_since_release;


--cek wrong data type table transaction_details
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'transaction_details';
-- 1. product_id → INT (biar bisa join dengan products.product_id)
ALTER TABLE transaction_details 
ALTER COLUMN product_id TYPE INT 
USING product_id::INT;

-- 2. unit_price → numeric(10,2)
ALTER TABLE transaction_details 
ALTER COLUMN unit_price TYPE NUMERIC(10,2);

-- 3. discount → numeric(10,2)
ALTER TABLE transaction_details 
ALTER COLUMN discount TYPE NUMERIC(10,2);

-- 4. total → numeric(12,2)
ALTER TABLE transaction_details 
ALTER COLUMN total TYPE NUMERIC(12,2);

--cek wrong data type table transactions
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'transactions';
-- total_amount jadi NUMERIC(12,2)
UPDATE transactions
SET delivery_time = regexp_replace(delivery_time, '[^0-9]', '', 'g')
WHERE delivery_time ~ '[^0-9]';

ALTER TABLE transactions 
ALTER COLUMN total_amount TYPE NUMERIC(12,2);

-- delivery_time jadi INTEGER 
ALTER TABLE transactions 
ALTER COLUMN delivery_time TYPE INTEGER 
USING delivery_time::INTEGER;

-- product_id jadi INT biar konsisten dengan tabel products
ALTER TABLE transactions 
ALTER COLUMN product_id TYPE INT 
USING product_id::INT;

--irrelevant data (hapus kolom yg tidak dipakai)
-- 1. table customers
ALTER TABLE customers 
DROP COLUMN address,
DROP COLUMN email,
drop column phone_number,
drop column preferred_product_id;
--2. table products
ALTER TABLE products 
DROP COLUMN category,
DROP COLUMN brand,
drop column description,
drop column color,
drop column sales_factor,
drop column preferred_product_id;
--3. table transaction_details tidak ada
--4. table transactions
ALTER TABLE transactions
drop column coupon_code,
drop column delivery_time,
drop column sales_factor;

--Primary Key Uniqueness Pastikan transaction_id, customer_id, product_id nggak ada duplikat.
SELECT transaction_id, COUNT(*)
FROM transactions
GROUP BY transaction_id
HAVING COUNT(*) > 1;

-- Foreign Key Consistency cari transaksi dengan customer_id yang tidak ada di customers
SELECT t.transaction_id, t.customer_id
FROM transactions t
LEFT JOIN customers c ON t.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

--Referential Integrity antar tabel
SELECT td.transaction_id
FROM transaction_details td
LEFT JOIN transactions t ON td.transaction_id = t.transaction_id
WHERE t.transaction_id IS NULL;

--Business Rule Validation age di customers harus > 0 dan wajar (misalnya < 120). price di products tidak boleh negatif. discount antara 0–100.
SELECT * FROM products WHERE price < 0;
SELECT * FROM customers WHERE age <= 0 OR age > 120;
SELECT * FROM transaction_details WHERE discount < 0 OR discount > 100;

--1. table transaction_details: product_id, quantity, 
--2. transactions: city, payment_method, transaction_date, product_id
SELECT 
    td.product_id,
    td.quantity,
    t.city,
    t.payment_method,
    t.transaction_date
FROM transaction_details td
INNER JOIN transactions t 
    ON td.product_id = t.product_id;

--join 2 tabel dan kolom yg dibutuhkan
CREATE TABLE joined_transactions AS
SELECT 
    td.product_id,
    td.quantity,
    t.city,
    t.payment_method,
    t.transaction_date
FROM transaction_details td
INNER JOIN transactions t 
    ON td.product_id = t.product_id;

--1. total unit terjual
SELECT SUM(td.quantity) AS total_unit_terjual
FROM transaction_details td
INNER JOIN products p 
    ON td.product_id = p.product_id
WHERE p.product_name ILIKE 'iPhone%';

--2. penjualan permodel
WITH per_model AS (
    SELECT 
        p.product_name AS model_iphone,
        SUM(td.quantity) AS total_unit_terjual
    FROM transaction_details td
    INNER JOIN products p ON td.product_id = p.product_id
    WHERE p.product_name ILIKE 'iPhone%'
    GROUP BY p.product_name
)
SELECT model_iphone, total_unit_terjual
FROM per_model

UNION ALL

SELECT 'TOTAL', SUM(total_unit_terjual)
FROM per_model

ORDER BY total_unit_terjual DESC NULLS LAST;


--3. penjualan perkota
SELECT t.city, SUM(td.quantity) AS total_unit_terjual
FROM transaction_details td
INNER JOIN transactions t
    ON td.transaction_id = t.transaction_id
GROUP BY t.city

UNION ALL

SELECT 'TOTAL', SUM(td.quantity)
FROM transaction_details td
INNER JOIN transactions t
    ON td.transaction_id = t.transaction_id

ORDER BY total_unit_terjual DESC;

--4. Tren Penjualan per Bulan
SELECT
    COALESCE(TO_CHAR(DATE_TRUNC('month', t.transaction_date), 'YYYY-MM'), 'TOTAL') AS bulan,
    SUM(td.quantity) AS total_unit_terjual
FROM transaction_details td
INNER JOIN transactions t
    ON td.transaction_id = t.transaction_id
GROUP BY ROLLUP(DATE_TRUNC('month', t.transaction_date))
ORDER BY 
    CASE WHEN DATE_TRUNC('month', t.transaction_date) IS NULL THEN 2 ELSE 1 END,
    bulan;

--5 Model Terlaris di Tiap Kota
WITH ranked AS (
    SELECT 
        t.city,
        p.product_name AS model_iphone,
        SUM(td.quantity) AS total_unit_terjual,
        RANK() OVER (PARTITION BY t.city ORDER BY SUM(td.quantity) DESC) AS rnk
    FROM transaction_details td
    INNER JOIN transactions t ON td.transaction_id = t.transaction_id
    INNER JOIN products p ON td.product_id = p.product_id
    GROUP BY t.city, p.product_name
)
SELECT city, model_iphone, total_unit_terjual
FROM ranked
WHERE rnk = 1

UNION ALL

-- Baris total seluruh kota
SELECT 'TOTAL', NULL, SUM(total_unit_terjual)
FROM ranked;


--7. Market Share per Model
WITH per_model AS (
    SELECT
        p.product_name AS model_iphone,
        SUM(td.quantity) AS total_unit_terjual,
        ROUND(SUM(td.quantity) * 100.0 / SUM(SUM(td.quantity)) OVER (), 2) AS persentase_market_share
    FROM transaction_details td
    INNER JOIN products p ON td.product_id = p.product_id
    GROUP BY p.product_name
)
SELECT model_iphone, total_unit_terjual, persentase_market_share
FROM per_model

UNION ALL

SELECT 'TOTAL', SUM(total_unit_terjual), 100.0
FROM per_model

ORDER BY total_unit_terjual DESC NULLS LAST;
















































