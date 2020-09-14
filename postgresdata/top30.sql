select count(rental_id) as cnt, c.customer_id from rental r 
join customer c on r.customer_id = c.customer_id group by c.customer_id having count(rental_id) > 30;

select * from city;
select * from address;

--who are the top three customers in terms of most rentals?
select * from (
	select 
		count(r.rental_id), 
		c.customer_id, 
		c.first_name,
		c.last_name, 
		dense_rank() over (order by count(r.rental_id) desc) as rank 
			from rental r 
				join customer c on r.customer_id = c.customer_id 
		group by c.customer_id) x 
	where x.rank <= 3;
		
	
--which coutnries have the most addresses. Top 3.
select * from (select country, count(*), dense_rank()over(order by count(*) desc) as rank from country join 
	(select * from address a join 
		city c on a.city_id=c.city_id) ca on country.country_id = ca.country_id group by ca.country_id, country) t where t.rank < 4;
	
--who are the top three customers in terms of most rentals per country?
select * from rental;

select cty.country_id, t3.*, dense_rank() over(partition by cty.country_id order by t3.rentals desc) from city cty join
	(select a.city_id, t2.*  from address a join
		(select t.first_name, t.last_name, c.address_id, t.rentals from customer c
		join
			(select 
				count(r.rental_id) as rentals, 
				c.customer_id, 
				c.first_name,
				c.last_name
					from rental r 
						join customer c on r.customer_id = c.customer_id 
				group by c.customer_id) t on c.customer_id = t.customer_id) t2
		on a.address_id = t2.address_id) t3
	on cty.city_id = t3.city_id
	
dense_rank() over(partition by a.city_id order by t2.rentals desc)

-- rank customers by rental times.
select *, dense_rank() over(order by t.time_out desc) as rank 
from (select *, return_date - rental_date as time_out from rental) t  
where t.time_out is not null

-- Overdue rental. Greater than 3 days
select customer_id, rental_date, return_date - rental_date as time_out,
CASE
    WHEN extract(epoch from return_date - rental_date)/3600/24 > 3 THEN 'OVERDUE'
    WHEN extract(epoch from return_date - rental_date)/3600/24 <=  3 THEN 'OK'
    ELSE 'The quantity is under 30'
END AS Overdue
from rental where return_date is not null;


-- get each customers last and next to last rental
select customer_id, rental_date, rank() over(partition by r.customer_id order by r.rental_date desc) as rank from rental r order by r.customer_id 


