					---------------TAREA 3--------------------------

--1. Cómo obtenemos todos los nombres y correos de nuestros clientes canadienses para una campaña?
-------------Con active nos sercioramos de que sigue siendo cliente------------

select c.first_name ||' '|| c.last_name, c.email 
from customer c 
join customer_list cl on customer_id = cl.id
where cl.country = 'Canada' and c.active = 1;

--2. Qué cliente ha rentado más de nuestra sección de adultos 
-------------Hay dos clientes que cumplen el máximo (21)--------------------------

--lA CATEGORIA NC-17 CONTEMPLA QUE NO LA VEN NIÑOS, ES DECIR, SOLO LA VEN ADULTOS. Rating R es definida como adultos.

select c.first_name ||' '||  c.last_name as nombre, t.rentas from 
(
select p.customer_id, count(*) as rentas from payment p
join rental r using (rental_id)
join inventory inven using (inventory_id)
join film f using (film_id)
where f.rating in ('R','NC-17')
group by p.customer_id
order by 2 desc limit 2) as t
join customer c on t.customer_id = c.customer_id;

--3. Qué películas son las más rentadas en todas nuestras stores?

		--------------Este query indica la pelicula más rentada por store------------
		select distinct on (s.store_id) s.store_id, f.title, count(f.film_id) as veces
		from film f 
		join inventory i using (film_id) 
		join rental r using (inventory_id) 
		join store s using (store_id)
		group by f.title,s.store_id order by s.store_id, veces desc;
		
		
		-------------Este presenta el top 10 de las películas más rentadas en general. 
		select f.title, count(f.film_id) as veces from film f
		join inventory i using (film_id) join rental r using (inventory_id)
		group by f.title order by veces desc limit 10;
		
		----------------Este otro responde a la pelicula más rentada en suma de las rentas de ambas stores------------------
		select f.title, count(f.title) rentas from rental r
		join inventory i using (inventory_id)
		join film f using (film_id)
		group by f.title
		order by 2 desc
		limit 1;
		
		---AHORA BIEN, si lo pide un contador seguro lo querrá desglozado algo así...
		select f.title, s.store_id, count(f.film_id) as veces 
		from film f join inventory i using (film_id) 
		join rental r using (inventory_id) 
		join store s using (store_id)
		group by cube(f.title,s.store_id) order by veces desc;

---------------- Cuál es nuestro revenue por store? ---------------------------

--Podemos complicarnos la vida y ejecutar un query que calcula los ingresos derivados de las rentas por store, de esta manera...

select s.store_id, sum(p.amount) as total from store s
join inventory i using (store_id) 
join rental r using (inventory_id) 
join payment p using (rental_id)
group by s.store_id;

-- O podemos aprovechar que una tabla está creada justamente con esa információn...
-- Por construcción sabemos que el store_id 1 corresponde a la tienda de Canada y el 2 a la de Australia. 

select * from sales_by_store sbs;

