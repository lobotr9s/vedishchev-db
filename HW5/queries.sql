-- HW5. Агрегатные функции и группировка. PostgreSQL, схема после HW2.

-- 1.1. Посчитать общее количество фильмов.
SELECT COUNT(*) AS movie_count
FROM movies;

-- 1.2. Посчитать количество проданных билетов.
SELECT COUNT(*) AS sold_ticket_count
FROM tickets
WHERE status = 'sold';

-- 2.1. Посчитать общую вместимость всех залов.
SELECT SUM(capacity) AS total_capacity
FROM halls;

-- 2.2. Посчитать суммарную длительность всех фильмов в минутах.
SELECT SUM(duration_min) AS total_duration_min
FROM movies;

-- 3.1. Найти средний рейтинг фильмов.
SELECT ROUND(AVG(rating), 2) AS average_rating
FROM movies;

-- 3.2. Найти среднюю цену сеанса.
SELECT ROUND(AVG(price), 2) AS average_price
FROM sessions;

-- 4.1. Найти длительность самого короткого фильма.
SELECT MIN(duration_min) AS shortest_duration_min
FROM movies;

-- 4.2. Найти минимальную цену сеанса.
SELECT MIN(price) AS minimum_price
FROM sessions;

-- 5.1. Найти самый высокий рейтинг фильма.
SELECT MAX(rating) AS highest_rating
FROM movies;

-- 5.2. Найти вместимость самого большого зала.
SELECT MAX(capacity) AS largest_capacity
FROM halls;

-- 6.1. Собрать названия всех фильмов в одну строку по алфавиту.
SELECT STRING_AGG(title, ', ' ORDER BY title) AS movie_titles
FROM movies;

-- 6.2. Собрать имена клиентов со скидкой в одну строку.
SELECT STRING_AGG(name, ', ' ORDER BY name) AS customers_with_discount
FROM customers
WHERE discount_percent > 0;

-- 7.1. Посчитать фильмы для каждой страны производства.
SELECT country, COUNT(*) AS movie_count
FROM movies
GROUP BY country
ORDER BY country;

-- 7.2. Посчитать билеты каждого статуса.
SELECT status, COUNT(*) AS ticket_count
FROM tickets
GROUP BY status
ORDER BY status;

-- 8.1. Найти страны, для которых в базе есть не меньше двух фильмов.
SELECT country, COUNT(*) AS movie_count
FROM movies
GROUP BY country
HAVING COUNT(*) >= 2
ORDER BY country;

-- 8.2. Найти сеансы, для которых продано не меньше двух билетов.
SELECT session_id, COUNT(*) AS sold_ticket_count
FROM tickets
WHERE status = 'sold'
GROUP BY session_id
HAVING COUNT(*) >= 2
ORDER BY session_id;

-- 9.1. Посчитать фильмы отдельно по странам и отдельно по жанрам.
SELECT CASE WHEN GROUPING(country) = 1 THEN 'Все страны'
            ELSE COALESCE(country, 'Страна не указана') END AS country,
       CASE WHEN GROUPING(genre_id) = 1 THEN 'Все жанры'
            ELSE COALESCE(genre_id::text, 'Жанр не указан') END AS genre,
       COUNT(*) AS movie_count
FROM movies
GROUP BY GROUPING SETS ((country), (genre_id))
ORDER BY GROUPING(country), country, genre;

-- 9.2. Посчитать билеты по сеансам и статусам, по сеансам и всего.
SELECT CASE WHEN GROUPING(session_id) = 1 THEN 'Все сеансы'
            ELSE COALESCE(session_id::text, 'Сеанс не указан') END AS session,
       CASE WHEN GROUPING(status) = 1 THEN 'Все статусы'
            ELSE COALESCE(status, 'Статус не указан') END AS status,
       COUNT(*) AS ticket_count
FROM tickets
GROUP BY GROUPING SETS ((session_id, status), (session_id), ())
ORDER BY GROUPING(session_id), session_id, GROUPING(status), status;

