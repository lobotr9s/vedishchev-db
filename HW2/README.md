# HW2 — SQL-скрипты

## Что сделано
1. **CREATE** — создано 6 таблиц: `genres`, `movies`, `halls`, `customers`, `sessions`, `tickets`.
2. **ALTER** — выполнено 5 изменений структуры:
   - Добавлено поле `country` в `movies`
   - Переименовано `seats_count` → `capacity` в `halls`
   - Добавлено поле `format` в `sessions`
   - Удалено и заново добавлено поле `phone` в `customers` (с новым типом)
3. **INSERT** — заполнено по 3–6 записей в каждую таблицу.
4. **UPDATE** — выполнено 5 обновлений данных.
5. **JOIN** — проверочный запрос объединяет 4 таблицы и выводит полную информацию о билетах.

## Скриншоты
- `structure_tickets.png` — структура таблицы `tickets`
- `data_tickets.png` — данные таблицы `tickets`
- `data_sessions.png` — данные таблицы `sessions` (цена IMAX обновлена)
- `join_query.png` — результат JOIN-запроса

## Как запустить
Выполнить `script.sql` в pgAdmin в базе `cinema_db` (Query Tool → F5).