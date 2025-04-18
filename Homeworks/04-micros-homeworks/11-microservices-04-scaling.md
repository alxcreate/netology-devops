
# Домашнее задание к занятию "Микросервисы: масштабирование"

Вы работаете в крупной компанию, которая строит систему на основе микросервисной архитектуры.
Вам как DevOps специалисту необходимо выдвинуть предложение по организации инфраструктуры, для разработки и эксплуатации.

## Задача 1: Кластеризация

Предложите решение для обеспечения развертывания, запуска и управления приложениями.
Решение может состоять из одного или нескольких программных продуктов и должно описывать способы и принципы их взаимодействия.

Решение должно соответствовать следующим требованиям:

- Поддержка контейнеров;
- Обеспечивать обнаружение сервисов и маршрутизацию запросов;
- Обеспечивать возможность горизонтального масштабирования;
- Обеспечивать возможность автоматического масштабирования;
- Обеспечивать явное разделение ресурсов доступных извне и внутри системы;
- Обеспечивать возможность конфигурировать приложения с помощью переменных среды, в том числе с возможностью безопасного хранения чувствительных данных таких как пароли, ключи доступа, ключи шифрования и т.п.

Обоснуйте свой выбор.

## Ответ

Для решения описанных требований можно использовать платформу управления контейнерами Kubernetes. Kubernetes позволяет легко разворачивать и масштабировать приложения в контейнерах, а также обеспечивает управление ресурсами, автоматическое масштабирование и разделение доступа.

Для обнаружения сервисов и маршрутизации запросов можно использовать Kubernetes Service и Ingress. Service обеспечивает доступ к сервисам внутри кластера, а Ingress позволяет маршрутизировать входящие запросы к сервисам на основе различных правил.

Для горизонтального масштабирования Kubernetes использует горизонтальное масштабирование ReplicaSet и горизонтальное автомасштабирование Horizontal Pod Autoscaler (HPA). ReplicaSet позволяет управлять количеством экземпляров контейнеров в кластере, а HPA позволяет автоматически масштабировать количество экземпляров контейнеров на основе метрик нагрузки.

Для конфигурирования приложений можно использовать Kubernetes ConfigMap и Secrets. ConfigMap позволяет хранить настройки конфигурации приложений, такие как параметры подключения к базе данных, в виде ключ-значение. Secrets позволяет хранить чувствительную информацию, такую как пароли, ключи доступа и т.п., в зашифрованном виде.

## Задача 2: Распределенный кэш * (необязательная)

Разработчикам вашей компании понадобился распределенный кэш для организации хранения временной информации по сессиям пользователей.
Вам необходимо построить Redis Cluster состоящий из трех шард с тремя репликами.

### Схема

![11-04-01](https://user-images.githubusercontent.com/1122523/114282923-9b16f900-9a4f-11eb-80aa-61ed09725760.png)

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
