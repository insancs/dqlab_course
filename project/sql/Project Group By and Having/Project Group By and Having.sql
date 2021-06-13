-- Carilah customer-customer id dan jumlah pinalty dari yang dibayarkan oleh customer yang mendapatkan pinalty.
SELECT 
    t1.customer_id, 
    SUM(pinalty)
FROM 
    invoice AS t1
INNER JOIN 
    payment AS t2
ON 
    t1.invoice_id = t2.invoice_id
WHERE 
    t1.pinalty IS NOT NULL
GROUP BY 
    t1.customer_id;

-- Mencari customer yang mengganti layanan
SELECT 
    t1.name, 
    GROUP_CONCAT(t3.product_name)
FROM 
    customer AS t1
INNER JOIN 
    subscription AS t2
ON 
    t1.id = t2.customer_id
INNER JOIN 
    product t3
ON 
    t2.product_id = t3.id
WHERE 
    t2.customer_id IN (
        SELECT 
            customer_id
        FROM 
            subscription
        GROUP BY 
            customer_id
        HAVING 
            COUNT(customer_id) > 1)
GROUP BY 
    t1.name;