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
    sudo apt-get update
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
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    sudo usermod -aG docker vmware
    newgrp docker
fi

# Virtualbox
# https://phoenixnap.com/kb/install-virtualbox-on-ubuntu
if ! command -v virtualbox &> /dev/null
then
    sudo apt-get install virtualbox
fi


# Minikube
# https://minikube.sigs.k8s.io/docs/start/
if ! command -v minikube &> /dev/null
then
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
fi

# Helm
# 
if ! command -v helm &> /dev/null
then
    sudo snap install helm --classic
fi

# Kubectl
# 
if ! command -v kubectl &> /dev/null
then
    sudo snap install kubectl --classic
fi
