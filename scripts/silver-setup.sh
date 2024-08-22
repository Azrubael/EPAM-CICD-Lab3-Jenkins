#!/bin/bash

LINE='========================='
JENKINS_PATH='/opt/jenkins-silver'
SSH_PATH="/home/silver/.ssh"
KEY_PATH="${SSH_PATH}/merlin_key.pub"
AUTHORIZED_KEYS_PATH="${SSH_PATH}/authorized_keys"
TMP_KEY='/tmp/mkey.pub'

sudo apt-get update
sudo apt-get install zip unzip fontconfig mc -y
echo $LINE
echo "I          MC           I"
echo $LINE

sudo apt-get install openjdk-17-jdk -y
if java -version &> /dev/null; then
    echo $LINE
    echo "I        JDK 17         I"
    echo $LINE
    sudo apt-get install maven -y
else
    echo "---------- Java not installed ----------"
    exit 1
fi

if mvn -v &> /dev/null; then
    echo $LINE
    echo "I         Maven         I"
    echo $LINE
else
    echo "---------- Maven not installed ----------"
fi


### Docker Engine installation
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

if docker version &> /dev/null; then
    echo $LINE
    echo "I        Docker         I"
    echo $LINE
    sudo usermod -aG docker vagrant
else
    echo "---------- Docker doesn't work! ----------"
fi


### Set Up SSH Access on 'silver'
sudo apt-get update
sudo apt-get install -y openssh-server
sudo systemctl start ssh
sudo systemctl enable ssh

if id "silver" &>/dev/null; then
    echo "${LINE} User 'silver' already exists."
else
    sudo useradd -m -s /bin/bash silver
    sudo usermod -aG docker silver
    echo "${LINE} User 'silver' created."
fi

if [ -f "${KEY_PATH}" ]; then
    echo "${LINE} merlin_key SSH public key is already at ${KEY_PATH}."
else
    sudo mkdir -p $SSH_PATH
    mv $TMP_KEY $KEY_PATH
    cat "$KEY_PATH" > "$AUTHORIZED_KEYS_PATH"
    echo "${LINE} merlin_key SSH key was moved to work directory."
fi

sudo chown -R silver:silver $SSH_PATH
sudo chmod 700 $SSH_PATH
sudo chmod 600 $KEY_PATH
sudo chmod 600 $AUTHORIZED_KEYS_PATH

sudo mkdir -p $JENKINS_PATH
sudo chown -R silver:silver $JENKINS_PATH
sudo chmod -R 777 $JENKINS_PATH

# sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/#AuthorizedKeysFile/AuthorizedKeysFile/' /etc/ssh/sshd_config
sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart ssh

sleep 5
echo $LINE
echo "I    ssh configured     I"
echo $LINE
sudo systemctl status ssh
