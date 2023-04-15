# If you are using Minikube, make sure Metallb is ready if you are using Loadbalancer service object.
# The script is using Online Installation Approach - https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/1.4/cluster-essentials/deploy.html

# Preparing credentials and setting environmental variables
# vincentc2@vmware.com
cd $HOME
#export PIVNET_TOKEN={Your Tanzu Network UAA API Token}
export PIVNET_TOKEN
read -p "Enter your token: " PIVNET_TOKEN
export INSTALL_REGISTRY_USERNAME
read -p "Enter your Tanzu Network Username: " INSTALL_REGISTRY_USERNAME
export INSTALL_REGISTRY_PASSWORD
read -p "Enter your Tanzu Network Password: " INSTALL_REGISTRY_PASSWORD
export INSTALL_BUNDLE=registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:2354688e46d4bb4060f74fca069513c9b42ffa17a0a6d5b0dbb81ed52242ea44
export INSTALL_REGISTRY_HOSTNAME=registry.tanzu.vmware.com

# Installing Pivnet CLI
# https://github.com/pivotal-cf/pivnet-cli
# https://github.com/pivotal-cf/pivnet-cli/releases/tag/v3.0.1
if ! command -v pivnet &> /dev/null
then
  wget https://github.com/pivotal-cf/pivnet-cli/releases/download/v3.0.1/pivnet-linux-amd64-3.0.1
  sudo install pivnet-linux-amd64-3.0.1 /usr/local/bin/pivnet
fi

if ! command -v tanzu &> /dev/null
then
  # Login Tanzu Network - https://network.pivotal.io
  pivnet login --api-token "$PIVNET_TOKEN"

  # Accept EULAs in Tanzu Application Platform and Cluster Essential

  # Installing Tanzu CLI and plugins
  # Finding the following command in Tanzu Network Portal
  pivnet download-product-files --product-slug='tanzu-application-platform' --release-version='1.4.4' --product-file-id=1457672

  # Create the tanzu directory, if it does not exist
  mkdir -p $HOME/tanzu

  # This assumes that you have successfully downloaded the file
  # from Tanzu Network to your home directory
  tar -xvf $HOME/tanzu-framework-linux-amd64-*.tar -C $HOME/tanzu

  cd $HOME/tanzu
  export TANZU_CLI_NO_INIT=true
  export VERSION=v0.25.4
  sudo install cli/core/$VERSION/tanzu-core-linux_amd64 /usr/local/bin/tanzu
  tanzu plugin install --local cli all

  # Confirm successful installation
  tanzu plugin list
fi

# Deploying the Cluster Essentials
cd $HOME
if ! command -v kapp &> /dev/null
then
  pivnet download-product-files --product-slug='tanzu-cluster-essentials' --release-version='1.4.1' --product-file-id=1423994

  # if your Harbor is using self-signed certificate, please prepare the harbor.crt by https://github.com/vincentvc168/homelab/blob/main/getcert_importcert.sh

  # Unpack the TAR file into the tanzu-cluster-essentials
  # https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/1.4/cluster-essentials/deploy.html
  mkdir $HOME/tanzu-cluster-essentials
  tar -xvf tanzu-cluster-essentials-linux-amd64-*.tgz -C $HOME/tanzu-cluster-essentials
  cd $HOME/tanzu-cluster-essentials
  ./install.sh --yes

  # Install the CLIs
  sudo cp $HOME/tanzu-cluster-essentials/kapp /usr/local/bin/kapp
  sudo cp $HOME/tanzu-cluster-essentials/imgpkg /usr/local/bin/imgpkg

  # Command completion
  echo 'source <(tanzu completion bash)' >> $HOME/.bashrc
  source $HOME/.bashrc
fi
