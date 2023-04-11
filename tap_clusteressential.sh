#Download Cluster Essential
cd $HOME
pivnet download-product-files --product-slug='tanzu-cluster-essentials' --release-version='1.4.0' --product-file-id=1407185

# Unpack the tar file

mkdir $HOME/tanzu-cluster-essentials
tar -xvf $HOME/tanzu-cluster-essentials-linux-amd64-1.4.0.tgz -C $HOME/tanzu-cluster-essentials

# Set Kubernetes cluster context
# (Not necessary as there is only one context, but shown here for completeness)
#kubectl config get-contexts
#kubectl config use-context kubernetes-admin@kubernetes

# Deploy onto cluster
# (Optional steps to add a custom certificate)

kubectl create namespace kapp-controller

kubectl create secret generic kapp-controller-config \
  --namespace kapp-controller \
  --from-file caCerts=/usr/local/share/ca-certificates/harbor.crt

# Configure and run install.sh (online installation)

export INSTALL_BUNDLE=registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:5fd527dda8af0e4c25c427e5659559a2ff9b283f6655a335ae08357ff63b8e7f
export INSTALL_REGISTRY_HOSTNAME=registry.tanzu.vmware.com

# Note that these are the Tanzu Network username and password
# used to log in to the Tanzu Network website, NOT the value
# of the token used with pivnet

read -p "Tanzu Network Username: " INSTALL_REGISTRY_USERNAME
export INSTALL_REGISTRY_USERNAME
read -rsp "Tanzu Network Password: " INSTALL_REGISTRY_PASSWORD
export INSTALL_REGISTRY_PASSWORD

cd $HOME/tanzu-cluster-essentials
./install.sh --yes

# Install the CLIs

sudo cp $HOME/tanzu-cluster-essentials/kapp /usr/local/bin/kapp
sudo cp $HOME/tanzu-cluster-essentials/imgpkg /usr/local/bin/imgpkg
