# Остановить выполнение в случае ошибки
set -e

# Включение файла с переменными
source variables.sh

# Запуск скриптов установки
bash infrastructure.sh
bash monitoring.sh
bash image.sh