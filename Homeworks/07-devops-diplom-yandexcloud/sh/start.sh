echo -e "\nПолучение конфигурации kubernetes ************************************"
# Получение ID кластера kubernetes
CLUSTER_ID=$(yc k8s cluster list --format json | grep -o '"id": "[^"]*' | awk -F': "' '{print $2}' | tail -n 1)
# Получение конфигурации для управления кластером kubernetes
yc managed-kubernetes cluster get-credentials --id $CLUSTER_ID --external
# Получение данных о подах
kubectl get pods --all-namespaces

echo -e "\nУстановка Prometheus и Grafana ***************************************"
kubectl apply --server-side -f ../kubernetes-conf/kube-prometheus/manifests/setup
until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done
kubectl apply -f ../kubernetes-conf/kube-prometheus/manifests/
#kubectl apply -f ../kubernetes-conf/grafana-service.yaml
#kubectl apply -f ../kubernetes-conf/grafana-networkpolicy.yaml

echo -e "\nСоздание образа приложения *******************************************"
cd ../app-docker
docker build -t alxcreate/app -f Dockerfile .

echo -e "\nЗагрузка образа на hub.docker.com ************************************"
docker push alxcreate/app
cd ../sh

echo -e "\nУстановка app ********************************************************"
kubectl apply -f ../kubernetes-conf/add-deployment.yaml
kubectl apply -f ../kubernetes-conf/app-service.yaml
