-- Total sales ( grand_total) for each year , ordered from newest to oldest
SELECT SUM(grand_total) as total_sales , Year
FROM final_project 
GROUP BY Year
ORDER BY Year DESC;

--AVG discount amount for each payment method , only for methods > 100 transactions
SELECT AVG(discount_amount) as avg_discount_amount ,
		payment_method,
		COUNT(*) as num_transaction
FROM final_project
GROUP BY payment_method
HAVING COUNT(*) > 100
ORDER BY avg_discount_amount DESC;

-- TOP 5 categories by total qty ordered
SELECT TOP 5 
category_name_1 , SUM(qty_ordered) as total_quantity
FROM final_project
GROUP BY category_name_1
ORDER BY total_quantity DESC;

--Retrive all orders where the grand_total > avg grand total of all orders
SELECT increment_id ,grand_total 
FROM final_project
WHERE grand_total > (SELECT AVG(grand_total) FROM project_dataset)

-- first order and last order for each Customer
SELECT Customer_ID ,
	MIN(created_at) as firsr_order_date,
	MAX(created_at) as last_order_date
FROM final_project
GROUP BY Customer_ID

-- use window func to assign a RANK based on grand total within each category name
SELECT 
    category_name_1,
    grand_total,
    RANK() OVER (
        PARTITION BY category_name_1
        ORDER BY grand_total DESC
    ) AS rank_within_category
FROM final_project
ORDER BY category_name_1, rank_within_category;

-- Monthly total sales for 2017 only , grouped by M-Y
SELECT SUM(grand_total) as total_sales , M_Y FROM final_project
WHERE Year=2017
GROUP BY M_Y

-- increment_id , grand_total with discount > avg discount
SELECT increment_id , grand_total
FROM final_project
WHERE discount_amount > ( SELECT AVG(discount_amount) FROM project_dataset)

--show customers who joined before 2017 with > 5 orders
SELECT Customer_ID ,Customer_Since, COUNT(increment_ID) as num_of_orders
FROM final_project
WHERE Customer_Since < '2017-01-01'
GROUP BY Customer_ID , Customer_Since
Having COUNT(increment_ID) > 5 

--use DENse rank to rank payment methods by their total sales amount 
SELECT 
    payment_method_grouped,
    SUM(grand_total) AS total_sales,
    DENSE_RANK() OVER (
        ORDER BY SUM(grand_total) DESC
    ) AS rank_by_sales
FROM final_project
GROUP BY payment_method_grouped
ORDER BY rank_by_sales;





