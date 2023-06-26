kubectl config set-context --current --namespace default
helm install prometheus prometheus-community/kube-prometheus-stack
