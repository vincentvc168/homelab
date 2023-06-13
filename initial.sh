#VMware Workstation Snapshot Restoration Networking Bug
# nmcli networking off
# nmcli networking on

# Target Ubuntu 22.x Desktop Edition
sudo apt install curl -y

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

if ! command -v kontena-lens &> /dev/null
then
    sudo snap install kontena-lens --classic
fi

# Virtualbox
# https://phoenixnap.com/kb/install-virtualbox-on-ubuntu
if ! command -v virtualbox &> /dev/null
then
    sudo apt-get install virtualbox -y
fi


# Minikube
# https://minikube.sigs.k8s.io/docs/start/
if ! command -v minikube &> /dev/null
then
    sudo curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
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

# TAP Hardware Requirement https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.4/tap/prerequisites.html
# Full Profile - 16GB Ram, 8 vCPU, 100GB Disk
# minikube start --driver=virtualbox --memory 28672 --cpus 12 --disk-size="150000mb" --kubernetes-version=v1.25.8
# minikube start --driver=virtualbox --memory 28672 --cpus 12 --disk-size="150000mb" --extra-config=kubelet.cgroup-driver=systemd --kubernetes-version=v1.25.8
