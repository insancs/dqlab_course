-- Memahami table
SELECT * FROM orders_1 limit 5;
SELECT * FROM orders_2 limit 5;
SELECT * FROM customer limit 5;

-- Total Penjualan dan Revenue pada Quarter-1 (Jan, Feb, Mar) dan Quarter-2 (Apr,Mei,Jun)
SELECT 
    SUM(quantity) as total_penjualan, 
    SUM(quantity * priceeach) as revenue 
FROM 
    orders_1 
WHERE status = 'Shipped';

SELECT 
    SUM(quantity) as total_penjualan, 
    SUM(quantity * priceeach) as revenue 
FROM 
    orders_2 
WHERE status = 'Shipped';

-- Menghitung persentasi keseluruhan penjualan
SELECT 
    quarter, 
    SUM(quantity) AS total_penjualan, 
    SUM(quantity * priceeach) AS revenue 
FROM 
    (SELECT 
        orderNumber, 
        status, 
        quantity, 
        priceeach, '1' as quarter 
    FROM 
        orders_1 
    UNION 
    SELECT 
        orderNumber, 
        status,
        quantity,
        priceeach, '2' as quarter 
    FROM 
        orders_2) AS tabel_a 
    WHERE 
        status='Shipped'
    GROUP BY 
        quarter;

-- Perhitungan Growth Penjualan dan Revenue
-- %Growth Penjualan = (6717 – 8694)/8694 = -22%
-- %Growth Revenue = (607548320 – 799579310)/ 799579310 = -24%

-- Apakah jumlah customers xyz.com semakin bertambah?
SELECT 
    quarter, 
    COUNT(DISTINCT customerID) AS total_customers
FROM 
    (SELECT 
        customerID,
        createDate, 
        QUARTER(CreateDate) AS quarter
    FROM 
        customer
    WHERE 
        createDate BETWEEN "2004-01-01" AND "2004-06-30") AS tabel_b 
GROUP by 
    quarter; 

-- Seberapa banyak customers tersebut yang sudah melakukan transaksi?
SELECT
    quarter,
    COUNT(DISTINCT customerID) AS total_customers 
FROM 
    (SELECT
        customerID,
        createDate,
        QUARTER(CreateDate) AS quarter 
    FROM
        customer
    WHERE 
        createDate BETWEEN "2004-01-01" AND "2004-06-30") AS tabel_b 
WHERE 
    customerID IN(
        SELECT 
            DISTINCT customerID 
        FROM 
            orders_1 
        UNION
        SELECT 
            DISTINCT customerID 
        FROM orders_2) 
GROUP by quarter; 

-- Category produk apa saja yang paling banyak di-order oleh customers di Quarter-2?
SELECT * 
FROM (
    SELECT
        categoryID, 
        COUNT(DISTINCT orderNumber) AS total_order, 
        SUM(quantity) AS total_penjualan
    FROM (
        SELECT 
            productCode, 
            orderNumber, 
            quantity, 
            status, 
            LEFT(productCode, 3) AS categoryID 
        FROM
            orders_2 
        WHERE 
            status = "Shipped") tabel_c 
    GROUP BY 
        categoryID) categotyid 
ORDER BY 
    total_order DESC;

-- Seberapa banyak customers yang tetap aktif bertransaksi setelah transaksi pertamanya?
-- Menghitung total unik customers yang transaksi di quarter_1, output = 25
SELECT 
    COUNT(DISTINCT customerID) as total_customers 
FROM 
    orders_1;


SELECT
	'1' as quarter,
	(COUNT(DISTINCT customerid)/25)*100 as q2
FROM
	orders_1
WHERE 
    customerid IN(
        SELECT DISTINCT 
            customerid
        FROM
                orders_2) 
