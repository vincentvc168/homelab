# https://cert-manager.io/docs/tutorials/acme/nginx-ingress/

minikube start
minikube addons enable metallb
minikube ip

# Using above minikube ip range as reference such as 192.168.49.10 to 192.168.49.20
echo "Using above minikube ip range as reference such as 192.168.49.10 to 192.168.49.20"
minikube addons configure metallb


helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install quickstart ingress-nginx/ingress-nginx
