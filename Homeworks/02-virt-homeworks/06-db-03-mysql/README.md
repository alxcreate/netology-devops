# Домашнее задание к занятию "6.3. MySQL"

## Введение

Перед выполнением задания вы можете ознакомиться с
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.

В следующих заданиях мы будем продолжать работу с данным контейнером.

### Ответ

Создан контейнер через docker-compose:

```
version: "3"
services:
  mysql:
    image: mysql
    container_name: mysql
    ports:
      - "3306:3306"
    volumes:
      - /Users/alx/Documents/git/netology-devops/Homeworks/02-virt-homeworks/06-db-03-mysql/docker/volume/db
      - /Users/alx/Documents/git/netology-devops/Homeworks/02-virt-homeworks/06-db-03-mysql/docker/volume/backup
    environment:
      - MYSQL_ALLOW_EMPTY_PASSWORD=true
    restart: always
volumes:
  db:
  backup:
```

```
docker exec -it mysql bash
mysql -e 'create database test_db;'
mysql test_db < /tmp/backup/test_dump.sql
mysql

mysql> \s
--------------
mysql  Ver 8.0.30 for Linux on aarch64 (MySQL Community Server - GPL)

Connection id:  10
Current database: 
Current user:  root@localhost
SSL:   Not in use
Current pager:  stdout
Using outfile:  ''
Using delimiter: ;
Server version:  8.0.30 MySQL Community Server - GPL
Protocol version: 10
Connection:  Localhost via UNIX socket
Server characterset: utf8mb4
Db     characterset: utf8mb4
Client characterset: latin1
Conn.  characterset: latin1
UNIX socket:  /var/run/mysqld/mysqld.sock
Binary data as:  Hexadecimal
Uptime:   3 min 4 sec

Threads: 2  Questions: 38  Slow queries: 0  Opens: 139  Flush tables: 3  Open tables: 57  Queries per second avg: 0.206
--------------

```

```
mysql> connect test_db
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Connection id:    11
Current database: test_db

mysql> show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.00 sec)

mysql> select count(*) from orders where price > 300;
+----------+
| count(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)
```

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:

- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней
- количество попыток авторизации - 3
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
  - Фамилия "Pretty"
  - Имя "James"

Предоставьте привилегии пользователю `test` на операции SELECT базы `test_db`.

Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и
**приведите в ответе к задаче**.

### Ответ

```
mysql> create user 'test' identified with mysql_native_password by 'testpass'
    -> with max_queries_per_hour 100
    -> password expire interval 180 day
    -> failed_login_attempts 3
    -> attribute '{"surname": "Pretty", "name": "James"}';
Query OK, 0 rows affected (0.07 sec)

mysql> grant select on test_db.* to test;
Query OK, 0 rows affected (0.01 sec)

mysql> select * from INFORMATION_SCHEMA.USER_ATTRIBUTES;
+------------------+-----------+----------------------------------------+
| USER             | HOST      | ATTRIBUTE                              |
+------------------+-----------+----------------------------------------+
| root             | %         | NULL                                   |
| test             | %         | {"name": "James", "surname": "Pretty"} |
| mysql.infoschema | localhost | NULL                                   |
| mysql.session    | localhost | NULL                                   |
| mysql.sys        | localhost | NULL                                   |
| root             | localhost | NULL                                   |
+------------------+-----------+----------------------------------------+
6 rows in set (0.01 sec)
```

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:

- на `MyISAM`
- на `InnoDB`

### Ответ

```
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> SHOW PROFILES;
+----------+------------+-------------------+
| Query_ID | Duration   | Query             |
+----------+------------+-------------------+
|        1 | 0.00065300 | SET profiling = 1 |
+----------+------------+-------------------+
1 row in set, 1 warning (0.00 sec)
```

Используется Engine InnoDB:

```
mysql> show table status\G
*************************** 1. row ***************************
           Name: orders
         Engine: InnoDB
        Version: 10
     Row_format: Dynamic
           Rows: 5
 Avg_row_length: 3276
    Data_length: 16384
Max_data_length: 0
   Index_length: 0
      Data_free: 0
 Auto_increment: 6
    Create_time: 2022-10-09 12:22:18
    Update_time: 2022-10-09 12:22:18
     Check_time: NULL
      Collation: utf8mb4_0900_ai_ci
       Checksum: NULL
 Create_options: 
        Comment: 
1 row in set (0.00 sec)
```

Изменение Engine:

```
mysql> ALTER TABLE orders ENGINE = MyISAM;
Query OK, 5 rows affected (0.10 sec)
Records: 5  Duplicates: 0  Warnings: 0
```

Время выполнения:

```
mysql> SHOW PROFILES;
+----------+------------+-------------------------------------+
| Query_ID | Duration   | Query                               |
+----------+------------+-------------------------------------+
|        1 | 0.00065300 | SET profiling = 1                   |
|        3 | 0.09222100 | ALTER TABLE orders ENGINE = MyISAM  |
+----------+------------+-------------------------------------+
3 rows in set, 1 warning (0.01 sec)
```

## Задача 4

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):

- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

### Ответ

```
[mysqld]
# Скорость IO важнее сохранности данных
innodb_flush_log_at_trx_commit = 0 
# Нужна компрессия таблиц для экономии места на диске
innodb_file_per_table = 1
innodb_file_format = Barracuda
# Размер буффера с незакомиченными транзакциями 1 Мб
innodb_log_buffer_size = 1
# Буффер кеширования 30% от ОЗУ
innodb_buffer_pool_size = 4096M
# Размер файла логов операций 100 Мб
innodb_log_file_size = 100M

# log_bin
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M
# default-authentication-plugin=mysql_native_password
skip-host-cache
skip-name-resolve
datadir=/var/lib/mysql
socket=/var/run/mysqld/mysqld.sock
secure-file-priv=/var/lib/mysql-files
user=mysql

pid-file=/var/run/mysqld/mysqld.pid
[client]
socket=/var/run/mysqld/mysqld.sock

!includedir /etc/mysql/conf.d/
```
