# Tarea 5 

Sabemos que:
- El volúmen que ocupa cada película (Blu-Ray) en el sistema cilíndrico es de 5040 centímetros cúbicos (30cm x 21cm x 8cm).
- Cada película representa una carga de 0.5 Kg.
- Cada cilindro aguanta un peso máximo de 50kg como máximo.

Ahora bien, sabemos que si optimizamos entonces cada cilindro es capaz de contener 
`select 50/0.5 as películas;`, es decir:

![image](https://user-images.githubusercontent.com/101894380/171522145-2d958671-fdd0-4a00-8ca2-50e708ff1e83.png)

Con lo anterior en mente es necesario ahora saber cuantas películas se tienen por store y, de esa manera, 
calcular cuantos cilindros necesitará cada tienda en función de ello. Podemos conocerlo con el siguiente query:

```
with p as(
	select store_id, count(*) as total_peliculas, (count(*)*5040) as volumen_total,
	(count(*)*0.5) as peso_total, (count(*)*0.5/50) as cilindros_necesarios
	from inventory i group by store_id
)
select * from p;
```

Del cuál obtenemos la siguiente información:

![image](https://user-images.githubusercontent.com/101894380/171522485-e767b354-4204-48c8-9818-b8744d27962b.png)

Con esto sabemos ahora que la **store 1 necesita 23 cilindros y la store 2, 24** (ya que no existirán cilindros contenedores medios). Además, **cada cilindro alberga 100 películas**.

El problema radica ahora en que queremos acomodar cajas rectangulares en una superficie tubular cilíndrica hueca (para dar lugar al sistema que toma las películas).
Si hicieramos cilindros capaces de contener estas 100 películas en un sólo nivel, nos ocuparía mucho espacio físico en las tiendas en los ejes x, y; pero estaríamos desperdiciando la dimensión del eje z. Por eso es que propongo que es mejor utilizar un sistema de niveles, es decir, **un cilindro de, por ejemplo, 20 películas por nivel y 5 niveles en total.**

En cada nivel de 20 películas, habrá 20 espacios para películas de **31 cm de largo x 9 cm de anchura y 22 cm de altura**. De esta manera, cada dimensión tendrá **1 cm de holgura** para permitir un fácil acceso por parte del brazo robotizado. Además, cada nivel tendrá una base de 1 cm de grosor, de manera que la **altura de cada nivel será de 23 cm**.

Es decir, cada slock será algo así.

![image](https://user-images.githubusercontent.com/101894380/171524382-18245d3a-6f93-4340-91f5-1f973a76ca80.png)

Así, sabemos que nuestro cilindro hueco tendrá un radio correspondiente al de un perímetro de 9 cm x 20 (películas por nivel), es decir, que su perímetro sea: `select 9 * 25 as perímetro;`, es decir:

![image](https://user-images.githubusercontent.com/101894380/171525543-354c5485-748b-47ee-89f0-87dbc4f9ba1e.png)

Sabemos que el perímetro de un circulo se calcula con `2 x π x r `, entonces podemos calcular nuestro radio ideal solucionando `r = 225/(2 x π)`. Resolviendo obtenemos que nuestro **radio interno** será de estos:

![image](https://user-images.githubusercontent.com/101894380/171526079-f27e745d-1964-4509-824a-8b373b920691.png)

Cabe aclarar que con estas medidas, suponemos que el brazo robótico es capaz de maniobrar en el diámetro de:

![image](https://user-images.githubusercontent.com/101894380/171526252-88aa1169-a27e-4ebd-8a61-9b35dbc9c071.png)

Así mismo, sabemos también que el **radio externo** será el resultado de sumarle 31 (largo de cada película) a nuestro radio interno, es decir, de 66.80 cm. 
Dichas medidas están dadas en centímetros. Con esto podremos tener una separación angular cada vez más grande entre cada película por nivel.

## Recopilando medidas del cilindro

- Radio interno de 35.80 cm.
- Radio externo de 66.80 cm.
- Altura por nivel de 23 cm, lo que da una altura total de 115 cm (al sobreponer los 5 niveles)

Así, finalmente calculamos el volúmen total.

`select pi()*pow(66.80,2)*115 as volumen_cilindro;`

Resultandonos:

![image](https://user-images.githubusercontent.com/101894380/171528064-08f755c7-16a4-420d-8fbd-4b6eb2021b58.png)

Es decir, 1,612,132.15 centímetros cúbicos o poco más de 1.5 metros cúbicos.




