#Harbor v2.7.0
#https://goharbor.io/docs/2.7.0/install-config/installation-prereqs/
#sudo snap install curl
#curl -LO {this file URL}

# SSH
# https://www.cyberciti.biz/faq/ubuntu-linux-install-openssh-server/
if ! service --status-all | grep -Fq 'ssh'
then
    sudo apt update
    sudo apt-get install openssh-server -y
    sudo systemctl enable ssh
    sudo systemctl enable ssh --now
    sudo systemctl start ssh
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
fi

#Download and extract Harbor
curl -LO https://github.com/goharbor/harbor/releases/download/v2.7.1/harbor-offline-installer-v2.7.1.tgz
tar zxvf harbor-offline-installer-*.tgz

#Copy server certificate and private key into $HOME/data/cert/
#Modify harbor.yml poinint to above location and update the domain name
#sudo ./install.sh


