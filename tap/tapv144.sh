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
    
 Create the namespace
kubectl create ns tap-install

# Create a secret with the Harbor registry credentials
tanzu secret registry add tap-registry \
    --username ${INSTALL_REGISTRY_USERNAME} --password ${INSTALL_REGISTRY_PASSWORD} \
    --server ${INSTALL_REGISTRY_HOSTNAME} \
    --export-to-all-namespaces --yes --namespace tap-install

# Add the TAP package repository to the cluster.
# This now refers to your Harbor registry where the packages
# have been relocated.
tanzu package repository add tanzu-tap-repository \
    --url ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REPO}/tap-packages:$TAP_VERSION \
    --namespace tap-install

# Check the status of the package repository
tanzu package repository get tanzu-tap-repository --namespace tap-install

# List the available packages
tanzu package available list --namespace tap-install

# https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.4/tap/install.html#install-your-tanzu-application-platform-profile-2
cat <<EOF>$HOME/tap-values-template.yaml
profile: full

shared:
  # ca_cert_data: "${CA_CERT}"
  ## openssl s_client -connect $HARBOR_HOST:443 < /dev/null 2> /dev/null | \
  ## openssl x509 | \
  ## sed -ne '/BEGIN CERT/,/END CERT/p' > ~/harbor.crt
  ## export CA_CERT=$(sed -e ':X; N; $!bX; s/\n/\\n/g; s/$/\\n/' < ~/harbor.crt)
  ## echo $CA_CERT
  ingress_domain: "${INGRESS_DOMAIN}"
  image_registry:
    project_path: ${HARBOR_IP}/library"
    username: "admin"
    password: "Harbor12345"
  
ceip_policy_disclosed: true

# The lab environment does not have a load balancer capability
# so you must configure Contour to use a NodePort
contour:
  envoy:
    service:
      type: NodePort
      nodePorts:
          http: 31080
          https: 31443

# The following packages will not be installed in the lab
# * image-policy-webhook is deprecated
# * learningcenter is not needed and is resource heavy
excluded_packages:
  - image-policy-webhook.signing.apps.tanzu.vmware.com
  - learningcenter.tanzu.vmware.com
  - workshops.learningcenter.tanzu.vmware.com
EOF

# Tanzu CLI does not support $Variable
envsubst < $HOME/tap-values-template.yaml > $HOME/tap-values.yaml

# Installing the TAP packages
tanzu package install tap -p tap.tanzu.vmware.com -v $TAP_VERSION --values-file $HOME/tap-values.yaml -n tap-install

# Validation
# tanzu package installed get tap -n tap-install
# tanzu package installed list -n tap-install
# curl -vkL http://tap-gui.${INGRESS_DOMAIN}:31080

# Troubleshooting
# tanzu package installed update tap -n tap-install -f $HOME/tap-values.yaml
# tanzu package installed delete tap -n tap-install
