use sakila;

-- 1a--
select * from actor;

-- 1b--
select concat(upper(first_name),'_',upper(last_name)) as Actor_Name from
actor;

-- 2a--

select actor_id,first_name,last_name from actor
where first_name = "Joe";

-- 2b--
select first_name,last_name from actor
where last_name like "%gen%";

-- 2c--
select first_name,last_name from actor
where last_name like "%li%" order by last_name,first_name;
-- 3a--
alter table actor
add middle_name varchar(50);
select first_name,middle_name,last_name from actor;

-- 3b --
alter table actor
modify middle_name blob;

select * from actor;

-- 3c --
alter table actor
drop middle_name;

select * from actor;

-- 4a --
select last_name, count(*) from actor
group by last_name;

-- 4b --
select last_name,count(*) from actor
group by last_name
having count(last_name)>=2;

select * from actor
where first_name like "harpo";

-- 4c --
update actor
set first_name = "HARPO"
where actor_id = 172;

-- 4d --
update actor
	set first_name = case when first_name = "Harpo" then "Mucho Groucho" end
    where first_name = "Harpo";

select * from actor 
where last_name = "williams";

-- 5a --
select * from address;
-- to create the address table... it does not run as there is one that exists--
Create table address(id INTEGER(11) AUTO_INCREMENT NOT NULL,
 address varchar(50),
 district varchar(10),
 PRIMARY KEY (id)
 );
 
-- 6a --

select * from staff;
select * from address;

select address, first_name,last_name
from address a
join staff c 
on (a.address_id = c.address_id);

-- 6b --
select * from payment;
select * from staff;

select first_name,last_name,sum(amount)
from payment a
join staff c
on (a.staff_id = c.staff_id)
where payment_date like "2005-08%"
group by c.staff_id;


-- 6c --
select * from film_actor;
select * from film;
select title, count(actor_id)
from film t
inner join film_actor a
on t.film_id = a.film_id
group by title;

-- 6d --
select title, count(inventory_id)
from film t
inner join inventory i 
on t.film_id = i.film_id
where title = "Hunchback Impossible";

-- 6e --
select last_name, first_name, sum(amount)
from payment p
inner join customer c
on p.customer_id = c.customer_id
group by p.customer_id
order by last_name ASC;

-- 7a --
select title from film
where language_id in (
	select language_id from language
	where name = "english") And (title like "K%") OR (title like "Q%");
    
-- 7b --
select last_name,first_name from actor
where actor_id in (
	select actor_id from film_actor
	where film_id in(
		select film_id from film
		where title = "Alone Trip"));
        
-- 7c --
select last_name,first_name,country,email from country c
left join customer cus
on c.country_id = cus.customer_id
where country = "canada";

-- 7d --
select title, category
from film_list
where category = "family";

-- 7e --
select i.film_id, f.title, count(r.inventory_id)
from inventory i
inner join rental r
on i.inventory_id = r.inventory_id
inner join film_text f
on i.film_id = f.film_id
group by r.inventory_id
order by count(r.inventory_id) desc;

-- 7f --
select store.store_id,sum(amount)
from store
inner join staff
on store.store_id = staff.store_id
inner join payment p
on p.staff_id = staff.staff_id
group by store.store_id
order by sum(amount);

-- 7g --
-- apparently there are only two stores...--
select s.store_id, city, country
from store s
inner join address a
ON s.address_id = a.address_id
INNER JOIN city ci
ON a.city_id = ci.city_id
INNER JOIN country coun
ON ci.country_id = coun.country_id;

-- 7h --
-- this does not work...connection timeouut --
select name, sum(amount)
from category c
inner join film_category fc
inner join inventory i
on i.film_id = fc.film_id
inner join rental r
on r.inventory_id = i.inventory_id
inner join payment p
group by name
limit 5;

-- but this works --
select category.name as 'category', sum(payment.amount) as 'gross revenue'
from category, film_category, inventory, payment, rental
where category.category_id = film_category.film_id
and film_category.film_id = inventory.film_id
and inventory.inventory_id = rental.inventory_id
and rental.rental_id = payment.rental_id
group by category.name
order by sum(payment.amount) desc
limit 5;


-- 8a --
create view top_five as 

select category.name as 'category', sum(payment.amount) as 'gross revenue'
from category, film_category, inventory, payment, rental
where category.category_id = film_category.film_id
and film_category.film_id = inventory.film_id
and inventory.inventory_id = rental.inventory_id
and rental.rental_id = payment.rental_id
group by category.name
order by sum(payment.amount) desc
limit 5;

-- 8b --
select * from top_five;


-- 8c --
drop view top_five;


