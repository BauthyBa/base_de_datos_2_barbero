insert into customer (store_id, first_name, last_name, email, address_id, active, create_date)
values (
    1,
    'juan',
    'perez',
    'juan.perez@example.com',
    (
        select address_id
        from address
        where city_id in (
            select city_id from city where country_id = (
                select country_id from country where country = 'united states'
            )
        )
        order by address_id desc
        limit 1
    ),
    1,
    current_timestamp
);

insert into rental (rental_date, inventory_id, customer_id, staff_id)
values (
    current_timestamp,
    (
        select inventory_id
        from inventory
        where film_id = (
            select film_id from film where title = 'film title' limit 1
        )
        order by inventory_id desc
        limit 1
    ),
    (
        select customer_id
        from customer
        order by rand()
        limit 1
    ),
    (
        select staff_id
        from staff
        where store_id = 2
        limit 1
    )
);

update film set release_year = 2001 where rating = 'G';
update film set release_year = 2002 where rating = 'PG';
update film set release_year = 2003 where rating = 'PG-13';
update film set release_year = 2004 where rating = 'R';
update film set release_year = 2005 where rating = 'NC-17';

update rental
set return_date = current_timestamp
where rental_id = (
    select rental_id
    from rental
    where return_date is null
    order by rental_date desc
    limit 1
);

delete from film_actor
where film_id = (select film_id from film where title = 'academy dinosaur');

delete from film_category
where film_id = (select film_id from film where title = 'academy dinosaur');

delete from rental
where inventory_id in (
    select inventory_id from inventory where film_id = (
        select film_id from film where title = 'academy dinosaur'
    )
);

delete from inventory
where film_id = (select film_id from film where title = 'academy dinosaur');

delete from film where title = 'academy dinosaur';

insert into rental (rental_date, inventory_id, customer_id, staff_id)
values (
    current_timestamp,
    1000,
    (select customer_id from customer order by rand() limit 1),
    (select staff_id from staff order by rand() limit 1)
);

insert into payment (customer_id, staff_id, rental_id, amount, payment_date)
values (
    (select customer_id from rental where inventory_id = 1000 order by rental_date desc limit 1),
    (select staff_id from rental where inventory_id = 1000 order by rental_date desc limit 1),
    (select rental_id from rental where inventory_id = 1000 order by rental_date desc limit 1),
    4.99,
    current_timestamp
);
