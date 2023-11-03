-- 1: find total business done by each store
use sakila;
select t.store_id, sum(p.amount) as total_sales
from rental r
join payment p on r.rental_id = p.rental_id
join staff s on r.staff_id = s.staff_id
join store t on s.store_id = t.store_id
group by t.store_id;

-- 2: createstored procedure to find total sales for all stores
delimiter //
create procedure calculate_total_sales_per_store()
begin
    select t.store_id, sum(p.amount) as total_sales
    from rental r
    join payment p on r.rental_id = p.rental_id
    join staff s on r.staff_id = s.staff_id
    join store t on s.store_id = t.store_id
    group by t.store_id;
end //
delimiter ;

call calculate_total_sales_per_store();

-- 3: create stored procedure to find total sales forspecific store
delimiter //
create procedure get_total_sales_for_store(in store_id int, out total_sales_value float)
begin
    select sum(p.amount) into total_sales_value
    from rental r
    join payment p on r.rental_id = p.rental_id
    join staff s on r.staff_id = s.staff_id
    join store t on s.store_id = t.store_id
    where t.store_id = store_id;
end //
delimiter ;

call get_total_sales_for_store(2, @total_sales_value);
select @total_sales_value as total_sales;

-- 4: create stored procedure to find total sales and set flag for a specific store
delimiter //
create procedure get_total_sales_and_flag_for_store(in store_id int, out total_sales_value float, out flag varchar(20))
begin
    select sum(p.amount) into total_sales_value
    from rental r
    join payment p on r.rental_id = p.rental_id
    join staff s on r.staff_id = s.staff_id
    join store t on s.store_id = t.store_id
    where t.store_id = store_id;
    
    if total_sales_value > 30000 then
        set flag = 'green_flag';
    else
        set flag = 'red_flag';
    end if;
end //
delimiter ;
