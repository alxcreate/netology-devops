# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

### Ответ:

Docker-compose:
```
version: "3"
services:
  mysql:
    image: postgres
    container_name: postgres
    ports:
      - "5432:5432"
    volumes:
      - /Users/alx/Documents/git/netology-devops/Homeworks/02-virt-homeworks/06-db-04-postgresql/docker/volume/db:/var/lib/mysql
      - /Users/alx/Documents/git/netology-devops/Homeworks/02-virt-homeworks/06-db-04-postgresql/docker/volume/backup:/tmp/backup
    environment:
      POSTGRES_HOST_AUTH_METHOD: trust
    restart: always
volumes:
  db:
  backup:
```
Запуск psql:
```
alx@alx-laptop docker % docker-compose up -d
[+] Running 2/2
 ⠿ Network docker_default  Created                                                              0.0s
 ⠿ Container postgres      Started                                                              0.3s
alx@alx-laptop docker % docker exec -it postgres bash
root@7dcdede253da:/# psql -U postgres
psql (14.5 (Debian 14.5-1.pgdg110+1))
Type "help" for help.

postgres=# \?
```
Команды из списка:
```
  \l[+]   [PATTERN]      list databases
  \c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
                         connect to new database (currently "postgres")
  \dt[S+] [PATTERN]      list tables
  \d[S+]  NAME           describe table, view, sequence, or index
  \q                     quit psql
```

## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

### Ответ:

```
postgres=# create database test_database;
postgres=# \c test_database
test_database=# \i /tmp/backup/test_dump.sql
```
Столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах:
```
test_database=# analyze;
ANALYZE

test_database=# select attname, avg_width from pg_stats where tablename='orders' order by avg_width desc limit 1;
 attname | avg_width 
---------+-----------
 title   |        16
(1 row)

```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

### Ответ:

Создание таблиц:
```
test_database=# create table orders_1 (like orders including all);
CREATE TABLE
test_database=# create table orders_2 (like orders including all);
CREATE TABLE
```
Создание наследования:
```
test_database=# alter table orders_1 inherit orders;
ALTER TABLE
test_database=# alter table orders_2 inherit orders;
ALTER TABLE
```
Ограничение партиций:
```
test_database=# alter table orders_1 add constraint partition_check check (price > 499);
ALTER TABLE
test_database=# alter table orders_2 add constraint partition_check check (price <= 499);
ALTER TABLE
```
Перемещение данных:
```
test_database=# INSERT INTO orders_1 SELECT * FROM orders WHERE price > 499;
INSERT 0 3
test_database=# INSERT INTO orders_2 SELECT * FROM orders WHERE price <= 499;
INSERT 0 5
test_database=# DELETE FROM only orders;
DELETE 8
```

Изначально можно было бы написать функцию и триггер которые будут автоматически записывать в нужные таблицы, либо использовать PG Partition Manager.

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

### Ответ:
Создание резервной копии:
```
root@7dcdede253da:/# pg_dump -U postgres -d test_database >/tmp/backup/backup_test_database.sql
```
Для уникальности значений я бы добавил соответствующий параметр:
alter table orders add UNIQUE (title);