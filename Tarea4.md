# Tarea 4

## Pregunta 1: Cuál es el promedio, en formato human-readable, de tiempo entre cada pago por cliente de la BD Sakila?

```
--Es conveniente crear una view, dado que en la pregunta 3 requerimos nuevamente de esta informacion

CREATE VIEW intervalo_pagos
AS (
with p as(
	select c.customer_id, max(p.payment_date) as latest, min(p.payment_date) as oldest
	from customer c join payment p on c.customer_id=p.customer_id
	group by c.customer_id
), ct as (
	select p2.customer_id, count(*) as totPays from payment p2 group by p2.customer_id
)
select p.customer_id, concat(c.first_name, ' ', c.last_name) as client,
age(p.latest,p.oldest)/ct.totPays as avg_interval
from p p join ct ct on p.customer_id=ct.customer_id join customer c on ct.customer_id=c.customer_id
order by c.customer_id
);


--De esta manera, una vez que creamos el view para usar su estructura despues, 
--la respuesta a esta pregunta se obtiene con su query interior, es decir...

	with p as(
		select c.customer_id, max(p.payment_date) as latest, min(p.payment_date) as oldest
		from customer c join payment p on c.customer_id=p.customer_id
		group by c.customer_id
	), ct as (
		select p2.customer_id, count(*) as totPays from payment p2 group by p2.customer_id
	)
	select p.customer_id, concat(c.first_name, ' ', c.last_name) as client,
	age(p.latest,p.oldest)/ct.totPays as avg_interval
	from p p join ct ct on p.customer_id=ct.customer_id join customer c on ct.customer_id=c.customer_id
	order by c.customer_id;

```

## Pregunta 2: Sigue una distribución normal?

```
--De igual manera creamos un view para usarlo despues 

CREATE VIEW intervalo_pagos_numerico
AS (
	with p as(
	select c.customer_id, max(p.payment_date) as latest, min(p.payment_date) as oldest
	from customer c join payment p on c.customer_id=p.customer_id
	group by c.customer_id order by c.customer_id
	), ct as (
		select p2.customer_id, count(*) as totPays from payment p2 group by p2.customer_id
	)
	select p.customer_id, concat(c.first_name, ' ', c.last_name) as client,
	extract(epoch from (age(p.latest,p.oldest)/ct.totPays)) as avg_interval
	from p p join ct ct on p.customer_id=ct.customer_id join customer c on ct.customer_id=c.customer_id
	order by c.customer_id
);

--De esta manera, la información que necesitamos para comprobar si es una distribucion normal o no, podemos obtenerla de un histograma
--del anterior view.

select * from histogram('intervalo_pagos_numerico','avg_interval');

--Con estos datos ya podemos saber que no es normal, pues no es logNormal, por lo que hacer la verificacion de la segunda propiedad
--ya no es necesario
```

Si graficamos los datos que nos arroja el histograma, obtenemos una gráfica como la siguiente, dónde de tener una distribución normal debería verse como la línea punteada, pero, cómo vemos, presenta muchas irregularidades, es decir, no tiene distribución normal.

![image](https://user-images.githubusercontent.com/101894380/171085168-815b4097-3587-4f31-9b11-a4be96a494f3.png)

## Pregunta 3: Qué tanto difiere ese promedio del tiempo entre rentas por cliente?

```
CREATE VIEW orden_intervalo
AS (
	with p as(
		select c.customer_id, max(r.rental_date) as latest, min(r.rental_date) as oldest
		from customer c join rental r on c.customer_id=r.customer_id
		group by c.customer_id order by c.customer_id
	), ct as (
		select r2.customer_id, count(*) as totRents from rental r2 group by r2.customer_id order by r2.customer_id
	)
	select p.customer_id, concat(c.first_name, ' ', c.last_name) as client,
	age(p.latest,p.oldest)/ct.totRents as avg_interval
	from p p join ct ct on p.customer_id=ct.customer_id join customer c on ct.customer_id=c.customer_id
	order by c.customer_id
);

---Finalmente, aprovechamos los view anteriores y respondemos a esta pregunta

	select oi.customer_id, concat(c.first_name, ' ', c.last_name) as cliente,
	(oi.avg_interval-pa.avg_interval) as diferencia
	from orden_intervalo oi join
	intervalo_pagos pa on oi.customer_id=pa.customer_id join customer c on pa.customer_id=c.customer_id;

```

