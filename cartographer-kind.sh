# Visual Studio Code
# https://code.visualstudio.com/docs/setup/linux
if ! command -v code &> /dev/null
then
    sudo apt-get install wget gpg -y
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    sudo apt install apt-transport-https -y
    sudo apt update -y
    sudo apt install code -y # or code-insiders
fi

# Docker
# https://docs.docker.com/engine/install/ubuntu/
if ! command -v docker &> /dev/null
then
    sudo apt-get update -y
    sudo apt-get install \
        ca-certificates \
        curl \
        gnupg \
        lsb-release -y
    sudo mkdir -m 0755 -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -y
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

    #sudo usermod -aG docker vmware
    sudo usermod -aG docker $(whoami)
    newgrp docker
    exit
fi

# Kind
# https://kind.sigs.k8s.io/docs/user/quick-start/#installation
if ! command -v kind &> /dev/null
then
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.18.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
fi

# Carvel Tools
# https://carvel.dev/kapp/docs/v0.54.0/install/
wget -O- https://carvel.dev/install.sh > install.sh

# Inspect install.sh before running...
sudo bash install.sh

# Cartographer with Cluster
# https://cartographer.sh/docs/development/tutorials/first-supply-chain/
cd $HOME
git clone https://github.com/vmware-tanzu/cartographer.git
cd cartographer
./hacker/setup.sh cluster cartographer-latest
# ./hacker/setup.sh teardown
