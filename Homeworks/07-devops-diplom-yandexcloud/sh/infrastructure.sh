echo -e "\nПолучение конфигурации kubernetes ************************************"

# Получение ID кластера kubernetes
CLUSTER_ID=$(yc k8s cluster list --format json | grep -o '"id": "[^"]*' | awk -F': "' '{print $2}' | tail -n 1)

# Получение конфигурации для управления кластером kubernetes
yc managed-kubernetes cluster get-credentials --id $CLUSTER_ID --external

# Получение данных о подах
kubectl get pods --all-namespaces