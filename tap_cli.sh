#For Ubuntu v22.X
#Tanzu CLI, PIVNET CLI and ClusterEssential
#Require VMware Tanzu Network API Token, Download Detail

#API Token
export PIVNET_TOKEN
read -sp "Enter your token: " PIVNET_TOKEN

#Install PIVNET CLI
wget https://github.com/pivotal-cf/pivnet-cli/releases/download/v3.0.1/pivnet-linux-amd64-3.0.1
sudo install pivnet-linux-amd64-3.0.1 /usr/local/bin/pivnet

#Login Tanzu Network
pivnet login --api-token "$PIVNET_TOKEN"

#Don't forget to accept EULA before proceeding the next steps
#Tanzu Application Platform
#Cluster Essential

#Download Tanzu CLI
cd $HOME
pivnet download-product-files --product-slug='tanzu-application-platform' --release-version='1.4.0' --product-file-id=1404618

#Configure $VERSION
#a file named tanzu-framework-linux-amd64-<VERSION>.tar, where <VERSION> is the specific version of the file, for example v0.25.4.1
export VERSION=v0.25.4

#Install Tanzu CLI
# Create the tanzu directory, if it does not exist
mkdir -p $HOME/tanzu

# This assumes that you have successfully downloaded the file
# from Tanzu Network to your home directory
tar -xvf $HOME/tanzu-framework-linux-amd64-*.tar -C $HOME/tanzu

cd $HOME/tanzu
export TANZU_CLI_NO_INIT=true
sudo install cli/core/$VERSION/tanzu-core-linux_amd64 /usr/local/bin/tanzu
tanzu plugin install --local cli all

# Confirm successful installation
tanzu plugin list

#Command completion
echo 'source <(tanzu completion bash)' >> $HOME/.bashrc
source $HOME/.bashrc

