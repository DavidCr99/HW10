#1A
USE sakila;
SELECT first_name, last_name 
FROM actor;

#Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT first_name AS actor_name
FROM actor
WHERE first_name = UPPER(first_name)
UNION
SELECT last_name AS actor_name
FROM actor
WHERE last_name = UPPER(last_name);

#You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT first_name, actor_id, last_name
FROM actor
WHERE first_name LIKE 'JOE%';

#Find all actors whose last name contain the letters GEN:
SELECT last_name
FROM actor
WHERE last_name LIKE '%GEN%';

#Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT last_name, first_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

#Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

#create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE actor
ADD COLUMN description BLOB;

#Delete the description column.
ALTER TABLE actor
DROP COLUMN description;

# List the last names of actors, as well as how many actors have that last name.
SELECT last_name,
COUNT(last_name)
FROM actor
GROUP BY last_name;

#List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name,
COUNT(last_name) as COUNT 
FROM actor
GROUP BY last_name 
HAVING COUNT >= 2;

#The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO"
AND last_name = "WILLIAMS"

# first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor
SET first_name = "GROUCHO"
WHERE first_name = "HARPO"
AND last_name = "WILLIAMS"

#You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;
DESCRIBE address; 

#Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT s.first_name, s.last_name, a.address
FROM staff S
LEFT JOIN address A
ON s.address_id = a.address_id;

#Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT s.first_name, s.last_name, s.staff_id,
SUM(p.amount) AS Total
FROM staff S
INNER JOIN payment P
ON s.staff_id = p.staff_id
WHERE P.payment_date >='2005-08-01' 
AND P.payment_date<='2005-08-31'
GROUP BY s.staff_id;

#List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT f.title,
COUNT(fa.actor_id)
FROM film F
INNER JOIN film_actor FA
ON f.film_id=fa.film_id
GROUP BY f.title;




#How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT f.title,
COUNT(i.inventory_id)
FROM film F
INNER JOIN inventory I 
ON f.film_id=i.film_id
WHERE f.title="Hunchback Impossible"
GROUP BY f.title;

#Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT c.first_name, c.last_name, c.customer_id,
SUM(p.amount)
FROM customer C
INNER JOIN payment P
ON c.customer_id=p.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name ASC;

#Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select d.title,d.name
from 
(select f.title,
l.name

from film F
inner join language L
on f.language_id = l.language_id
where name ="English") D

where d.title LIKE 'K%' 
OR d.title LIKE 'Q%';

#Use subqueries to display all actors who appear in the film Alone Trip. ###WHY 3 TABLES, WHY FROM FA, EXPLAIN THE JOINS
select f.title, fa.film_id, a.first_name, a.last_name
from film_actor fa
inner join film f 
on fa.film_id = f.film_id
inner join actor A 
on fa.actor_id = A.actor_id
where f.title="Alone Trip";

#You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT c.first_name, c.last_name, c.email, ci.city, co.country
FROM customer c INNER JOIN address a ON c.address_id=a.address_id
INNER JOIN city ci ON a.city_id=ci.city_id
INNER JOIN country co ON ci.country_id=co.country_id
WHERE co.country="CANADA"; 

#Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT f.title, fc.category_id, c.name
FROM film f INNER JOIN film_category fc ON f.film_id=fc.film_id 
INNER JOIN category c ON fc.category_id=c.category_id
WHERE c.name ="FAMILY"; 

#Display the most frequently rented movies in descending order.
SELECT f.title,
COUNT(r.rental_id)
FROM film f 
INNER JOIN inventory i ON f.film_id = i.film_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY COUNT(r.rental_id) DESC;

#Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id,
SUM(p.amount)
FROM payment p INNER JOIN customer c ON p.customer_id=c.customer_id
INNER JOIN store s ON s.store_id=c.store_id
GROUP BY s.store_id;

#Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, c.city, co.country
FROM store s
INNER JOIN address a ON s.address_id = a.address_id
INNER JOIN city c ON a.city_id = c.city_id
INNER JOIN country co ON c.country_id = co.country_id;

#List the top five genres in gross revenue in descending order.
SELECT c.name,
SUM(p.amount)
FROM category c INNER JOIN film_category fc ON c.category_id = fc.category_id
INNER JOIN inventory i ON fc.film_id = i.film_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id
INNER JOIN payment p ON r.rental_id = p.rental_id 
GROUP BY NAME
ORDER BY SUM(p.amount) DESC
LIMIT 5;

#8a
CREATE VIEW TOP5 AS SELECT c.name,
SUM(p.amount)
FROM category c INNER JOIN film_category fc ON c.category_id = fc.category_id
INNER JOIN inventory i ON fc.film_id = i.film_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id
INNER JOIN payment p ON r.rental_id = p.rental_id 
GROUP BY NAME
ORDER BY SUM(p.amount) DESC
LIMIT 5;

#8b
SELECT * FROM top5;

#8c
DROP VIEW top5;























































