
 -- Q1: What is the total revenue and total profit ? 

SELECT 
row_number()over() as ``,
    FORMAT(SUM(Productcost), 2, 'en_IN') AS "Total Product Cost (INR)",
    FORMAT(SUM(SalesAmount), 2, 'en_IN') AS "Total Sales (INR)",
    FORMAT(SUM(Profit), 2, 'en_IN') AS "Total Profit (INR)"
FROM sales;

-- Q2: Which month of the year has the highest sales volume? 

select
 month,  FORMAT(SUM(SalesAmount), 2, 'en_IN') AS "Total Sales (INR)"
from sales
group by month
order by sum(salesAmount) desc
limit 1;

-- Q3: Which 5 products are the best-sellers based on Units Sold? 

SELECT 
    ROW_NUMBER() OVER (ORDER BY SUM(SalesAmount) ASC) AS ``,
    Product,
    FORMAT(SUM(SalesAmount), 2, 'en_IN') AS "Total Sales (INR)"
FROM sales
GROUP BY Product
ORDER BY SUM(SalesAmount) asc
LIMIT 5;

-- Q4: Which Category contributes the most to the total Profit? 

select
row_number()over(order by sum(profit) desc ) as ``, 
 category, FORMAT(SUM(Profit), 2, 'en_IN') AS "Total Profit (INR)"
from sales
group by category
order by sum(profit) desc
limit 3;

-- Q5: Are there any products with a negative profit (Loss)? 

SELECT 
    Product, 
    Category,
    SUM(UnitsSold) AS "Total Units Sold at Loss",
    FORMAT(SUM(Profit), 2, 'en_IN') AS "Total Loss Amount (INR)"
FROM sales
WHERE Profit < 0
GROUP BY Product, Category
HAVING COUNT(*) > 0
ORDER BY SUM(Profit) ASC;

-- Q6: What are the top 2 States by Sales Amount in each Region? 

SELECT 
    ROW_NUMBER() OVER (ORDER BY Region, total_sales DESC) AS ``,
    ranking,
    Region,
    State,
    FORMAT(total_sales, 2, 'en_IN') AS `Sales Amount (INR)`
FROM (
    SELECT 
        Region, 
        State, 
        SUM(SalesAmount) AS total_sales,
        ROW_NUMBER() OVER (
            PARTITION BY Region 
            ORDER BY SUM(SalesAmount) DESC
        ) AS ranking
    FROM sales
    GROUP BY Region, State
) AS ranked_data
WHERE ranking <= 2
ORDER BY Region, total_sales DESC;

-- Q7: Which Region has the highest average Profit Percentage?

select 
    Region ,
     format(avg(`profit(%)`),2,'en_IN') as "Avg Profit(%) "
from sales
group by Region
order by  avg(`profit(%)`) desc
limit 1;

-- Q8: What is the average UnitPrice vs. average UnitCost for each Category? 

SELECT 
row_number() over() as ``,
    Category, 
    format(AVG(UnitPrice), 2) AS "Avg Selling Price", 
    format(AVG(UnitCost), 2) AS "Avg Production Cost",
    format(AVG(UnitPrice - UnitCost), 2) AS "Avg Markup (Profit per Unit)"
FROM sales
GROUP BY Category
ORDER BY "Avg Markup (Profit per Unit)" DESC;

-- Q9: Who are the top 10 customers based on their total spending? 

SELECT 
    ROW_NUMBER() OVER (ORDER BY SUM(SalesAmount) DESC) AS ``,
    CustomerName, 
    COUNT(OrderID) AS "Total Orders",
    FORMAT(SUM(SalesAmount), 2, 'en_IN') AS "Total Spending (INR)"
FROM sales
GROUP BY CustomerName
ORDER BY SUM(SalesAmount) DESC
LIMIT 10;

-- Q10: Does high SalesAmount always mean high Profit? (Compare top 10 orders by Sales vs. Profit). 

SELECT 
row_number() over()  as ``,
    OrderID, 
    Product, 
    Category,
    FORMAT(SalesAmount, 2, 'en_IN') AS "Sales Amount", 
    FORMAT(Profit, 2, 'en_IN') AS "Profit Amount",
    `Profit(%)`
FROM sales
ORDER BY SalesAmount DESC
LIMIT 10;





