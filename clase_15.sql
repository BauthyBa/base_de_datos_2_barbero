-- vista: list_of_customers
create view list_of_customers as
select 
    c.customer_id,
    concat(c.first_name, ' ', c.last_name) as customer_full_name,
    a.address,
    a.postal_code as zip_code,
    a.phone,
    ci.city,
    co.country,
    case when c.active = 1 then 'active' else 'inactive' end as status,
    c.store_id
from customer c
join address a on c.address_id = a.address_id
join city ci on a.city_id = ci.city_id
join country co on ci.country_id = co.country_id;

-- vista: film_details
create view film_details as
select 
    f.film_id,
    f.title,
    f.description,
    c.name as category,
    f.rental_rate as price,
    f.length,
    f.rating,
    group_concat(concat(a.first_name, ' ', a.last_name) separator ', ') as actors
from film f
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
join film_actor fa on f.film_id = fa.film_id
join actor a on fa.actor_id = a.actor_id
group by f.film_id, f.title, f.description, category, f.rental_rate, f.length, f.rating;

-- vista: sales_by_film_category
create view sales_by_film_category as
select 
    c.name as category,
    count(r.rental_id) as total_rental
from rental r
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
group by c.name;

-- vista: actor_information
create view actor_information as
select 
    a.actor_id,
    a.first_name,
    a.last_name,
    count(fa.film_id) as film_count
from actor a
left join film_actor fa on a.actor_id = fa.actor_id
group by a.actor_id, a.first_name, a.last_name;

-- explicación detallada de la vista actor_info
describe actor_info;

-- la vista actor_info (que ya viene creada en sakila) muestra información de los actores junto con los géneros en los que actuaron y la cantidad de películas en cada uno. utiliza una subconsulta dentro de una tabla derivada.

-- descomponiendo:
-- 1. se hace una subconsulta que une las tablas film, film_actor, category y film_category. agrupa por actor y categoría para contar cuántas películas hizo cada actor por categoría.
-- 2. esa subconsulta se llama film_info y se une con actor para obtener nombre y apellido.
-- 3. finalmente, se seleccionan los campos actor_id, first_name, last_name, category y total_films (que es el count de películas).

-- la subconsulta es clave porque calcula la cantidad de películas por actor y por género antes de unir con actor.

-- materialized views
-- una materialized view es una vista que guarda los datos en disco, no es dinámica como una vista normal.
-- se usa cuando las consultas son pesadas y no cambian mucho los datos, porque mejora el rendimiento.
-- a diferencia de una vista tradicional, que se ejecuta cada vez que se llama, la materialized view se actualiza cada cierto tiempo o manualmente.
-- existen en sistemas como oracle, postgresql (con refresh materialized view), y en sql server con indexed views.
-- una alternativa es usar tablas intermedias con triggers o jobs programados para mantener los datos actualizados.
-- no todos los motores de base de datos soportan materialized views nativamente.
