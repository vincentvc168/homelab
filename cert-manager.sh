# https://cert-manager.io/docs/tutorials/acme/nginx-ingress/
# https://kubebyexample.com/learning-paths/metallb/install/
# minikube addons enable metallb
# minikube profile list
# minikube ip

# Using above minikube ip range as reference such as 192.168.49.10 to 192.168.49.20
echo "Using above minikube ip range as reference such as 192.168.49.10 to 192.168.49.20"
minikube addons configure metallb


helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install quickstart ingress-nginx/ingress-nginx
