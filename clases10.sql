
-- 1. títulos de películas que no están en el inventario
select f.title
from film f
where f.film_id not in (
    select i.film_id
    from inventory i
);


-- 2. películas que están en inventario pero nunca fueron alquiladas
select f.title, i.inventory_id
from film f
join inventory i on f.film_id = i.film_id
left join rental r on i.inventory_id = r.inventory_id
where r.rental_id is null;

--  3. reporte con nombre del cliente, id de tienda, título de la película, cuándo se alquiló y devolvió
select cu.first_name, cu.last_name, cu.store_id, f.title,
       r.rental_date, r.return_date
from customer cu
join rental r on cu.customer_id = r.customer_id
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
order by cu.store_id, cu.last_name;

-- 4. ventas por tienda con ciudad, país, datos del manager y total vendido
select concat(ci.city, ', ', co.country) as ciudad_pais,
       concat(st.first_name, ' ', st.last_name) as nombre_manager,
       sum(p.amount) as total_ventas
from store s
join address a on s.address_id = a.address_id
join city ci on a.city_id = ci.city_id
join country co on ci.country_id = co.country_id
join staff st on s.manager_staff_id = st.staff_id
join customer c on s.store_id = c.store_id
join payment p on c.customer_id = p.customer_id
group by ciudad_pais, nombre_manager;

-- 5 . actor que apareció en más películas
select a.first_name, a.last_name, count(fa.film_id) as cantidad_peliculas
from actor a
join film_actor fa on a.actor_id = fa.actor_id
group by a.actor_id, a.first_name, a.last_name
order by cantidad_peliculas desc;
