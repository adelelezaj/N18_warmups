-- Return to Window Functions!
-- BASIC SYNTAX
-- SELECT <aggregator> OVER(PARTITION BY <col1> ORDER BY <col2>)
-- PARTITION BY (like GROUP BY) a column to do the aggregation within particular category in <col1>
-- Choose what order to apply the aggregator over (if it's a type of RANK)
-- Example SELECT SUM(sales) OVER(PARTITION BY department)
-- Feel free to google RANK examples too.


-- Return a list of all customers, RANKED in order from highest to lowest total spendings
-- WITHIN the country they live in.
-- HINT: find a way to join the order_details, products, and customers tables
-- Return the same list as before, but with only the top 3 customers in each country.

 WITH customer_order AS (
     SELECT (od.unit_price* od.quantity) AS total, count(o.order_id) AS count_order, 
     discount, c.customer_id, country
     FROM order_details AS od JOIN orders AS o ON od.order_id = o.order_id
     JOIN customers AS c ON o.customer_id = c.customer_id
    GROUP BY 1,3,4
 ),
 detailed_customers_spendings as (
     SELECT customer_id, (total*count_order) AS total_spending, (total*count_order* discount) AS discount_details,
     country
     FROM customer_order 
     GROUP BY customer_id, 2,3,4
     ORDER BY total_spending DESC
 ),
 payment AS (
 SELECT customer_id, (total_spending - discount_details) AS customer_payments, country
 FROM detailed_customers_spendings
 GROUP BY 1,2,3
 ORDER BY 2 DESC
 ),
 top_customers as (
 SELECT customer_id, customer_payments, country, RANK () OVER(
     PARTITION BY country ORDER BY customer_payments DESC
 ) price_rank
FROM payment
 )
SELECT * FROM top_customers where price_rank <=3;


