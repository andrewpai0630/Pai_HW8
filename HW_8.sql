USE sakila;

#1a
SELECT * from actor;

#1b
SELECT concat(first_name, ' ' , last_name) AS "Actor Name"
FROM actor;

#2a
SELECT first_name, last_name, actor_id
FROM actor
WHERE first_name = "Joe";

#2b
SELECT first_name, last_name, actor_id
FROM actor
WHERE last_name LIKE  "%Gen%";

#2c
SELECT last_name, first_name, actor_id
FROM actor
WHERE last_name LIKE "%li%"
ORDER BY last_name;

#2d
SELECT country, country_id
FROM country
WHERE country IN ("Afghanistan", "Bangladesh", "China");

#3a
ALTER TABLE actor
ADD description BLOB;

#3b
ALTER TABLE actor
DROP description;

#4a
SELECT last_name, COUNT(*) AS "Count"
FROM actor
GROUP BY last_name;

#4b
SELECT last_name, COUNT(*) AS "Count"
FROM actor
GROUP BY last_name
HAVING COUNT(*) > 2;

#4c
UPDATE actor
SET first_name = "Harpo"
WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS";

#4d NOT FINISHED
UPDATE actor
SET first_name = "GROUCHO"
WHERE first_name = "HARPO";

#5a
SHOW CREATE TABLE address;

#6a
SELECT staff.first_name, staff.last_name, address.address
FROM staff
LEFT JOIN address ON staff.address_id = address.address_id;

#6b
SELECT staff.staff_id, SUM(payment.amount) AS "Total Payment Amount"
FROM staff
LEFT JOIN payment ON staff.staff_id=payment.staff_id
GROUP BY staff.staff_id;

#6c
SELECT film.title, COUNT(film_actor.actor_id) AS "Number of Actors"
FROM film
INNER JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY film.film_id;

#6d
SELECT COUNT(inventory_id) AS "Number of Copies"
FROM inventory
WHERE film_id IN
	(
	SELECT film_id
	FROM film
	WHERE title = "Hunchback Impossible"
    );

#6e
SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS "Total Spent"
FROM customer
LEFT JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY last_name;

#7a
SELECT title
FROM film 
WHERE title LIKE 'K%' OR title LIKE 'Q%'
AND title IN 
	(
	SELECT title 
	FROM film 
	WHERE language_id = 1
	);
    
#7b
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
	(
	SELECT actor_id
	FROM film_actor
	WHERE film_id IN
		(
		SELECT film_id
		FROM film
		WHERE title = "Alone Trip"
		)
	);
    
#7c
SELECT customer.email, customer.first_name, customer.last_name
FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN city ON city.city_id = address.city_id
JOIN country ON country.country_id = city.country_id
WHERE country.country ="Canada";

#7d
SELECT title FROM film 
WHERE film_id IN
	(
	SELECT film_id FROM film_category
	WHERE category_id IN
		(
		SELECT category_id FROM category
		WHERE name = "Family"
		)
	);

#7e
SELECT inventory.film_id, film.title, COUNT(rental.inventory_id) AS "Times Rented Out"
FROM inventory 
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
INNER JOIN film ON inventory.film_id = film.film_id
GROUP BY rental.inventory_id
ORDER BY COUNT(rental.inventory_id) DESC;

#7f
SELECT store.store_id, SUM(amount) as "Store Revenue"
FROM payment
JOIN rental ON payment.rental_id = rental.rental_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN store ON inventory.store_id = store.store_id
GROUP BY store.store_id;

#7g
SELECT store.store_id, city.city, country.country 
FROM store 
JOIN address ON store.address_id = address.address_id
JOIN city ON city.city_id = address.city_id
JOIN country ON country.country_id = city.country_id;

#7h
SELECT category.name AS "Top Five", SUM(payment.amount) AS "Gross" 
FROM category 
JOIN film_category ON category.category_id=film_category.category_id
JOIN inventory ON film_category.film_id=inventory.film_id
JOIN rental ON inventory.inventory_id=rental.inventory_id
JOIN payment ON rental.rental_id=payment.rental_id
GROUP BY category.name 
ORDER BY Gross DESC 
LIMIT 5;

#8a
CREATE VIEW top_five AS
SELECT category.name AS "Top Five", SUM(payment.amount) AS "Gross" 
FROM category 
JOIN film_category ON category.category_id=film_category.category_id
JOIN inventory ON film_category.film_id=inventory.film_id
JOIN rental ON inventory.inventory_id=rental.inventory_id
JOIN payment ON rental.rental_id=payment.rental_id
GROUP BY category.name 
ORDER BY Gross DESC 
LIMIT 5;

#8b
SELECT * FROM top_five;

#8c
DROP VIEW top_five;