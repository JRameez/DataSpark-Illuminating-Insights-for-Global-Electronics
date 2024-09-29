SELECT * FROM global.customer;

# CUSTOMER ANALYSIS

SELECT Gender, COUNT(*) AS Count_gender
FROM customer
GROUP BY Gender;



-- country wise customer count
SELECT 
    Continent_customer,Country_customer,State_customer,City_customer, 
    COUNT(CustomerKey) AS customer_count
FROM 
    CUSTOMER
GROUP BY 
    Continent_customer,Country_customer,State_customer,City_customer
ORDER BY 
    customer_count DESC
    

# PRODUCT ANALYSIS

-- Catagory and sub catagory analysis

SELECT Category, Subcategory,
ROUND(SUM(p.UnitPriceUSD * s.Quantity),2) AS total_sales
FROM product as p 
INNER JOIN sales as s
on p.ProductKey = s.ProductKey
GROUP BY Category,Subcategory
ORDER BY total_sales DESC;

-- Product Popularity: Identify the most and least popular products based on sales data.

select distinct(ProductName),sum(s.Quantity) as Quantity
from product as p 
inner join
sales as s
on p.ProductKey = s.ProductKey
group by ProductName
order by Quantity desc
limit 10

select distinct(ProductName),sum(s.Quantity) as Quantity
from product as p
inner join
sales as s
on p.ProductKey = s.ProductKey
group by ProductName
order by Quantity 
limit 20


-- Profitability Analysis: Calculate profit margins for products by comparing unit cost and unit price.

Select
ProductName,
ROUND(Sum((UnitPriceUSD - UnitCostUSD) * s.Quantity),2) as Profit_Margin
from product as p
inner join
sales as s
on p.ProductKey = s.ProductKey
group by ProductName
order by Profit_Margin desc
limit 10

# SALES ANALYSIS

SELECT
  MONTHNAME(s.OrderDate) AS Month_Order,
  ROUND(SUM((p.UnitPriceUSD) * s.Quantity),2) AS Total_Revenue_USD
FROM
  sales as s 
  inner join
  product as p
  on s.ProductKey = p.ProductKey
GROUP BY
  MONTHNAME(s.OrderDate);
  
  
-- sales by revenue performance

SELECT
  ProductName,
  ROUND(SUM((UnitPriceUSD) * Quantity),2) AS Total_Revenue_USD
FROM
  sales as s
  inner join 
  product as p
  on s.ProductKey = p.ProductKey
GROUP BY
  ProductName
order by Total_Revenue_USD desc limit 10 


-- sales by stores
SELECT
  st.StoreKey,
  ROUND(SUM((p.UnitPriceUSD)*s.Quantity),2) AS total_revenue_USD
FROM
  sales as s 
  inner join
  product as p
  inner join
  stores as st
  on s.ProductKey = p.ProductKey and
  s.StoreKey = st.StoreKey
GROUP BY
  st.StoreKey
order by total_revenue_USD desc

# STORE ANALYSIS

-- store_age_bucket vs total sales    

SELECT
    CASE
        WHEN StoreAge <= 5 THEN '<=5'
        WHEN StoreAge BETWEEN 6 AND  10 THEN '5 to 10'
        WHEN StoreAge BETWEEN 11 AND 15 THEN '10 to 15'
        WHEN StoreAge BETWEEN 16 AND 20 THEN '15 to 20'
    END AS store_age_bucket,
    ROUND(SUM(p.UnitPriceUSD * s.Quantity), 2) AS Total_Sales
FROM stores as st
inner join
sales as s
inner join
product as p
on st.StoreKey = s.StoreKey and s.ProductKey = p.ProductKey
GROUP BY store_age_bucket
ORDER BY Total_Sales

-- Details of customer purchased product from the stores with total revenue
SELECT
  st.StoreKey,c.Name,c.Gender,c.Country_customer,c.Continent_customer,c.State_customer,p.ProductName,s.LineItem,s.Quantity,
  ROUND(SUM((p.UnitPriceUSD)*s.Quantity),2) AS total_revenue_USD
FROM
  customer as c 
  inner join
  stores as st
  inner join
  sales as s
  inner join
  product as p
  on c.CustomerKey = s.CustomerKey and st.StoreKey = s.StoreKey and p.ProductKey = s.ProductKey
GROUP BY
 StoreKey,c.Name,c.Gender,Country_customer,Continent_customer,State_customer,p.ProductName,s.LineItem,s.Quantity
order by total_revenue_USD desc


-- size bucket vs total_sales
SELECT
    CASE
        WHEN SquareMeters < 250 THEN '<250'
        WHEN SquareMeters BETWEEN 250 AND 500 THEN '250 to 500'
        WHEN SquareMeters BETWEEN 501 AND 750 THEN '500 to 750'
        WHEN SquareMeters BETWEEN 751 AND 1000 THEN '750 to 1000'
        WHEN SquareMeters BETWEEN 1001 AND 1250 THEN '1000 to 1250'
        WHEN SquareMeters BETWEEN 1251 AND 1500 THEN '1250 to 1500'
        WHEN SquareMeters BETWEEN 1501 AND 1750 THEN '1500 to 1750'
        WHEN SquareMeters BETWEEN 1751 AND 2000 THEN '1750 to 2000'
        WHEN SquareMeters > 2000 THEN '> 2000'
    END AS Storesize_bucket,
    ROUND(SUM(p.UnitPriceUSD * s.Quantity),2) AS total_sales
FROM stores as st
inner join
sales as s
inner join
product as p
on st.Storekey = s.StoreKey and p.ProductKey = s.ProductKey
GROUP BY Storesize_bucket
ORDER BY
    CASE
        WHEN Storesize_bucket = '<250' THEN 1
        WHEN Storesize_bucket = '250 to 500' THEN 2
        WHEN Storesize_bucket = '500 to 750' THEN 3
        WHEN Storesize_bucket = '750 to 1000' THEN 4
        WHEN Storesize_bucket = '1000 to 1250' THEN 5
        WHEN Storesize_bucket = '1250 to 1500' THEN 6
        WHEN Storesize_bucket = '1500 to 1750' THEN 7
        WHEN Storesize_bucket = '1750 to 2000' THEN 8
        WHEN Storesize_bucket = '> 2000' THEN 9
    END;
    
