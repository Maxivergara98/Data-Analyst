SELECT * FROM pizza_sales;

#TOTAL REVENUE
SELECT ROUND(SUM(total_price),0) as `Total Price`
FROM pizza_sales;

#AVERAGE PRICE PER ORDER
SELECT ROUND(SUM(Total_price)/COUNT(DISTINCT order_id),2) Average_cost_Per_order
FROM pizza_sales;

#TOTAL PIZZAS SOLD
SELECT SUM(quantity) as Total_amount_Pizzas 
FROM pizza_sales;

#TOTAL AMOUNT OF ORDERS
SELECT count(distinct order_id) `Total Orders Places`
FROM pizza_sales;

#AVERAGE PIZZAS PER ORDER
SELECT ROUND(SUM(quantity)/COUNT(DISTINCT order_id),2) as `avg pizzas per order`
FROM pizza_sales;

#DAILY TRREND OF TOTAL ORDERS - TENEMOS QUE CAMBIAR EL ORDER_DATE A FORMATO DATE PRIMERO
#creamos columna temporal tipo date
ALTER TABLE pizza_sales
ADD COLUMN Order_dates DATE AFTER order_date;

UPDATE pizza_sales
SET Order_dates = str_to_date(order_date, '%d-%m-%Y');

ALTER TABLE pizza_sales
DROP COLUMN order_date;

#ORDENES POR DIA DE SEMANA
SELECT DAYNAME(order_dates) DAY,
COUNT(DISTINCT ORDER_ID) AS TOTAL_ORDERS
FROM pizza_sales
GROUP BY DAYNAME(order_dates);

#ORDENES POR HORA
ALTER TABLE pizza_sales
MODIFY COLUMN order_time TIME;

SELECT HOUR(order_time) as HORA,
COUNT(DISTINCT order_id) as Total_orders
FROM pizza_sales
GROUP BY HOUR(order_time)
ORDER BY HORA;

#porcentage the ventas por categoria 
SELECT pizza_category, ROUND(sum(total_price) / (SELECT SUM(Total_price) FROM pizza_sales) * 100,2) AS `% SALES`
FROM pizza_sales
GROUP BY pizza_category;

#% VENTAS POR SIZE DE PIZZA.
SELECT pizza_size, ROUND(SUM(total_price) / (SELECT sum(total_price) FROM pizza_sales) * 100,2) PERCENTAGE
FROM pizza_sales
GROUP BY pizza_size
ORDER BY PERCENTAGE DESC;
 
 
# TOTAL PIZZAS VENDIDAS POR CATEGOIRA
SELECT pizza_category, SUM(quantity) as Pizzas_Totales
FROM pizza_sales
GROUP BY pizza_category;

#mejores 5 pizzas vendidas
SELECT pizza_name, SUM(quantity) as Pizzas_Totales
FROM pizza_sales
GROUP BY pizza_name
ORDER BY pizzas_totales desc
LIMIT 5;

SELECT pizza_name, SUM(quantity) as Pizzas_Totales
FROM pizza_sales
GROUP BY pizza_name
ORDER BY pizzas_totales 
LIMIT 5;