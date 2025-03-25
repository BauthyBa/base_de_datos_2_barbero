CREATE DATABASE imdb;
USE imdb;

CREATE TABLE actor (
  actor_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,  
  PRIMARY KEY (actor_id)
);

CREATE TABLE film (
  film_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  title VARCHAR(255) NOT NULL,
  description TEXT DEFAULT NULL,
  release_year YEAR DEFAULT NULL,
  PRIMARY KEY (film_id)
);

CREATE TABLE film_actor (
  actor_id SMALLINT UNSIGNED NOT NULL,
  film_id SMALLINT UNSIGNED NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (actor_id, film_id),
  CONSTRAINT fk_film_actor_actor FOREIGN KEY (actor_id) REFERENCES actor (actor_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

ALTER TABLE film 
ADD COLUMN last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

ALTER TABLE film_actor 
ADD CONSTRAINT fk_film_actor_film FOREIGN KEY (film_id) REFERENCES film (film_id) ON DELETE RESTRICT ON UPDATE CASCADE;

INSERT INTO actor (first_name, last_name) VALUES
('Leonardo', 'DiCaprio'),
('Robert', 'Downey Jr.'),
('Scarlett', 'Johansson'),
('Tom', 'Hanks');

INSERT INTO film (title, description, release_year) VALUES
('Inception', 'A mind-bending thriller.', 2010),
('Iron Man', 'A billionaire becomes a superhero.', 2008),
('Avengers', 'Superheroes save the world.', 2012),
('Forrest Gump', 'A man with a kind heart witnesses history.', 1994);

INSERT INTO film_actor (actor_id, film_id) VALUES
(1, 1),
(2, 2),
(2, 3),
(3, 3),
(4, 4);
