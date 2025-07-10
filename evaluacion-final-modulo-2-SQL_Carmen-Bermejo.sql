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

-- Pruebas:
SELECT *
FROM category
WHERE name ='Action';

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

-- Query final con USING:
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

-- Query final con USING:
SELECT customer_id, first_name, last_name,  COUNT(c.customer_id) AS 'rented_movies'
FROM customer AS c
INNER JOIN rental
USING (customer_id)
INNER JOIN inventory
USING (inventory_id)
INNER JOIN film
USING (film_id)
GROUP BY customer_id;

/*-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el 
nombre de la categoría junto con el recuento de alquileres.*/

-- Pruebas:
-- para ver los alquileres
SELECT * 
FROM rental LIMIT 10; 

-- para ver el inventario alquilado

SELECT r.rental_id, r.inventory_id, i.film_id
FROM rental AS r
JOIN inventory AS i 
ON r.inventory_id = i.inventory_id
LIMIT 10; 

-- películas alquiladas por título
 
SELECT r.rental_id, f.film_id, f.title AS 'film_name'
FROM rental AS r
JOIN inventory
USING(inventory_id)
JOIN film AS f 
USING(film_id)
LIMIT 10; 

-- añadido categoría

SELECT r.rental_id, f.title AS 'film_name', c.name AS 'category'
FROM rental r
INNER JOIN inventory AS i 
ON r.inventory_id = i.inventory_id
INNER JOIN film AS f 
ON i.film_id = f.film_id
INNER JOIN film_category AS f_cat 
ON f.film_id = f_cat.film_id
INNER JOIN category AS c 
ON f_cat.category_id = c.category_id
LIMIT 10;

-- Query final:
SELECT c.name AS 'category_name', COUNT(r.rental_id) AS total_rentals
	FROM rental r
INNER JOIN inventory AS i 
	ON r.inventory_id = i.inventory_id
INNER JOIN film AS f 
	ON i.film_id = f.film_id
INNER JOIN film_category AS f_cat 
	ON f.film_id = f_cat.film_id
INNER JOIN category AS c 
	ON f_cat.category_id = c.category_id
GROUP BY c.name
	ORDER BY category_name ASC;


/*-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la 
tabla film y muestra la clasificación junto con el promedio de duración.*/

SELECT rating, AVG(length)
FROM film
GROUP BY rating;

/*-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con
title "Indian Love".*/

SELECT a.first_name, a.last_name, f.title AS film_name
FROM actor AS a 
INNER JOIN film_actor
USING (actor_id)
INNER JOIN film AS f
USING (film_id)
WHERE f.title = 'Indian Love'; -- he añadido WHERE para asegurarme

/*-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat"
en su descripción.*/

-- Pruebas:
SELECT title, description
FROM film_text
WHERE description LIKE '%dog%';
-- 99 pelis que contienen la palabra perro

--
SELECT title, description
FROM film_text
WHERE description LIKE '%cat%';
-- 70 pelis que contienen la palabra gato
-- Con UNION ALL salen 169 pelis, por lo que solo hay 2 duplicados de pelis que contengan perro y gato.

-- Query final: 
SELECT title, description
FROM film_text
WHERE description LIKE '%dog%'

UNION -- para quitar duplicados

SELECT title, description
FROM film_text
WHERE description LIKE '%cat%'

ORDER BY title ASC; -- creo que puede causar problemas porque podría coger palabras que contengan esas letras.

-- 15. Hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor.

SELECT actor_id, first_name, last_name
FROM actor;

SELECT actor_id, film_id
FROM film_actor;

SELECT film_id, title
FROM film;

-- Query final:
SELECT a.actor_id, a.first_name, a.last_name
FROM actor AS a
LEFT JOIN film_actor AS f_act 
ON a.actor_id = f_act.actor_id
WHERE f_act.actor_id IS NULL; -- no hay ningún actor/ actriz que no aparezca en ninguna película en la tabla film_actor.


-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.

SELECT title, release_year
FROM film
WHERE release_year BETWEEN 2005 AND 2010;

-- o:
SELECT title, release_year
FROM film
WHERE release_year >= 2005 AND release_year <= 2010;


-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".

SELECT f.title AS film_name, c.name AS category_name
FROM film AS f
INNER JOIN film_category AS f_cat
USING (film_id)
INNER JOIN category AS c
USING (category_id)
WHERE name = 'Family';

-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
-- con GROUP BY y HAVING
SELECT 
    a.actor_id,
    a.first_name,
    a.last_name,
    COUNT(f_act.film_id) AS films_total
FROM actor AS a
INNER JOIN film_actor AS f_act
ON a.actor_id = f_act.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(f_act.film_id) > 10
ORDER BY films_total ASC;

 -- con subconsulta
 
SELECT a.first_name, a.last_name, films_total
FROM actor AS a
INNER JOIN (
    SELECT actor_id, COUNT(film_id) AS films_total
    FROM film_actor
    GROUP BY actor_id
    HAVING COUNT(film_id) > 10
) AS actores 
ON a.actor_id = actores.actor_id
ORDER BY films_total ASC;

/*-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor 
a 2 horas en la tabla film.*/

SELECT title, length, rating
FROM film
WHERE rating = 'R' AND length > 120
ORDER BY length ASC;

/*-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior 
a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.*/

-- Pruebas:
SELECT category_id, name
FROM category
ORDER BY name;

--
SELECT category_id, film_id
FROM film_category;

--
SELECT film_id, title, length
FROM film
ORDER BY length ASC;

--
SELECT f_cat.category_id, f.length
FROM film_category AS f_cat
JOIN film AS f 
ON f_cat.film_id = f.film_id;

