CLUSTER_ID=$(yc k8s cluster list --format json | grep -o '"id": "[^"]*' | awk -F': "' '{print $2}' | tail -n 1)
yc managed-kubernetes cluster get-credentials --id $CLUSTER_ID --external

kubectl apply --server-side -f kube-prometheus/manifests/setup
until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done
kubectl apply -f kube-prometheus/manifests/

kubectl apply -f add-deployment.yaml
kubectl apply -f app-service.yaml
