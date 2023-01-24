## Описание playbook:
Playbook выполняет загрузку и установку Clickhouse. Запускает сервис clickhouse-server и создает базу данных.
Скачивает и устанавливает Vector. Изменяет конфигурацию для дальнейшей работы.
Копирует файлы Lighthouse из репозитория, изменяет конфигурацию и запускает сервис.

Используемые параметры:
- name
- hosts
- tasks
- block
- ansible.builtin.get_url
- url
- dest
- with_items
- check_mode
- rescue
- become
- ansible.builtin.yum
- disable_gpg_check
- notify
- ansible.builtin.meta
- ansible.builtin.command
- register
- failed_when
- changed_when
- handlers
- ansible.builtin.service
- state
- ansible.builtin.template
- mode
- validate
- owner
- group
- daemon_reload
- command
- pre_tasks
- git
- repo
- version

Теги не были использованы.
