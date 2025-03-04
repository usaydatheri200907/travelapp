#!/bin/bash

# Update package list
sudo apt update -y
sudo apt upgrade -y

# Install required dependencies
sudo apt-get install -y ca-certificates curl unzip gnupg software-properties-common apt-transport-https lsb-release

# Install Java (Temurin 17 JDK)
echo "Installing Java..."
wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | sudo tee /usr/share/keyrings/adoptium.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/adoptium.list
sudo apt update -y && sudo apt install -y temurin-17-jdk

# Install Jenkins
echo "Installing Jenkins..."
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update -y && sudo apt install -y jenkins
sudo systemctl enable --now jenkins
sudo systemctl status jenkins

# Install Docker
echo "Installing Docker..."
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Configure Docker Permissions
sudo usermod -aG docker ubuntu
sudo chmod 777 /var/run/docker.sock
newgrp docker
sudo systemctl enable --now docker
sudo systemctl status docker

# Install Docker Compose (Standalone)
echo "Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

# Install Trivy (Security Scanner)
echo "Installing Trivy..."
curl -sfL https://aquasecurity.github.io/trivy-repo/deb | sudo tee /etc/apt/sources.list.d/trivy.list
sudo apt update -y && sudo apt install -y trivy
trivy --version

# Install AWS CLI
echo "Installing AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws
aws --version

# Install Terraform
echo "Installing Terraform..."
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update -y && sudo apt-get install -y terraform
terraform --version

# Install kubectl
echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client

# Configure kubectl for EKS
#echo "Configuring kubectl for EKS..."
#aws eks --region us-west-1 update-kubeconfig --name Skyebank-cluster
#kubectl get nodes

# Install Helm (for Kubernetes package management)
#echo "Installing Helm..."
#curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
#helm version

# Deploy SonarQube (as Docker or Kubernetes)
echo "Deploying SonarQube..."
docker run -d --name sonar -p 9000:9000 --restart=always sonarqube:lts-community

echo "✅ Setup Completed Successfully!"