-- promedio por categoría:
SELECT f_cat.category_id, AVG(f.length) AS avg_length
FROM film_category AS f_cat
JOIN film AS f 
ON f_cat.film_id = f.film_id
GROUP BY f_cat.category_id;

-- Query final:
SELECT c.name AS category_name, AVG(f.length) AS avg_length
FROM category AS c
INNER JOIN film_category AS f_cat 
ON c.category_id = f_cat.category_id
INNER JOIN film AS f 
ON f_cat.film_id = f.film_id
GROUP BY c.name
HAVING AVG(f.length) > 120
ORDER BY avg_length ASC;


/*-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre
del actor junto con la cantidad de películas en las que han actuado.*/

-- Pruebas: Actriz Penelope ha actuado en 19 películas.
SELECT actor_id, first_name, last_name
FROM actor
LIMIT 5;

SELECT *
FROM film_actor
WHERE actor_id = 1;  

SELECT actor_id, COUNT(film_id) AS total_films
FROM film_actor
WHERE actor_id = 1
GROUP BY actor_id;

-- Query final:
SELECT 
    a.first_name, 
    a.last_name, 
    COUNT(f_act.film_id) AS total_films
FROM actor AS a
JOIN film_actor AS f_act ON a.actor_id = f_act.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(f_act.film_id) >= 5 -- para filtrar solo los que han hecho al menos 5 pelis
ORDER BY total_films ASC;

/*-- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. 
Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y
luego selecciona las películas correspondientes.*/

-- Pruebas: 
SELECT *
FROM film

--
SELECT title, rental_duration
FROM film

--
SELECT rental_id, rental_date, return_date
FROM rental

--
SELECT rental_id
FROM rental
WHERE DATEDIFF(return_date, rental_date) > 5; -- calcular los días de alquiler y devolución

--
SELECT *
FROM film AS f
INNER JOIN inventory AS i
USING (film_id)
INNER JOIN rental AS r
USING (inventory_id)
WHERE film_id = 1;

--
SELECT rental_id, DATEDIFF(return_date, rental_date) duration
FROM rental
WHERE rental_id = 11433;

--
SELECT rental_id, rental_date, return_date, DATEDIFF(return_date, rental_date) AS total_rental_days
FROM rental
WHERE DATEDIFF(return_date, rental_date) > 5;

-- Query final:
SELECT f.title, r.rental_id, DATEDIFF(return_date, rental_date) AS duration
FROM film AS f
JOIN inventory AS i 
ON f.film_id = i.film_id
JOIN rental AS r 
ON i.inventory_id = r.inventory_id
WHERE r.rental_id IN (
    SELECT rental_id
    FROM rental
    WHERE DATEDIFF(return_date, rental_date) > 5);


/*-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película
de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado
 en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.*/
 
-- Prueba (subconsulta)
SELECT DISTINCT f_act.actor_id, c.name
FROM film_actor AS f_act
JOIN film_category AS f_cat
ON f_act.film_id = f_cat.film_id
JOIN category AS c 
ON f_cat.category_id = c.category_id
WHERE c.name = 'Horror'; -- actores (id) que sí han actuado en películas de Horror.

-- Query principal (se nos pide nombre y apellido):
SELECT a.first_name, a.last_name
FROM actor AS a
WHERE a.actor_id NOT IN (...); -- no es un error, es donde debe ir la subconsulta

-- Query final:
SELECT a.first_name, a.last_name
FROM actor AS a
WHERE a.actor_id NOT IN (
    SELECT DISTINCT f_act.actor_id
    FROM film_actor AS f_act
    INNER JOIN film_category AS f_cat 
    ON f_act.film_id = f_cat.film_id
    JOIN category AS c 
    ON f_cat.category_id = c.category_id
    WHERE c.name = 'Horror'
)
ORDER BY a.last_name, a.first_name;
 
 -- ALTERNATIVA: Actores que han actuado en Horror (Incluidos)
SELECT DISTINCT a.first_name, a.last_name, 'Included' AS category
FROM actor AS a
JOIN film_actor AS f_act 
ON a.actor_id = f_act.actor_id
JOIN film_category AS f_cat 
ON f_act.film_id = f_cat.film_id
JOIN category AS c ON 
f_cat.category_id = c.category_id
WHERE c.name = 'Horror'

UNION

-- Actores que NO han actuado en Horror (Excluidos)
SELECT a.first_name, a.last_name, 'Excluded' AS category
FROM actor AS a
WHERE a.actor_id NOT IN (
    SELECT f_act.actor_id
    FROM film_actor AS f_act
    JOIN film_category AS f_cat 
    ON f_act.film_id = f_cat.film_id
    JOIN category AS c 
    ON f_cat.category_id = c.category_id
    WHERE c.name = 'Horror'
)
ORDER BY category, last_name, first_name;
 
/*-- 24. Encuentra el título de las películas que son comedias y tienen una duración mayor
a 180 minutos en la tabla film.*/

-- Pruebas:
SELECT f_cat.category_id, c.name, COUNT(c.name) AS total_films -- 58 películas cat. comedia.
FROM film_category AS f_cat
INNER JOIN category AS c
USING(category_id)
GROUP BY category_id; 

--
SELECT title, length
FROM film;

-- Query final:
SELECT f.title AS film_name, c.name AS category_name, f.length
FROM film AS f
JOIN film_category AS f_cat 
ON f.film_id = f_cat.film_id
JOIN category AS c 
ON f_cat.category_id = c.category_id
WHERE c.name = 'Comedy' AND f.length > 180
ORDER BY f.length ASC;



