# Copyright Phạm Anh Tuấn - PAT

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}############################################################################${NC}"
echo -e "${GREEN}#     Download & install docker    #${NC}"
echo -e "${GREEN}############################################################################${NC}"
echo -e ""

echo -e "${GREEN} Remove old version ${NC}"
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine

echo -e "${GREEN} Install yum-utils ${NC}"
sudo yum install -y yum-utils

echo -e "${GREEN} Config-manager ${NC}"
sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo 

echo -e "${GREEN} Install docker ${NC}"
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin 


#
#echo -e "${GREEN} Download docker ${NC}"
#sudo dnf install https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm 
#
#echo -e "${GREEN} install docker ${NC}"
#sudo dnf install -y docker-ce -y
#
#echo -e "${GREEN} Reload services ${NC}"
#sudo systemctl daemon-reload
#
#echo -e "${GREEN} Enable the docker service ${NC}"
#sudo systemctl enable docker
#
#echo -e "${GREEN} Start the docker service ${NC}"
#sudo systemctl start docker


echo -e "${GREEN}############################################################################${NC}"
echo -e "${GREEN}#     Download & install kubectl    #${NC}"
echo -e "${GREEN}############################################################################${NC}"
echo -e ""

echo -e "${GREEN} Download kubectl ${NC}"
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check


sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
echo -e "${GREEN} Chmod kubectl ${NC}"
chmod +x kubectl

echo -e "${GREEN} Move kubectl to /bin ${NC}"
mkdir -p ~/.local/bin
mv ./kubectl ~/.local/bin/kubectl


echo -e "${GREEN}############################################################################${NC}"
echo -e "${GREEN}#     Download & install minikube    #${NC}"
echo -e "${GREEN}############################################################################${NC}"
echo -e ""

echo -e "${GREEN} Download minikube ${NC}"
sudo curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \

echo -e "${GREEN} Chmod minikube ${NC}"
sudo chmod +x minikube

echo -e "${GREEN} Install minikube ${NC}"
sudo mkdir -p /usr/local/bin/
sudo install minikube /usr/local/bin/ 

echo -e "${GREEN} Add $USER group ${NC}"
sudo usermod -aG docker $USER && newgrp docker

echo -e "${GREEN} Add port ${NC}"
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --permanent --add-port=8081/tcp
sudo firewall-cmd --permanent --add-port=6443/tcp
sudo firewall-cmd --permanent --add-port=2379-2380/tcp
sudo firewall-cmd --permanent --add-port=10250/tcp
sudo firewall-cmd --permanent --add-port=10251/tcp
sudo firewall-cmd --permanent --add-port=10252/tcp
sudo firewall-cmd --permanent --add-port=10255/tcp

echo -e "${GREEN} Firewall reload ${NC}"
sudo firewall-cmd --reload

echo -e "${GREEN} Show list port ${NC}"
sudo firewall-cmd --list

echo -e "${GREEN} test minikube start docker ${NC}"
minikube start --driver=docker



#
#echo -e "${GREEN}############################################################################${NC}"
#echo -e "${GREEN}#     Install Kubeadm    #${NC}"
#echo -e "${GREEN}############################################################################${NC}"
#echo -e ""
#
#cat <<EOF > /etc/yum.repos.d/kubernetes.repo
#[kubernetes]
#name=Kubernetes
#baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
#enabled=1
#gpgcheck=1
#repo_gpgcheck=1
#gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
#EOF
#
#sudo dnf install kubeadm -y
#
#sduo systemctl enable kubelet
#
#sudo systemctl start kubelet




