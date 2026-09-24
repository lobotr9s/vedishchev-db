# HW1. Проектирование базы данных

## Название проекта

Online Store Database

## Описание предметной области

Интернет-магазин предоставляет возможность клиентам просматривать каталог товаров, оформлять заказы и оплачивать покупки.

Для работы магазина необходимо хранить информацию о клиентах, товарах, категориях товаров, заказах и платежах. База данных позволяет организовать хранение этих данных и обеспечить связь между ними.

---

# Сущности

## Customer

Покупатели интернет-магазина.

Атрибуты:

- customer_id (PK)
- name
- email
- phone

## Category

Категории товаров.

Атрибуты:

- category_id (PK)
- name
- description

## Product

Товары магазина.

Атрибуты:

- product_id (PK)
- name
- price
- stock_quantity
- category_id (FK)

## Order

Заказы клиентов.

Атрибуты:

- order_id (PK)
- order_date
- status
- customer_id (FK)

## OrderItem

Товары, входящие в заказ.

Атрибуты:

- order_item_id (PK)
- quantity
- order_id (FK)
- product_id (FK)

## Payment

Информация об оплате заказа.

Атрибуты:

- payment_id (PK)
- amount
- payment_date
- payment_method
- order_id (FK)

---

# Связи между сущностями

1. Один покупатель может оформить несколько заказов.

Customer (1) → (N) Order

2. Один заказ может содержать несколько товаров.

Order (1) → (N) OrderItem

3. Один товар может входить в несколько заказов.

Product (1) → (N) OrderItem

4. Одна категория содержит несколько товаров.

Category (1) → (N) Product

5. Каждому заказу соответствует одна запись об оплате.

Order (1) → (1) Payment

---

# ER-диаграмма

ER-диаграмма выполнена в нотации Crow's Foot и сохранена в файле ERD.png.

---

# Запрос 1

## Формулировка

Найти названия товаров стоимостью более 1000 рублей.

## Реляционная алгебра

σ(price > 1000)(Product)

π(name)(σ(price > 1000)(Product))

---

# Запрос 2

## Формулировка

Найти имена клиентов и даты их заказов.

## Реляционная алгебра

Customer ⋈ Customer.customer_id = Order.customer_id Order

π(name, order_date)
(
Customer ⋈ Customer.customer_id = Order.customer_id Order
)