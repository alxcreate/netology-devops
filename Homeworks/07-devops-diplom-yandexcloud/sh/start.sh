# Остановить выполнение в случае ошибки
set -e

# Включение файла с переменными
source variables.sh

bash infrastructure.sh
bash monitoring.sh
bash image.sh