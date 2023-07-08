git clone --branch v1.0.0 https://github.com/nonai/k8s-example-files.git
kubectl apply -f k8s-example-files/metrics-server/.
kubectl get pods -n kube-system
sleep 20
kubectl get apiservice |grep -i metrics
kubectl get svc -n kube-system
kubectl top pods -n kube-system
git clone https://github.com/kubernetes/autoscaler.git
cd autoscaler/
git checkout bb860357f691313fca499e973a5241747c2e38b2
cd vertical-pod-autoscaler
./hack/vpa-process-yamls.sh print
./hack/vpa-up.sh
cd ../..
kubectl apply -f vpa-auto-mode.yml
