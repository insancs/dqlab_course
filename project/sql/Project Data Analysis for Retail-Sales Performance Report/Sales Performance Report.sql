-- Tampilkan total penjualan (sales) dan jumlah order (number_of_order) dari tahun 2009 sampai 2012 (years).
SELECT 
    LEFT(order_date, 4) years, 
    ROUND(SUM(sales),2) sales, 
    COUNT(order_status) number_of_order 
FROM 
    dqlab_sales_store 
WHERE 
    order_status = 'Order Finished' 
GROUP BY 
    years;

-- Total penjualan (sales) berdasarkan sub category dari produk (product_sub_category) pada tahun 2011 dan 2012 saja (years) 
SELECT 
    YEAR(order_date) AS years, 
    product_sub_category, 
    SUM(sales) AS sales
FROM 
    dqlab_sales_store
WHERE 
    YEAR(order_date) IN ('2011','2012') AND 
    order_status = "Order Finished"
GROUP BY 
    YEAR(order_date), 
    product_sub_category
ORDER BY 
    years, 
    sales DESC;

-- Promotion Effectiveness and Efficiency by Years
-- burn rate = (total discount / total sales) * 100
SELECT 
    YEAR(order_date) AS years, 
    SUM(sales) AS sales, 
    SUM(discount_value) AS promotion_value, 
    ROUND(SUM(discount_value)/SUM(sales) * 100, 2) AS burn_rate_percentage 
FROM 
    dqlab_sales_store 
WHERE 
    order_status = 'Order Finished' 
GROUP BY 
years;

-- Promotion Effectiveness and Efficiency by Product Sub Category
SELECT 
    YEAR(order_date) as years, 
    product_sub_category, 
    product_category, 
    SUM(sales) AS sales, 
    SUM(discount_value) AS promotion_value, 
    ROUND(SUM(discount_value)/SUM(sales) * 100, 2) AS burn_rate_percentage 
FROM 
    dqlab_sales_store 
WHERE 
    order_status = 'Order Finished' AND YEAR(order_date) = '2012' 
GROUP BY 
    years, 
    product_sub_category, 
    product_category 
ORDER BY 
    years, 
    sales DESC;

--  Tampilkan jumlah customer (number_of_customer) yang bertransaksi setiap tahun dari 2009 sampai 2012 (years).
SELECT 
    YEAR(order_date) AS years, 
    COUNT(DISTINCT customer) AS number_of_customer 
FROM 
    dqlab_sales_store 
WHERE 
    order_status = 'Order Finished' 
GROUP BY 
    years;
