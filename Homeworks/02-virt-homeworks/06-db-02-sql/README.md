# Домашнее задание к занятию "6.2. SQL"

## Введение

Перед выполнением задания вы можете ознакомиться с
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume,
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

### Ответ

```
version: "3"
services:
  postgres:
    image: postgres
    container_name: hw0602-1
    ports:
      - "5432:5432"
    volumes:
      - /Users/alx/Documents/docker/volumes/vol1:/var/lib/docker/volumes/vol1/_data
      - /Users/alx/Documents/docker/volumes/vol3:/var/lib/docker/volumes/vol2/_data
    environment:
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=pass
      - POSTGRES_DB=db
    restart: always
volumes:
  vol1:
  vol2:
```

## Задача 2

В БД из задачи 1:

- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:

- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:

- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:

- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db

### Ответ

- итоговый список БД после выполнения пунктов выше:

```
SELECT datname FROM pg_database;
"datname"
"postgres"
"db"
"template1"
"template0"
"test_db"
```

- описание таблиц (describe)

```
SELECT * FROM information_schema.tables
WHERE table_schema NOT IN ('information_schema','pg_catalog');
"table_catalog" "table_schema" "table_name" "table_type" "self_referencing_column_name" "reference_generation" "user_defined_type_catalog" "user_defined_type_schema" "user_defined_type_name" "is_insertable_into" "is_typed" "commit_action"
"test_db" "public" "orders" "BASE TABLE"      "YES" "NO" 
"test_db" "public" "clients" "BASE TABLE"      "YES" "NO" 
```

- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db

```
select * from information_schema.table_privileges where grantee in ('test-admin-user','test-simple-user')
```

- список пользователей с правами над таблицами test_db

```
"grantor" "grantee" "table_catalog" "table_schema" "table_name" "privilege_type" "is_grantable" "with_hierarchy"
"user" "test-admin-user" "test_db" "public" "clients" "INSERT" "NO" "NO"
"user" "test-admin-user" "test_db" "public" "clients" "SELECT" "NO" "YES"
"user" "test-admin-user" "test_db" "public" "clients" "UPDATE" "NO" "NO"
"user" "test-admin-user" "test_db" "public" "clients" "DELETE" "NO" "NO"
"user" "test-admin-user" "test_db" "public" "clients" "TRUNCATE" "NO" "NO"
"user" "test-admin-user" "test_db" "public" "clients" "REFERENCES" "NO" "NO"
"user" "test-admin-user" "test_db" "public" "clients" "TRIGGER" "NO" "NO"
"user" "test-simple-user" "test_db" "public" "clients" "INSERT" "NO" "NO"
"user" "test-simple-user" "test_db" "public" "clients" "SELECT" "NO" "YES"
"user" "test-simple-user" "test_db" "public" "clients" "UPDATE" "NO" "NO"
"user" "test-simple-user" "test_db" "public" "clients" "DELETE" "NO" "NO"
"user" "test-admin-user" "test_db" "public" "orders" "INSERT" "NO" "NO"
"user" "test-admin-user" "test_db" "public" "orders" "SELECT" "NO" "YES"
"user" "test-admin-user" "test_db" "public" "orders" "UPDATE" "NO" "NO"
"user" "test-admin-user" "test_db" "public" "orders" "DELETE" "NO" "NO"
"user" "test-admin-user" "test_db" "public" "orders" "TRUNCATE" "NO" "NO"
"user" "test-admin-user" "test_db" "public" "orders" "REFERENCES" "NO" "NO"
"user" "test-admin-user" "test_db" "public" "orders" "TRIGGER" "NO" "NO"
"user" "test-simple-user" "test_db" "public" "orders" "INSERT" "NO" "NO"
"user" "test-simple-user" "test_db" "public" "orders" "SELECT" "NO" "YES"
"user" "test-simple-user" "test_db" "public" "orders" "UPDATE" "NO" "NO"
"user" "test-simple-user" "test_db" "public" "orders" "DELETE" "NO" "NO"
```

## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:

- вычислите количество записей для каждой таблицы
- приведите в ответе:
  - запросы
  - результаты их выполнения.

### Ответ

Добавление данных:

```
insert into orders values
(1,'Шоколад',10),
(2,'Принтер',3000),
(3,'Книга',500),
(4,'Монитор',7000),
(5,'Гитара',4000);

insert into clients values 
(1,'Иванов Иван Иванович','USA'),
(2,'Петров Петр Петрович','Canada'),
(3,'Иоганн Себастьян Бах','Japan'),
(4,'Ронни Джеймс Дио','Russia'),
(5,'Ritchie Blackmore','Russia');
```

