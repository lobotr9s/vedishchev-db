-- HW4. Схема HW2 после ALTER и UPDATE. Запускать запросы по одному для скриншотов.

-- 1.1. Вывести все данные о фильмах.
SELECT * FROM movies;

-- 1.2. Вывести все данные о клиентах.
SELECT * FROM customers;

-- 2.1. Вывести названия и рейтинги фильмов.
SELECT title, rating FROM movies;

-- 2.2. Вывести имена и телефоны клиентов.
SELECT name, phone FROM customers;

-- 3.1. Вывести фильмы с понятными заголовками столбцов.
SELECT title AS "Фильм", duration_min AS "Длительность"
FROM movies;

-- 3.2. Вывести названия залов и количество мест.
SELECT name AS "Зал", capacity AS "Количество мест"
FROM halls;

-- 4.1. Перевести длительность фильмов в часы.
SELECT title, duration_min / 60.0 AS duration_hours
FROM movies;

-- 4.2. Рассчитать цену сеанса после скидки 10%.
SELECT id, price, price * 0.90 AS discounted_price
FROM sessions;

-- 5.1. Округлить длительность фильмов в часах до двух знаков.
SELECT title, ROUND(duration_min / 60.0, 2) AS duration_hours
FROM movies;

-- 5.2. Найти, насколько рейтинг каждого фильма отличается от 8.
SELECT title, rating, ABS(rating - 8) AS rating_difference
FROM movies;

-- 6.1. Для каждого фильма показать, превышает ли его рейтинг 8.
SELECT title, rating, rating > 8 AS high_rating
FROM movies;

-- 6.2. Для каждого клиента показать, есть ли у него скидка.
SELECT name, discount_percent, discount_percent > 0 AS has_discount
FROM customers;

-- 7.1. Найти фильмы с рейтингом не ниже 8.5.
SELECT title, rating FROM movies
WHERE rating >= 8.5;

-- 7.2. Найти сеансы дешевле 800 рублей.
SELECT id, start_time, price FROM sessions
WHERE price < 800;

-- 8.1. Найти фильмы с рейтингом выше 8 и длительностью более 120 минут.
SELECT title, rating, duration_min FROM movies
WHERE rating > 8 AND duration_min > 120;

-- 8.2. Найти обычные или VIP-залы вместимостью не меньше 20 мест.
SELECT name, hall_type, capacity FROM halls
WHERE (hall_type = 'Обычный' OR hall_type = 'VIP')
  AND NOT (capacity < 20);

-- 9.1. Найти фильмы длительностью от 100 до 150 минут включительно.
SELECT title, duration_min FROM movies
WHERE duration_min BETWEEN 100 AND 150;

-- 9.2. Найти проданные и забронированные билеты.
SELECT id, seat_number, status FROM tickets
WHERE status IN ('sold', 'booked');

-- 10.1. Вывести фильмы по убыванию рейтинга.
SELECT title, rating FROM movies
ORDER BY rating DESC, title ASC;

-- 10.2. Вывести билеты по сеансу, затем по номеру места.
SELECT id, session_id, seat_number FROM tickets
ORDER BY session_id ASC, seat_number ASC;

-- 11.1. Найти фильмы, название которых начинается с «Интер».
SELECT title FROM movies
WHERE title LIKE 'Интер%';

-- 11.2. Найти клиентов, телефон которых начинается с 8900 и содержит 11 символов.
SELECT name, phone FROM customers
WHERE phone LIKE '8900_______';

-- 12.1. Вывести страны производства фильмов без повторов.
SELECT DISTINCT country FROM movies
ORDER BY country;

-- 12.2. Вывести используемые статусы билетов без повторов.
SELECT DISTINCT status FROM tickets
ORDER BY status;

-- 13.1. Вывести два фильма с самым высоким рейтингом.
SELECT title, rating FROM movies
ORDER BY rating DESC, id
LIMIT 2;

-- 13.2. Вывести следующие два фильма после первых двух по рейтингу.
SELECT title, rating FROM movies
ORDER BY rating DESC, id
LIMIT 2 OFFSET 2;

