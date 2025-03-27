# 🚀 React Travel Agency Website Deployment with GitLab CI/CD, SonarQube & Trivy



<img width="960" alt="2025-03-27 (33)" src="https://github.com/user-attachments/assets/9a2fac54-64ad-4855-9d3e-d0941b517607" />


<img width="960" alt="2025-03-27 (35)" src="https://github.com/user-attachments/assets/bc36ee26-6bbf-4378-ba12-eee0b0a0930e" />



## 🌍 Overview
This project automates the CI/CD pipeline for deploying the **React Travel Agency Website** using **GitLab CI/CD**, **SonarQube for code quality analysis**, and **Trivy for security scanning** before deploying the application on an **AWS EC2 instance**. The application is containerized using **Docker** and stored in **DockerHub**.

## 🔥 Features
- **Automated CI/CD pipeline** using GitLab
- **SonarQube integration** for static code analysis
- **Trivy security scans** for both files and Docker images
- **Containerization** with Docker
- **Deployment to AWS EC2**


## ⚙️ Prerequisites
- **GitLab repository** for CI/CD
- **AWS EC2 instance** with GitLab Runner installed
- **SonarQube Server** for code quality checks
- **Trivy installed** for security scans
- **Docker installed** and a **DockerHub account**

## 📜 Setup Instructions

### 🔹 1. Clone the Repository
```sh
git clone https://github.com/etaoko333/react-travel-agency-website.git
cd react-travel-agency-website
```

### 🔹 2. Configure GitLab CI/CD
Create a `.gitlab-ci.yml` file with the following pipeline stages:
```yaml
stages:
  - install
  - test
  - scan
  - build
  - deploy

default:
  image: node:18

install_dependencies:
  stage: install
  script:
    - npm install

sonarqube_analysis:
  stage: test
  script:
    - sonar-scanner -Dsonar.host.url=$SONARQUBE_URL -Dsonar.login=$SONARQUBE_TOKEN

trivy_file_scan:
  stage: scan
  script:
    - trivy filesystem --no-progress --exit-code 1 .

build_and_push:
  stage: build
  script:
    - docker build -t your-dockerhub-username/travel-app:latest .
    - echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin
    - docker push your-dockerhub-username/travel-app:latest

trivy_image_scan:
  stage: scan
  script:
    - trivy image your-dockerhub-username/travel-app:latest

deploy_to_ec2:
  stage: deploy
  script:
    - ssh ubuntu@$EC2_INSTANCE "docker pull your-dockerhub-username/travel-app:latest && docker run -d -p 80:3000 your-dockerhub-username/travel-app:latest"
```

### 🔹 3. Set Up Environment Variables in GitLab
Go to **GitLab → Settings → CI/CD → Variables** and add:
- `SONARQUBE_URL`: Your SonarQube server URL
- `SONARQUBE_TOKEN`: Your SonarQube authentication token
- `DOCKERHUB_USERNAME`: Your DockerHub username
- `DOCKERHUB_PASSWORD`: Your DockerHub password
- `EC2_INSTANCE`: Your AWS EC2 instance IP

### 🔹 4. Install GitLab Runner on EC2
```sh
sudo apt update && sudo apt install gitlab-runner -y
gitlab-runner register
```

### 🔹 5. Run the Pipeline
Push the code to trigger the GitLab CI/CD pipeline:
```sh
git add .
git commit -m "Initial CI/CD pipeline setup"
git push origin main
```

## 🔍 Troubleshooting Common Issues

🔴 **SonarQube Scanner Failing**
```sh
ERROR: SonarQube server [http://localhost:9000] can not be reached
```
✅ **Fix:** Ensure SonarQube is running and update `sonar-project.properties` with the correct URL.

🔴 **Trivy Scan Permissions Denied**
```sh
FATAL: unable to initialize a scanner: permission denied
```
✅ **Fix:** Run `chmod +x /usr/local/bin/trivy` and use `--skip-db-update`.

🔴 **GitLab Runner Not Registering on EC2**
```sh
ERROR: Registering runner... failed
```
✅ **Fix:** Restart GitLab Runner and check AWS Security Groups for open ports.

## 🎉 Conclusion
This **automated CI/CD pipeline** ensures a **secure, reliable, and efficient** deployment process for your **React Travel Agency Website**. 🚀

Got questions? Feel free to reach out! Happy coding! 😃
