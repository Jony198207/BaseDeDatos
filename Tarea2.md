# Tarea 2 

## Código de la creación de la tabla e inserción de datos

```
create table Tarea2 (
	nombre varchar(50) not null,
	email varchar(70) not null
);

insert into Tarea2 values ('Wanda Maximoff','wanda.maximoff@avengers.org');
insert into Tarea2 values ('Pietro Maximoff','pietro@mail.sokovia.ru');
insert into Tarea2 values ('Erik Lensherr','fuck_you_charles@brotherhood.of.evil.mutants.space');
insert into Tarea2 values ('Charles Javier','i.am.secretely.filled.with.hubris@xavier-school-4-gifted-youngste.');
insert into Tarea2 values ('Anthony Edward Stark','iamironman@avengers.gov');
insert into Tarea2 values ('Steve Rogers','americas_ass@anti_avengers');
insert into Tarea2 values ('The Vision','vis@westview.sword.gov');
insert into Tarea2 values ('Clint Barton','bul@lse.ye');
insert into Tarea2 values ('Natasja Romanov','blackwidow@kgb.ru');
insert into Tarea2 values ('Thor','god_of_thunder-^_^@royalty.asgard.gov');
insert into Tarea2 values ('Logan','wolverine@cyclops_is_a_jerk.com');
insert into Tarea2 values ('Ororo Monroe','ororo@weather.co');
insert into Tarea2 values ('Scott Summers','o@x');
insert into Tarea2 values ('Nathan Summers','cable@xfact.or');
insert into Tarea2 values ('Groot','iamgroot@asgardiansofthegalaxyledbythor.quillsux');
insert into Tarea2 values ('Nebula','idonthaveelektras@complex.thanos');
insert into Tarea2 values ('Gamora','thefiercestwomaninthegalaxy@thanos.');
insert into Tarea2 values ('Rocket','shhhhhhhh@darknet.ru');

```

## Query para obtener los correos inválidos

Para obtener los emails inválidos de esta tabla, cómo se nos solicitó, basta con ejecutar el siguiente query (regresa los emails inválidos y el nombre 
de la persona a la que pertenence):

```
select * from Tarea2 where not (email like '%@%._%'
and email not like '%^@%._%');
```
## Query para obtener cualquier email inválido

Si queremos validar cualquier correo o, en este caso, obtener correos inválidos, entonces debemos de considerar diversos casos. Por ejemplo, un correo válido
no puede tener dos `@`, mucho menos consecutivos, tampoco puede tener dos puntos seguidos o empezar con un caracter de este tipo. De igual manera, no acepta caracteres
especiales del teclado, como por ejemplo: `|, !, ", /, ^, >, ;, ","` etc, de manera que si un email rompe con alguna de estas reglas, será un email inválido y, por tanto, el query lo deberá reportar.
Con eso en mente, obtenemos el siguiente query:

```
select * from Tarea2 where not (email like '%@%._%'
and email not like '%@%@%'
and email not like '%..%'
and email not like '%--%'
and email not like '% %'
and email not like '%°%'
and email not like '%|%'
and email not like '%¬%'
and email not like '%!%'
and email not like '%"%'
and email not like '%#%'
and email not like '%&%'
and email not like '%/%'
and email not like '%(%'
and email not like '%)%'
and email not like '%=%'
and email not like '%?%'
and email not like '%¿%'
and email not like '%\%'
and email not like '%¡%'
and email not like '%´%'
and email not like '%¨%'
and email not like '%+%'
and email not like '%*%'
and email not like '%~%'
and email not like '%[%'
and email not like '%]%'
and email not like '%^%'
and email not like '%{%'
and email not like '%}%'
and email not like '%,%'
and email not like '%;%'
and email not like '%`%'
and email not like '%>%'
and email not like '%<%'
);

```

## Query de tarea para puntos extras

Este es el query que presenté en clase como solución a esta tarea.

select sas.nombre,string_agg(sas.equipo, ', '), sum(sas.anios_servicio)
from superheroes_anios_servicio sas
group by sas.nombre;


