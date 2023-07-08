helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo add stable https://charts.helm.sh/stable

helm repo add grafana https://grafana.github.io/helm-charts

helm repo update

cd /builds/Janortop5/capstone-microservices-demo-watchn/deploy/kubernetes/

helmfile apply

kubectl config set-context --current --namespace default

helm install prometheus prometheus-community/kube-prometheus-stack

helm install loki grafana/loki-stack --namespace loki --create-namespace --set grafana.enabled=true --set loki.isDefault=false

kubectl get secret --namespace loki loki-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

cd /builds/Janortop5/capstone-microservices-demo-watchn/capstone-deploy/kubernetes/monitoring/

kubectl apply -f assets-service-monitor.yml && kubectl apply -f catalog-service-monitor.yml && kubectl apply -f catalog-service-monitor.yml && kubectl apply -f orders-service-monitor.yml && kubectl apply -f carts-service-monitor.yml && kubectl apply -f checkout-service-monitor.yml && kubectl apply -f prometheus-grafana-service.yml && kubectl apply -f prometheus-service.yml

cd /builds/Janortop5/capstone-microservices-demo-watchn/capstone-deploy/kubernetes/

kubectl apply -f loki-service.yml
