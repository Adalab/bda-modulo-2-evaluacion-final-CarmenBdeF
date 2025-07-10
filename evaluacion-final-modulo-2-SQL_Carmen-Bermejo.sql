-- Evaluación Final Módulo 2: SQL

USE sakila

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT title
FROM film;

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT title, rating
FROM film
WHERE rating = 'PG-13';

/*-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra
 "amazing" en su descripción.*/
 
SELECT title, description
FROM film
WHERE description LIKE '%amazing%';

 
-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT title, length
FROM film
WHERE length > 120;

-- 5. Recupera los nombres de todos los actores.

SELECT first_name
FROM actor;

-- o:

SELECT first_name, last_name
FROM actor;

-- o:

SELECT CONCAT(first_name, ' ', last_name) AS full_name 
FROM actor;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT first_name, last_name, actor_id
FROM actor
WHERE last_name = 'Gibson';

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

SELECT first_name, last_name, actor_id
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

/*-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni
"PG-13" en cuanto a su clasificación.*/

SELECT title, rating
FROM film
WHERE rating NOT IN ('R', 'PG-13');


/*-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y 
muestra la clasificación junto con el recuento.*/

-- Queries de comprobación:

SELECT *
FROM category
WHERE name ='Action';

-- Action: 64

SELECT *
FROM film_category
WHERE category_id =1;

-- Query final:

SELECT c.name AS "film_category", COUNT(name)
FROM film AS f
INNER JOIN film_category AS f_cat
ON f.film_id = f_cat.film_id
INNER JOIN category AS c
ON f_cat.category_id = c.category_id
GROUP BY c.name;

-- Limpio:

SELECT c.name AS "film_category", COUNT(name)
FROM film AS f
INNER JOIN film_category AS f_cat
USING (film_id)
INNER JOIN category AS c
USING (category_id)
GROUP BY c.name;

/*-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID 
del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.*/

-- Prueba:

SELECT customer_id
FROM rental
WHERE customer_id = '2'; -- Customer_id: 2 ha alquilado 27 películas

-- Query final (limpia):

SELECT customer_id, first_name, last_name,  COUNT(c.customer_id) AS 'rented_movies'
FROM customer AS c
INNER JOIN rental
USING (customer_id)
INNER JOIN inventory
USING (inventory_id)
INNER JOIN film
USING (film_id)
GROUP BY customer_id;

-- Había usado ALIAS pero al hacer uso de USING, no he visto necesidad de mantenerlo, más que en c.customer.

/*-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría
junto con el recuento de alquileres.*/











/*-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y
muestra la clasificación junto con el promedio de duración.*/











/*-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con
title "Indian Love".*/












/*-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat"
en su descripción.*/











-- 15. Hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor.











-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.











-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".










-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.











/*-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor 
a 2 horas en la tabla film.*/











/*-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior 
a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.*/












/*-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre
del actor junto con la cantidad de películas en las que han actuado.*/












/*-- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. 







Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y
luego selecciona las películas correspondientes.*/







/*-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película
de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado
 en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.*/
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
/*-- 24. Encuentra el título de las películas que son comedias y tienen una duración mayor
a 180 minutos en la tabla film.*/