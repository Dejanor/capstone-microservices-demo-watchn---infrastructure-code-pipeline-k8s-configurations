helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo add stable https://charts.helm.sh/stable

helm repo add grafana https://grafana.github.io/helm-charts

helm repo update

helmfile apply

kubectl config set-context --current --namespace default

helm install prometheus prometheus-community/kube-prometheus-stack

helm install loki grafana/loki-stack --namespace loki --create-namespace --set grafana.enabled=true --set loki.isDefault=false

kubectl get secret --namespace loki loki-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

kubectl apply -f loki-ingress.yml

kubectl apply -f ui-ingress.yml

kubectl apply -f carts-service-monitor.yml && kubectl apply -f catalogue-service-monitor.yml && kubectl apply -f front-end-service-monitor.yml && kubectl apply -f orders-service-monitor.yml && kubectl apply -f payment-service-monitor.yml && kubectl apply -f queue-master-service-monitor.yml && kubectl apply -f rabbitmq-service-monitor.yml && kubectl apply -f shipping-service-monitor.yml && kubectl apply -f user-service-monitor.yml

kubectl apply -f prometheus-grafana-ingress.yml
