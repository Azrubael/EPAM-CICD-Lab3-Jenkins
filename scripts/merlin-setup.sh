#!/bin/bash
# Official Jenkins help: https://www.jenkins.io/doc/book/installing/

KEY_PATH='/home/vagrant/.ssh/merlin_key'
LINE='========================='
TMP_KEY='/tmp/mkey'

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


### Jenkins Installation
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins -y --fix-missing

sudo systemctl start jenkins
sudo systemctl enable jenkins
sleep 5
sudo systemctl status jenkins
sleep 5

if curl localhost:8080; then
    echo ""
    echo $LINE
    echo "I       Jenkins         I"
    echo $LINE
else
    echo "---------- Jenkins doesn't work! ----------"
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
    sudo usermod -aG docker jenkins
else
    echo "---------- Docker doesn't work! ----------"
fi


### Set Up SSH Access on 'merlin'
sudo apt-get update
sudo apt-get install -y openssh-server

if [ -f "${KEY_PATH}" ]; then
    echo "${LINE} merlin_key SSH private key is already at ${KEY_PATH}."
else
    mv $TMP_KEY $KEY_PATH
    sudo chown vagrant:vagrant $KEY_PATH
    sudo chmod 600 $KEY_PATH
    echo "${LINE} merlin_key SSH key was moved to work directory."
fi


if ping -c1 192.168.56.18; then 
    if ssh -o BatchMode=yes -o ConnectTimeout=5 \
    -o StrictHostKeyChecking=no -i $KEY_PATH silver@192.168.56.18 "exit"; then
        echo "SSH connection to 'silver' is successful!"
    else
        echo "SSH connection to 'silver' failed."
    fi
else
    echo "The host 'silver' aren't running, so SSH setting was skipped."
fi


: <<'COMMENTARY'
sudo apt install openjdk-17-jdk -y --fix-missing
java -version
javac -version
sudo apt --fix-broken install

Please use the following password to proceed to installation:
curl localhost:8080
### OR
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

### If you want to work with Jenkins
http://192.168.56.20:8080

### If you need to try the ssh connect
ssh -i /home/vagrant/.ssh/merlin_key silver@192.168.56.18

# eval $(ssh-agent)
# ssh-add $KEY_PATH
COMMENTARY
