# Preparing credentials and setting environmental variables
# vincentc2@vmware.com
export PIVNET_TOKEN
read -sp "Enter your token: " PIVNET_TOKEN

# Installing Pivnet CLI
# https://github.com/pivotal-cf/pivnet-cli
# https://github.com/pivotal-cf/pivnet-cli/releases/tag/v3.0.1
wget https://github.com/pivotal-cf/pivnet-cli/releases/download/v3.0.1/pivnet-linux-amd64-3.0.1
sudo install pivnet-linux-amd64-3.0.1 /usr/local/bin/pivnet

# Login Tanzu Network - https://network.pivotal.io
pivnet login --api-token "$PIVNET_TOKEN"

# Accept EULAs in Tanzu Application Platform and Cluster Essential

# Install Tanzu CLI and plugins
pivnet download-product-files --product-slug='tanzu-application-platform' --release-version='1.4.4' --product-file-id=1457672


