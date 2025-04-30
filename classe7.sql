-- 1. Find the films with less duration, show the title and rating
SELECT title, rating
  FROM film 
 WHERE length = (SELECT MIN(length) FROM film);


-- 2. Return the title of the film with the lowest duration only if there is a single one
SELECT title 
  FROM film 
 WHERE length = (SELECT MIN(length) 
                   FROM film)
   AND (SELECT COUNT(*) 
          FROM film 
         WHERE length = (SELECT MIN(length) FROM film)) = 1;


-- 3. Report with list of customers showing the lowest payments done by each of them
-- 3.a Using MIN
SELECT c.customer_id, c.first_name, c.last_name,
       a.address, 
       (SELECT MIN(amount) 
          FROM payment p 
         WHERE p.customer_id = c.customer_id) AS min_payment
  FROM customer c
  JOIN address a ON c.address_id = a.address_id;

-- 3.b Using ALL
SELECT c.customer_id, c.first_name, c.last_name,
       a.address,
       (SELECT amount 
          FROM payment p 
         WHERE p.customer_id = c.customer_id 
           AND amount <= ALL (SELECT amount 
                                FROM payment 
                               WHERE customer_id = c.customer_id)
         LIMIT 1) AS min_payment
  FROM customer c
  JOIN address a ON c.address_id = a.address_id;


-- 4. Report that shows the customer's information with the highest and lowest payment
SELECT c.customer_id, c.first_name, c.last_name,
       (SELECT MAX(amount) 
          FROM payment p 
         WHERE p.customer_id = c.customer_id) AS max_payment,
       (SELECT MIN(amount) 
          FROM payment p 
         WHERE p.customer_id = c.customer_id) AS min_payment
  FROM customer c
 ORDER BY c.customer_id;
