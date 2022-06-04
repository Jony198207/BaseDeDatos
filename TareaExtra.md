# Tarea Extra 

Se nos pide el cambio en el monto total de pagos mes con mes de cada cliente (esto es las deltas). Es decir, la diferencia del monto de pagos realizados por cliente
en el mes t menos el monto de pagos del mes t-1. Debido a esto, esta delta puede ser positiva, negativa o cero o inexistente al no haber realizado compras en un mes. 
Además, es necesario considerar los 2 años de operaciones de los que tenemos registro (1997 y 1998). Lo obtenemos así...

``` 
with deltas as (
	select o.order_id,
	o.customer_id as cliente,
	o.order_date as fecha,
	sum(od.quantity*od.unit_price) as monto, ---Monto en mes t
	lag(sum(od.quantity*od.unit_price),1,(0)::float) over w as monto_tmenos1, ---Monto en mes t-1
	(sum(od.quantity*od.unit_price)-lag(sum(od.quantity*od.unit_price),1,(0)::float) over w) as delta --diferencia
	from orders o join order_details od using (order_id) group by o.order_id
	window w as (partition by customer_id order by order_date)
	)
select cliente,
extract(year from fecha) as anio,
extract(month from fecha) as mes,
avg(delta) as prom_deltas
from deltas group by anio,cliente,mes order by cliente, anio, mes;

```