-- 14.1. Разделить фильмы по рейтингу на три категории.
SELECT title, rating,
       CASE
           WHEN rating >= 8.5 THEN 'Высокий'
           WHEN rating >= 8 THEN 'Хороший'
           WHEN rating IS NULL THEN 'Не указан'
           ELSE 'Ниже 8'
       END AS rating_category
FROM movies;

-- 14.2. Вывести статусы билетов по-русски.
SELECT id, seat_number,
       CASE status
           WHEN 'sold' THEN 'Продан'
           WHEN 'booked' THEN 'Забронирован'
           WHEN 'returned' THEN 'Возвращён'
           ELSE 'Неизвестен'
       END AS status_name
FROM tickets;

-- 15.1. Вывести названия фильмов и их жанры.
SELECT m.title, g.name AS genre
FROM movies m
INNER JOIN genres g ON m.genre_id = g.id
ORDER BY m.id;

-- 15.2. Вывести билеты с именами покупателей.
SELECT t.id AS ticket_id, c.name, t.seat_number
FROM tickets t
INNER JOIN customers c ON t.customer_id = c.id
ORDER BY t.id;

-- 16.1. Вывести все жанры и соответствующие фильмы, включая жанры без фильмов.
SELECT g.name AS genre, m.title
FROM genres g
LEFT JOIN movies m ON g.id = m.genre_id
ORDER BY g.id, m.id;

-- 16.2. Вывести все фильмы и их сеансы, включая фильмы без сеансов.
SELECT m.title, s.id AS session_id, s.start_time
FROM movies m
LEFT JOIN sessions s ON m.id = s.movie_id
ORDER BY m.id, s.id;

-- 17.1. Вывести фильмы и все жанры, включая жанры без фильмов.
SELECT m.title, g.name AS genre
FROM movies m
RIGHT JOIN genres g ON m.genre_id = g.id
ORDER BY g.id, m.id;

-- 17.2. Вывести сеансы и все залы, включая залы без сеансов.
SELECT s.id AS session_id, h.name AS hall, s.start_time
FROM sessions s
RIGHT JOIN halls h ON s.hall_id = h.id
ORDER BY h.id, s.id;

-- 18.1. Получить все возможные сочетания фильмов и залов для планирования.
SELECT m.title, h.name AS hall
FROM movies m
CROSS JOIN halls h
ORDER BY m.id, h.id;

-- 18.2. Получить все сочетания клиентов и жанров для опроса о предпочтениях.
SELECT c.name AS customer, g.name AS genre
FROM customers c
CROSS JOIN genres g
ORDER BY c.id, g.id;

-- 19.1. Вывести все фильмы и жанры, сохранив строки без совпадений с обеих сторон.
SELECT m.title, g.name AS genre
FROM movies m
FULL OUTER JOIN genres g ON m.genre_id = g.id
ORDER BY g.id, m.id;

-- 19.2. Сопоставить проданные и забронированные билеты по клиенту и показать обе группы целиком.
SELECT sold.customer_id AS sold_customer_id,
       sold.id AS sold_ticket_id,
       booked.customer_id AS booked_customer_id,
       booked.id AS booked_ticket_id
FROM (SELECT id, customer_id FROM tickets WHERE status = 'sold') sold
FULL OUTER JOIN
     (SELECT id, customer_id FROM tickets WHERE status = 'booked') booked
ON sold.customer_id = booked.customer_id
ORDER BY COALESCE(sold.customer_id, booked.customer_id), sold.id, booked.id;

-- 20.1. Вывести билеты с именем клиента, фильмом и временем сеанса.
SELECT t.id AS ticket_id, c.name AS customer, m.title, s.start_time
FROM tickets t
INNER JOIN customers c ON t.customer_id = c.id
INNER JOIN sessions s ON t.session_id = s.id
INNER JOIN movies m ON s.movie_id = m.id
ORDER BY t.id;

-- 20.2. Вывести расписание с фильмом, жанром и залом.
SELECT s.id AS session_id, m.title, g.name AS genre,
       h.name AS hall, s.start_time
FROM sessions s
INNER JOIN movies m ON s.movie_id = m.id
INNER JOIN genres g ON m.genre_id = g.id
INNER JOIN halls h ON s.hall_id = h.id
ORDER BY s.start_time, s.id;
