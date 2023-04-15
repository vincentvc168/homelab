# Preparing credentials and setting environmental variables
# vincentc2@vmware.com
cd $HOME
export PIVNET_TOKEN={Your Tanzu Network UAA API Token}
# export PIVNET_TOKEN
# read -sp "Enter your token: " PIVNET_TOKEN

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


