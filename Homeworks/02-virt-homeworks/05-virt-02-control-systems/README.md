
# Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"

## Задача 1

- Опишите своими словами основные преимущества применения на практике IaaC паттернов.
- Какой из принципов IaaC является основополагающим?

### Ответ
Преимущества применения IaaC - быстрое развертывание инфраструктуры для разработки, тестирования и масштабирования. Возможность быстро вернуть необходимое состояние тестовой среды.
Основополагающий принцип - инфраструктура предоставляется в виде кода который при выполнении будет выдавать одинаковый результат выполняя свойство идемпотентности.

## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?
- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

### Ответ
Главное отличие Ansible от других систем - не требуется установка агентов. Используется существующее SSH инфраструктура.
На мой взгляд, метод pull более надежный потому как агент выполняет проверку соответствия самостоятельно в соответствии с данными о сервере.

## Задача 3

Установить на личный компьютер:

- VirtualBox
- Vagrant
- Ansible

*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*

### Ответ

```
alx@linux:~$ VBoxManage -version
6.1.34_Ubuntur150636

alx@linux:~$ vagrant --version
Vagrant 2.2.19

alx@linux:~$ ansible --version
ansible 2.10.8
```

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

- Создать виртуальную машину.
- Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды
```
docker ps
```

### Ответ

```
alx@linux:/media/alx/vm/vagrant$ vagrant ssh
Welcome to Ubuntu 22.04 LTS (GNU/Linux 5.15.0-30-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sun Sep  4 08:59:41 AM UTC 2022

  System load:  0.189453125        Users logged in:          0
  Usage of /:   13.3% of 30.34GB   IPv4 address for docker0: 172.17.0.1
  Memory usage: 24%                IPv4 address for eth0:    10.0.2.15
  Swap usage:   0%                 IPv4 address for eth1:    192.168.56.11
  Processes:    100


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Sun Sep  4 08:57:34 2022 from 10.0.2.2
vagrant@server1:~$ hostname
server1
vagrant@server1:~$ docker --version
Docker version 20.10.17, build 100c701
```
