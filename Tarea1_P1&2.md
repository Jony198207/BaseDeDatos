# Tarea 1 



--1. Qué contactos de proveedores tienen la posición de sales representative?

select *
from suppliers s
where s.contact_title  = 'Sales Representative';

--2. Qué contactos de proveedores no son marketing managers?

select *
from suppliers s
where s.contact_title  != 'Marketing Manager';

--3. Cuales órdenes no vienen de clientes en Estados Unidos?
--Para responder se necesita hacer un join de las tablas orders y customers.

select *
from orders o
join customers c using (customer_id)
where c.country != 'USA';

--Estados Unidos--> USA

--4. Qué productos de los que transportamos son quesos?
-- Estudiando la tabla categories nos damos cuenta que la categoria correspondiente a los quesos 
-- se llama "Dairy Products". El id es 4, pero este id se recuperará por medio de un sub-query. De aquí se sigue que:

select p.product_name
from products p
where p.category_id = 
(select c.category_id
from categories c
where c.category_name = 'Dairy Products');

--5. Qué ordenes van a Bélgica o Francia?

select * from orders o
where o.ship_country in ('Belgium','France');

--6. Qué órdenes van a LATAM?

--Conociendo los países a los que se dirigen las ordenes:

select distinct(o.ship_country)
from orders o;

--Notamos que los países latinoamericanos que aparecen son: Argentina, Venezuela, Mexico, Brazil.Generamos 
--nuestro query que responde a la pregunta.

select * 
from orders o
where o.ship_country
in ('Argentina','Venezuela','Mexico','Brazil');

--7. Qué órdenes no van a LATAM?

select * 
from orders o
where o.ship_country
not in ('Argentina','Venezuela','Mexico','Brazil');

--8. Necesitamos los nombres completos de los empleados, nombres y apellidos unidos en un mismo registro
--Para lograrlo usamos la función concat()...

select concat(e.first_name,' ',e.last_name) 
from employees e;

--9. Cuánta lana tenemos en inventario?
--Hace referencia a la cantidad de productos que tenemos por su precio unitario. Así, tendremos en términos de dinero
--lo que se tiene en Stock.

select sum(p.unit_price *units_in_stock) as Lana 
from products p;

--10. Cuantos clientes tenemos de cada país?

select c.country, count(*)  
from customers c 
group by c.country;


------------------ SEGUNDA PARTE ----------------

--1. Obtener un reporte de edades de los empleados para checar su elegibilidad para seguro de gastos médicos menores.
-- Con precisión de años.

select concat(e.first_name,' ',e.last_name) as Empleado,
date_part('year',age(current_date,e.birth_date)) as Edad
from employees e; 

--2. Cuál es la orden más reciente por cliente?

select o.order_id as orden, max(o.order_date) as Orden_Mas_Reciente
from orders o
join customers c using (customer_id)
group by customer_id,o.order_id;

--3. De nuestros clientes, qué función desempeñan y cuántos son?

select c.contact_title as Funcion, count(*) as cantidad
from customers c
group by c.contact_title;

--4. Cuántos productos tenemos de cada categoría?

select c.category_name, count(p.product_name) as cantidad
from categories c
join products p using (category_id) 
group by c.category_name;

--5. Cómo podemos generar el reporte de reorder?

--Consideremos que para poder reordenar un producto, este no tiene que estar descontinuado, es decir, la columna discontinued=0. 
--Además, la columna "reorder_level" nos indica cuando debemos reordenar según las cantidades disponibles
--Entendiendo "disponibles" como la diferencia entre units_in_stock y units_on_order.

select p.product_id, p.product_name, (p.reorder_level - (p.units_in_stock - p.units_on_order)) as Cantidad_a_surtir_mínima 
from products p
where (p.units_in_stock - p.units_on_order) <= p.reorder_level and p.discontinued = 0;


--6. A donde va nuestro envío más voluminoso?
--Se nos presentan dos pedidos con el mismo volumen máximo (130)

select o.ship_address, o.ship_city, o.ship_country from orders o where o.order_id in 
(select od2.order_id
from order_details od2
where quantity = (select max(quantity) as cantidad
from order_details od));

--Notemos que ambos pedidos (diferentes) van a la misma dirección.

--7. Cómo creamos una columna en customers que nos diga si un cliente es bueno, regular, o malo?
--Podemos categorizarlos según el promedio de pedidos general,.

--Query para conocer el promedio

select avg(count) as prom
from (select customer_id,count(*)
from orders o group by customer_id)as a;

--Notamos que el promedio de pedidos es de alrededor de 9.3, con base en eso...
--Podemos hacer un "Alter table customers add status enum{la categorización deseada}" según el criterio que decidamos.
--Por ejemplo, que sea bueno si es mayor de 10, regular si está entre 7 y 10 y malo si es menor a eso.

--8. Qué colaboradores chambearon durante las fiestas de navidad?
-- sólo podemos saber, a ciencia cierta, que shippers trabajaron durante ese día. Pues, aunque también se
-- reporta el empleado que estuvo a cargo del pedido, los días 24 y 25 de diciembre pudieron ser sólo de envíos, es decir, 
-- que el employee no trabaje. 
-- Se contempla como fechas navideñas el 24 y 25 de diciembre, así como el 31.

select s.company_name
from shippers s 
join orders o2 on (s.shipper_id = o2.ship_via)
where s.shipper_id in
(select o.ship_via
from orders o
where o.shipped_date in ('1996-12-24','1997-12-24','1998-12-24')
or o.shipped_date in ('1996-12-25','1997-12-25','1998-12-25')
or o.shipped_date in ('1996-12-31','1997-12-31','1998-12-31'))
group by s.company_name;

--9. Qué productos mandamos en navidad?

--Que sea mandado en navidad significa que shipped_date = ____-12-25;

select product_name
from products p
join order_details od using (product_id)
join orders o on (od.order_id=o.order_id)
where p.product_id in
(select od2.product_id
from order_details od2 
where order_id in 
(select o2.order_id from orders o2 where o2.shipped_date in ('1996-12-25','1997-12-25','1998-12-25')))
group by product_name;
 
--10. Qué país recibe el mayor volumen de producto?

--País que recibe, como suma de todas sus quantitys de pedidos de todas las personas que hicieron pedido a ese país
--,el mayor volúmen.

select ship_country, cantidad from (select o.ship_country, sum(od.quantity) as cantidad
from orders o 
join order_details od using (order_id)
group by o.ship_country) as aux
where cantidad = (select max(cantidad) from (select o.ship_country, sum(od.quantity) as cantidad
from orders o 
join order_details od using (order_id)
group by o.ship_country) as aux);

