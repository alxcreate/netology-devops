
# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

---

## Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на <https://hub.docker.com>;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:

```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```

Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на <https://hub.docker.com/username_repo>.

### Ответ

<https://hub.docker.com/repository/docker/alxaustralia/nginx>

## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

Сценарий:

- Высоконагруженное монолитное java веб-приложение;
- Nodejs веб-приложение;
- Мобильное приложение c версиями для Android и iOS;
- Шина данных на базе Apache Kafka;
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
- Мониторинг-стек на базе Prometheus и Grafana;
- MongoDB, как основное хранилище данных для java-приложения;
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

### Ответ

- Высоконагруженное монолитное java веб-приложение;
Нет необходимости использовать Docker потому как JVM, насколько мне известно, выполняет достаточную изоляцию приложения. Для уменьшения задержек можно использовать физический кластер.

- Nodejs веб-приложение;
Для быстрого тестирования и публикации кода было бы удобно использовать контейнеры.

- Мобильное приложение c версиями для Android и iOS;
Наверное, без Docker.

- Шина данных на базе Apache Kafka;
Без Docker для уменьшения сетевых задержек.

- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
Нет необходимости использования контейнеров, потому как установка будет выполнена один раз.

- Мониторинг-стек на базе Prometheus и Grafana;
Аналогично не требуется установка Docker. Система устанавливается один раз.

- MongoDB, как основное хранилище данных для java-приложения;
При использовании Docker придется выносить из него данные. Выше сетевые задержки.

- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.
Не знаю как работают эти сервисы на низком уровне. Установил бы на виртуальную машину чтобы не усложнять инфраструктуру.

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

### Ответ

```
alx@alx-laptop docker % docker run -v /Users/alx/Documents/data:/data -it debian
root@5d7bc1393785:/# ls data
file.txt  file2.txt

alx@alx-laptop docker % docker run -v /Users/alx/Documents/data:/data -it centos
[root@13766db14759 /]# ls data
file.txt  file2.txt
```
