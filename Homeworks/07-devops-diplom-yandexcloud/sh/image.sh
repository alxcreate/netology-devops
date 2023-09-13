echo -e "\nСоздание образа приложения *******************************************"

cd ../app-docker
docker build -t alxcreate/app -f Dockerfile .

echo -e "\nЗагрузка образа на hub.docker.com ************************************"

docker push alxcreate/app
cd ../sh
