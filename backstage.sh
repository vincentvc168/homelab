cd $HOME

# Installing GIT
sudo apt-get update -y
sudo apt-get install git-all -y

# Installing NVM for NodeJS
# https://github.com/nvm-sh/nvm#install--update-script
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
source ~/.bashrc

# Installing NodeJS
nvm install 18.0.0

# Installing YARN
npm install --global yarn

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

