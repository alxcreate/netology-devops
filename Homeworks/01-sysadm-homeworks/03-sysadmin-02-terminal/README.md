# Домашнее задание по лекции "Работа в терминале (лекция 2)"

> 1. Какого типа команда cd? Попробуйте объяснить, почему она именно такого типа; опишите ход своих мыслей, если считаете что она могла бы быть другого типа.

Команда cd - встроенная. Она такого типа потому что меняется директория в текущем окружении для выполнения последующих команд. Остальные типы команд выполняются в новом окружении.

---
>
> 2. Какая альтернатива без pipe команде grep <some_string> <some_file> | wc -l? man grep поможет в ответе на этот вопрос. Ознакомьтесь с документом о других подобных некорректных вариантах использования pipe.

    vagrant@vagrant:~$ cat test
    asd
    asdfdsa
    fdsaasdeqwq
    vagrant@vagrant:~$ grep asd test | wc -l
    3
    vagrant@vagrant:~$ grep asd test -c
    3

---
>
> 3. Какой процесс с PID 1 является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?

Родителем для всех процессов является systemd.

    vagrant@vagrant:~$ pstree -p
    systemd(1)─┬─VGAuthService(737)
           ├─accounts-daemon(829)─┬─{accounts-daemon}(834)
           │                      └─{accounts-daemon}(888)
           ├─agetty(865)

---
>
> 4. Как будет выглядеть команда, которая перенаправит вывод stderr ls на другую сессию терминала?

Команда

    vagrant@vagrant:~$ ls -l \root 2>/dev/pts/1
выводит в другой сессии

    vagrant@vagrant:~$ ls: cannot access 'root': No such file or directory

---
>
> 5. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример.

    vagrant@vagrant:~$ ls
    test
    vagrant@vagrant:~$ cat test
    Some text
    vagrant@vagrant:~$ cat <test>test2
    vagrant@vagrant:~$ cat test2
    Some text
    vagrant@vagrant:~$ ls
    test  test2

---
>
> 6. Получится ли находясь в графическом режиме, вывести данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?

Вывести данные из pty в tty можно используя перенаправление. Вывод можно наблюдать только в соответствующем tty.

---
>
> 7. Выполните команду bash 5>&1. К чему она приведет? Что будет, если вы выполните echo netology > /proc/$$/fd/5? Почему так происходит?

Команда

    bash 5>&1
создает дескриптор 5 и назначает вывод в stdout.
Команда

    echo netology > /proc/$$/fd/5
перенаправит вывод echo в дескриптор 5 который переводит в stdout.

---
>
> 8. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty? Напоминаем: по умолчанию через pipe передается только stdout команды слева от | на stdin команды справа. Это можно сделать, поменяв стандартные потоки местами через промежуточный новый дескриптор, который вы научились создавать в предыдущем вопросе.

    vagrant@vagrant:~$ cd /root 3>&2 2>&1 1>&3 | grep denied -c
    1

---
>
> 9. Что выведет команда cat /proc/$$/environ? Как еще можно получить аналогичный по содержанию вывод?

Команда выводит переменные окружения. Аналогичный вывод по содержанию можно получить командой env.

---
>
> 10. Используя man, опишите что доступно по адресам /proc/\<PID>/cmdline, /proc/\<PID>/exe.

/proc/\<PID>/cmdline - файл только для чтения содержащий полный путь файла исполняемого процесса исключая зомби-процессы.

/proc/\<PID>/exe - файл представляет собой символическую ссылку, содержащую фактический путь к выполняемой команде.

---
>
> 11. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью /proc/cpuinfo.

Версия 4.2

---
>
> 12. При открытии нового окна терминала и vagrant ssh создается новая сессия и выделяется pty. Это можно подтвердить командой tty, которая упоминалась в лекции 3.2. Однако:

        vagrant@netology1:~$ ssh localhost 'tty'
        not a tty
Почитайте, почему так происходит, и как изменить поведение.

При выполнении удаленной команды с помощью ssh tty не выделяется. При запуске ssh без удаленной команды выделяется tty. Если необходим вызов выделения tty при удаленном выполнении, то используется ssh -t.

---
>
> 13. Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись reptyr. Например, так можно перенести в screen процесс, который вы запустили по ошибке в обычной SSH-сессии.

    /etc/sysctl.d/10-ptrace.conf
    kernel.yama.ptrace_scope = 0

    vagrant@vagrant:~$ ps ax | grep ping
       1558 pts/2    S+     0:00 ping google.com -c 1000
       1560 pts/1    S+     0:00 grep --color=auto ping
    vagrant@vagrant:~$ reptyr 1558 -T
    64 bytes from bud02s21-in-f174.1e100.net (216.58.209.174): icmp_seq=18 ttl=113 time=60.9 ms
    64 bytes from bud02s21-in-f174.1e100.net (216.58.209.174): icmp_seq=19 ttl=113 time=61.4 ms

---
>
> 14. sudo echo string > /root/new_file не даст выполнить перенаправление под обычным пользователем, так как перенаправлением занимается процесс shell'а, который запущен без sudo под вашим пользователем. Для решения данной проблемы можно использовать конструкцию echo string | sudo tee /root/new_file. Узнайте что делает команда tee и почему в отличие от sudo echo команда с sudo tee будет работать.

Команда echo выполняет вывод в stdout. Команда tee копирует ввод в каждый указанный файл и в stdout. Команда echo string | sudo tee /root/new_file будет выполнена т.к. запись в файл выполняется с sudo.
