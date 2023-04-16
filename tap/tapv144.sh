# Assuming Minikube is single node
# Configuring harbor.hlab.uk in /etc/hosts
export MASTER_IP=$(minikube ip)
export HARBOR_IP=harbor.hlab.uk
export TANZUNETWORK_USERNAME
read -p "Enter your Tanzu Network Username: " TANZUNETWORK_USERNAME
export TANZUNETWORK_PASSWORD
read -p "Enter your Tanzu Network Password: " TANZUNETWORK_PASSWORD

# The version of TAP being installed
export TAP_VERSION="1.4.4"

# These values correspond to the Harbor registry set up on
# the 'harbor' machine
export INSTALL_REGISTRY_HOSTNAME="$HARBOR_IP"
export INSTALL_REGISTRY_USERNAME=admin
export INSTALL_REGISTRY_PASSWORD=Harbor12345
export INSTALL_REPO=library

# This is the address that the TAP installation will
# use to expose all services
export INGRESS_DOMAIN="$MASTER_IP.nip.io"

# Log in to self Harbor and the VMware Tanzu Network Registry
docker login $INSTALL_REGISTRY_HOSTNAME -u "$INSTALL_REGISTRY_USERNAME" -p "$INSTALL_REGISTRY_PASSWORD"
docker login registry.tanzu.vmware.com -u "$TANZUNETWORK_USERNAME" -p "$TANZUNETWORK_PASSWORD"

imgpkg copy -b registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:${TAP_VERSION} \
    --to-repo ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REPO}/tap-packages