Количество записей в таблицах:

```
select count (*) from orders;
"count"
5
```

```
select count (*) from clients;
"count"
5
```

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.

Подсказка - используйте директиву `UPDATE`.

### Ответ

Внесение изменений в таблицу:

```
UPDATE clients
SET "Order" = (SELECT id FROM orders WHERE "Name" = 'Книга')
WHERE "LastName" = 'Иванов Иван Иванович';

UPDATE clients
SET "Order" = (SELECT id FROM orders WHERE "Name" = 'Монитор')
WHERE "LastName" = 'Петров Петр Петрович';

UPDATE clients
SET "Order" = (SELECT id FROM orders WHERE "Name" = 'Гитара')
WHERE "LastName" = 'Иоганн Себастьян Бах';
```

Выввод всех пользователей, которые совершили заказ:

```
select * from clients where "Order" is not null

"id" "LastName" "Country" "Order"
1 "Иванов Иван Иванович" "USA" 3
2 "Петров Петр Петрович" "Canada" 4
3 "Иоганн Себастьян Бах" "Japan" 5
```

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

### Ответ

```
"QUERY PLAN"
"Seq Scan on clients  (cost=0.00..1.05 rows=3 width=47)"
"  Filter: (""Order"" IS NOT NULL)"
```

Cost - оценочная стоимость.

Rows - число записей, обработанных для получения выходных данных.

Width - среднее количество байт в одной строке.

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления.

### Ответ

Бэкап:

```
alx@alx-laptop ~ % docker exec -it hw0602-1 pg_dumpall -U user --roles-only -f /var/lib/docker/volumes/vol2/_data/roles.sql 
alx@alx-laptop ~ % docker exec -it hw0602-1 pg_dump -h localhost -U user -F t -f /var/lib/docker/volumes/vol2/_data/backup_1.tar test_db    
```

Останавливаем первый контейнер:

```
alx@alx-laptop ~ % docker stop hw0602-1   
```

Запускаем второй через docker-compose:

```
version: "3"
services:
  postgres:
    image: postgres
    container_name: hw0602-2
    ports:
      - "5432:5432"
    volumes:
      - /Users/alx/Documents/docker/volumes/vol2:/var/lib/docker/volumes/vol1/_data
      - /Users/alx/Documents/docker/volumes/vol3:/var/lib/docker/volumes/vol2/_data
    environment:
      POSTGRES_HOST_AUTH_METHOD: trust
    restart: always
volumes:
  vol1:
  vol2:
```

Проверка файлов:

```
docker exec -it hw0602-2 ls /var/lib/docker/volumes/vol2/_data/    
backup_1.tar  roles.sql
```

Создание базы:

```
alx@alx-laptop ~ % docker exec -it hw0602-2 psql -U postgres -c "CREATE DATABASE test_db WITH ENCODING='UTF-8';"
CREATE DATABASE
```

Восстановление базы:

```
alx@alx-laptop ~ % docker exec -it hw0602-2 psql -U postgres -f /var/lib/docker/volumes/vol2/_data/roles.sql

SET
SET
SET
CREATE ROLE
ALTER ROLE
CREATE ROLE
ALTER ROLE
CREATE ROLE
ALTER ROLE

alx@alx-laptop ~ % docker exec -it hw0602-2 pg_restore -U user -Ft -v -d test_db /var/lib/docker/volumes/vol2/_data/backup_1.tar
pg_restore: connecting to database for restore
pg_restore: creating TABLE "public.clients"
pg_restore: creating SEQUENCE "public.clients_id_seq"
pg_restore: creating SEQUENCE OWNED BY "public.clients_id_seq"
pg_restore: creating TABLE "public.orders"
pg_restore: creating SEQUENCE "public.orders_id_seq"
pg_restore: creating SEQUENCE OWNED BY "public.orders_id_seq"
pg_restore: creating DEFAULT "public.clients id"
pg_restore: creating DEFAULT "public.orders id"
pg_restore: processing data for table "public.clients"
pg_restore: processing data for table "public.orders"
pg_restore: executing SEQUENCE SET clients_id_seq
pg_restore: executing SEQUENCE SET orders_id_seq
pg_restore: creating CONSTRAINT "public.clients clients_pkey"
pg_restore: creating CONSTRAINT "public.orders orders_pkey"
pg_restore: creating FK CONSTRAINT "public.clients Order"
pg_restore: creating ACL "public.TABLE clients"
pg_restore: creating ACL "public.TABLE orders"
```