-- 10.1. Посчитать фильмы по странам и жанрам, добавить итоги по странам и общий итог.
SELECT CASE WHEN GROUPING(country) = 1 THEN 'Все страны'
            ELSE COALESCE(country, 'Страна не указана') END AS country,
       CASE WHEN GROUPING(genre_id) = 1 THEN 'Все жанры'
            ELSE COALESCE(genre_id::text, 'Жанр не указан') END AS genre,
       COUNT(*) AS movie_count
FROM movies
GROUP BY ROLLUP (country, genre_id)
ORDER BY GROUPING(country), country, GROUPING(genre_id), genre;

-- 10.2. Посчитать билеты по сеансам и статусам с итогами по сеансам и общим итогом.
SELECT CASE WHEN GROUPING(session_id) = 1 THEN 'Все сеансы'
            ELSE COALESCE(session_id::text, 'Сеанс не указан') END AS session,
       CASE WHEN GROUPING(status) = 1 THEN 'Все статусы'
            ELSE COALESCE(status, 'Статус не указан') END AS status,
       COUNT(*) AS ticket_count
FROM tickets
GROUP BY ROLLUP (session_id, status)
ORDER BY GROUPING(session_id), session_id, GROUPING(status), status;

-- 11.1. Посчитать фильмы для всех сочетаний страны и жанра с итогами по каждой категории.
SELECT CASE WHEN GROUPING(country) = 1 THEN 'Все страны'
            ELSE COALESCE(country, 'Страна не указана') END AS country,
       CASE WHEN GROUPING(genre_id) = 1 THEN 'Все жанры'
            ELSE COALESCE(genre_id::text, 'Жанр не указан') END AS genre,
       COUNT(*) AS movie_count
FROM movies
GROUP BY CUBE (country, genre_id)
ORDER BY GROUPING(country), country, GROUPING(genre_id), genre;

-- 11.2. Посчитать сеансы для всех сочетаний зала и формата, включая промежуточные и общий итоги.
SELECT CASE WHEN GROUPING(hall_id) = 1 THEN 'Все залы'
            ELSE COALESCE(hall_id::text, 'Зал не указан') END AS hall,
       CASE WHEN GROUPING(format) = 1 THEN 'Все форматы'
            ELSE COALESCE(format, 'Формат не указан') END AS format,
       COUNT(*) AS session_count
FROM sessions
GROUP BY CUBE (hall_id, format)
ORDER BY GROUPING(hall_id), hall_id, GROUPING(format), format;

-- 12.1. Среди проданных билетов найти сеансы с двумя и более продажами и вывести сначала самые популярные.
SELECT session_id, COUNT(*) AS sold_ticket_count
FROM tickets
WHERE status = 'sold'
GROUP BY session_id
HAVING COUNT(*) >= 2
ORDER BY sold_ticket_count DESC, session_id;

-- 12.2. Среди фильмов с рейтингом не ниже 8 найти страны с двумя и более такими фильмами и отсортировать по среднему рейтингу.
SELECT country, COUNT(*) AS movie_count,
       ROUND(AVG(rating), 2) AS average_rating
FROM movies
WHERE rating >= 8
GROUP BY country
HAVING COUNT(*) >= 2
ORDER BY average_rating DESC, country;

-- 13.1. Посчитать количество фильмов, средний и максимальный рейтинг.
SELECT COUNT(*) AS movie_count,
       ROUND(AVG(rating), 2) AS average_rating,
       MAX(rating) AS highest_rating
FROM movies;

-- 13.2. Найти минимальную, среднюю и максимальную цену сеанса.
SELECT MIN(price) AS minimum_price,
       ROUND(AVG(price), 2) AS average_price,
       MAX(price) AS maximum_price
FROM sessions;

-- 14.1. Посчитать по странам фильмы с рейтингом не ниже 8.
SELECT country, COUNT(*) AS movie_count
FROM movies
WHERE rating >= 8
GROUP BY country
ORDER BY country;

-- 14.2. Посчитать все фильмы по странам, оставив страны со средним рейтингом не ниже 8.
SELECT country, COUNT(*) AS movie_count,
       ROUND(AVG(rating), 2) AS average_rating
FROM movies
GROUP BY country
HAVING AVG(rating) >= 8
ORDER BY country;
