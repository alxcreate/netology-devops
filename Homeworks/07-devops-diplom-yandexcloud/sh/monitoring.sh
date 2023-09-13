#echo -e "\nСоздание контейнеров Prometheus **************************************"
# Создание подов prometheus
#kubectl apply --filename ../kubernetes/prometheus-configmap.yaml
#kubectl apply --filename ../kubernetes/prometheus-deployment.yaml

echo -e "\nУстановка Prometheus и Grafana ***************************************"
kubectl apply --server-side -f ../kubernetes/kube-prometheus/manifests/setup
until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done
kubectl apply -f ../kubernetes/kube-prometheus/manifests/
kubectl apply -f ../kubernetes/grafana-service.yaml
kubectl apply -f ../kubernetes/grafana-networkpolicy.yaml
