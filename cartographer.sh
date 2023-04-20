# Carvel Tools
# https://carvel.dev/kapp/docs/v0.54.0/install/
wget -O- https://carvel.dev/install.sh > install.sh

# Inspect install.sh before running...
sudo bash install.sh
kapp version

# Cert-Manager v1.5.3
# https://cartographer.sh/docs/v0.0.7/install/
export CERT_MANAGER_VERSION=1.5.3
kapp deploy --yes -a cert-manager \
	-f https://github.com/jetstack/cert-manager/releases/download/v$CERT_MANAGER_VERSION/cert-manager.yaml
  
# Cartographer
# https://github.com/vmware-tanzu/cartographer#installation
kubectl create namespace cartographer-system
kubectl apply -f https://github.com/vmware-tanzu/cartographer/releases/latest/download/cartographer.yaml
