
-- Write a query to find what is the total business done by each store.

SELECT store_id, count(amount) AS revenue FROM sakila.payment
JOIN sakila.staff USING (staff_id)
GROUP BY store_id;

-- Convert the previous query into a stored procedure.
delimiter //
create procedure total_revenue ()
begin
	SELECT store_id, count(amount) AS revenue FROM sakila.payment
	JOIN sakila.staff USING (staff_id)
	GROUP BY store_id;
end //
delimiter ;

call total_revenue()

-- 

-- Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.
delimiter //
create procedure revenue_by_store (in s int)
begin
	SELECT store_id, count(amount) AS revenue FROM sakila.payment
	JOIN sakila.staff USING (staff_id)
    WHERE store_id = s
	GROUP BY store_id;
end //
delimiter ;

call revenue_by_store(2)

-- Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store). 
-- Call the stored procedure and print the results.
delimiter //
create procedure revenue_by_store_float (in s int)
begin
  declare total_sales_value float default 0.0;
	SELECT round(revenue,2) into total_sales_value
    FROM(
		SELECT store_id, count(amount) AS revenue FROM sakila.payment
		JOIN sakila.staff USING (staff_id)
		WHERE store_id = s
		GROUP BY store_id
        )sub1
	;
    
select total_sales_value;

end //
delimiter ;

call revenue_by_store_float(2);

-- drop procedure if exists revenue_by_store_float;

-- In the previous query, add another variable flag. If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. 
-- Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.


delimiter //
create procedure revenue_by_store_label (in s int, out param1 varchar(20))
begin
  declare total_sales_value float default 0.0;
  declare label varchar(20) default "";
	SELECT round(revenue,2) into total_sales_value
    FROM(
		SELECT store_id, count(amount) AS revenue FROM sakila.payment
		JOIN sakila.staff USING (staff_id)
		WHERE store_id = s
		GROUP BY store_id
        )sub1
	;
    
select total_sales_value;

  case
    when total_sales_value > 30000 then
      set label = 'green_flag';
  else
    set label = 'red_flag';
  end case;

  select label into param1;
end;
//
delimiter ;

-- drop procedure if exists revenue_by_store_label;

call revenue_by_store_label(2, @x);
select @x;