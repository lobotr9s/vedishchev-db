-- Справочник жанров
CREATE TABLE genres (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- Фильмы
CREATE TABLE movies (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    duration_min INT CHECK (duration_min > 0),
    genre_id INT REFERENCES genres(id),
    rating DECIMAL(3, 1) CHECK (rating >= 0 AND rating <= 10)
);

-- Залы
CREATE TABLE halls (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    seats_count INT CHECK (seats_count > 0),
    hall_type VARCHAR(20) DEFAULT 'Обычный'
);

-- Клиенты
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) UNIQUE,
    discount_percent INT DEFAULT 0 CHECK (discount_percent BETWEEN 0 AND 100)
);

-- Сеансы
CREATE TABLE sessions (
    id SERIAL PRIMARY KEY,
    movie_id INT REFERENCES movies(id),
    hall_id INT REFERENCES halls(id),
    start_time TIMESTAMP NOT NULL,
    price DECIMAL(10, 2) CHECK (price >= 0)
);

-- Билеты
CREATE TABLE tickets (
    id SERIAL PRIMARY KEY,
    session_id INT REFERENCES sessions(id),
    customer_id INT REFERENCES customers(id),
    seat_number INT NOT NULL,
    status VARCHAR(20) DEFAULT 'sold' CHECK (status IN ('sold', 'booked', 'returned'))
);


ALTER TABLE movies ADD COLUMN country VARCHAR(50);
ALTER TABLE halls RENAME COLUMN seats_count TO capacity;
ALTER TABLE sessions ADD COLUMN format VARCHAR(10) DEFAULT '2D';
ALTER TABLE customers DROP COLUMN phone;
ALTER TABLE customers ADD COLUMN phone VARCHAR(30) UNIQUE;



INSERT INTO genres (name) VALUES 
('Фантастика'), ('Боевик'), ('Комедия'), ('Драма');

INSERT INTO movies (title, duration_min, genre_id, rating, country) VALUES 
('Интерстеллар', 169, 1, 8.6, 'США'),
('Начало', 148, 1, 8.8, 'США'),
('Джентльмены', 113, 2, 7.8, 'Великобритания'),
('Отель Гранд Будапешт', 99, 3, 8.1, 'США');

INSERT INTO halls (name, capacity, hall_type) VALUES 
('Зал 1 IMAX', 120, 'IMAX'),
('Зал 2 VIP', 20, 'VIP'),
('Зал 3 Стандарт', 80, 'Обычный');

INSERT INTO customers (name, phone, discount_percent) VALUES 
('Иван Иванов', '89001112233', 5),
('Петр Петров', '89004445566', 0),
('Анна Сидорова', '89007778899', 10);

INSERT INTO sessions (movie_id, hall_id, start_time, price, format) VALUES 
(1, 1, '2026-10-25 19:00:00', 600.00, 'IMAX'),
(2, 1, '2026-10-25 22:00:00', 550.00, 'IMAX'),
(3, 3, '2026-10-26 20:00:00', 400.00, '2D'),
(4, 2, '2026-10-26 18:00:00', 1200.00, '2D');

INSERT INTO tickets (session_id, customer_id, seat_number, status) VALUES 
(1, 1, 15, 'sold'),
(1, 2, 16, 'sold'),
(1, 3, 17, 'booked'),
(2, 1, 5, 'sold'),
(3, 2, 42, 'sold'),
(4, 3, 1, 'booked');


UPDATE sessions SET price = 700.00 WHERE format = 'IMAX';
UPDATE customers SET discount_percent = 20 WHERE name = 'Анна Сидорова';
UPDATE tickets SET status = 'sold' WHERE id = 3;
UPDATE movies SET rating = 8.7 WHERE title = 'Интерстеллар';
UPDATE halls SET name = 'Зал 2 Премиум' WHERE hall_type = 'VIP';


SELECT 
    c.name AS client,
    m.title AS movie,
    s.start_time,
    s.price,
    t.seat_number,
    t.status
FROM tickets t
JOIN customers c ON t.customer_id = c.id
JOIN sessions s ON t.session_id = s.id
JOIN movies m ON s.movie_id = m.id
ORDER BY t.id;