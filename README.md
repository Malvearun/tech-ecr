# DevOps Tech Test

This project demonstrates how to build a Docker image for a simple Flask application that runs inside a Docker container. The app returns a message when you access it via a browser. The goal is to demonstrate how to containerize a Python Flask application and run it securely using Docker. Deployed on Kubernetes using Helm, and integrates with Datadog for logging. The infrastructure also includes an AWS Lambda function provisioned using Terraform that runs from a Docker image stored in Amazon ECR. The project supports multiple environments and follows infrastructure best practices, including Horizontal Pod Autoscaling (HPA) and Istio Gateway for traffic routing.

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Setup and Installation](#setup-and-installation)
- [Building the Docker Image](#building-the-docker-image)
- [Running the Flask App](#running-the-flask-app)
- [Docker Security Best Practices](#docker-security-best-practices)
- [Contributing](#contributing)

### Prerequisites

Before you begin, ensure you have the following:

- Docker
- Minikube
- Kubernetes CLI (kubectl)
- Helm
- AWS CLI configured with limited ECR and Lambda permissions
- Terraform
- SonarQube for code quality checks
- GitHub Actions Self-Hosted Runner : Set up on your machine.

## Setup and Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/yourusername/flask-whale-app.git
   cd flask-whale-app
   ```
2. **Check the `Dockerfile`**:
   This project uses a Python 3.11 Alpine image, a lightweight base image suitable for containerized applications.
3. **Ensure the `requirements.txt` contains all necessary dependencies**:

   - Example content of `requirements.txt`:
     ```
     Flask==2.1.1
     ```

## Building the Docker Image

To build the Docker image for the Flask app, use the following command:

```bash
docker build -t flask-whale-app .
```

## Docker Security Best Practices

* **Run as a non-root user** : This is enforced by adding a non-root user (`appuser`) in the `Dockerfile`. This improves the security of the container.
* **Use minimal base images** : The project uses the `python:3.11-alpine` base image, which is lightweight and reduces the attack surface.
* **Limit exposed ports** : Only port `8087` is exposed, minimizing the container's network exposure.
* **Use multi-stage builds** : This can be added to further optimize the final image, especially when building larger applications.

## Setting Up Minikube

Ensure Minikube is properly installed and configured:

```bash
minikube start
eval $(minikube docker-env)
```

## Deploying the Application with Helm

Step 1: Create a Namespace

`kubectl create namespace hello-whale`

Step 2: Deploy Using Helm

`helm install hello-whale ./hello-whale-chart --namespace hello-whale`

This will deploy the application with the configured Kubernetes resources including the service, deployment, HPA, and Istio gateway.

Step 3: Enabling HPA for Autoscaling

The Horizontal Pod Autoscaler (HPA) is configured in the `hpa.yaml` file to scale based on memory utilization & Verify HPA is working: `kubectl get hpa -n hello-whale`

## Istio Configuration for Traffic Management

### Step 1: Install Istio

Make sure Istio is installed in your cluster.

### Step 2: Gateway and VirtualService Configuration

The `gateway.yaml` file includes both the Istio **Gateway** and **VirtualService** resources: `kind: Gateway`  & `kind: VirtualService`

These resources ensure traffic routing and allow external access to the application.

## Terraform Configuration for AWS Lambda

### Step 1: ECR Repository and Lambda Function

Terraform provisions an AWS Lambda that runs from a Docker image stored in ECR.

Main Terraform File (`modules/lambda/main.tf`)

### Step 2: IAM Role for Lambda and ECR

Create the required IAM roles and attach policies for Lambda and ECR.

### Step 3: Deploy the Infrastructure

Run the following commands to apply the Terraform configuration: `terraform init`,
`terraform plan` & `terraform apply`

## CI/CD Pipeline

### GitHub Actions Pipeline

* **Build and push Docker image** : Triggered on commit.
* **SonarQube job** : Ensures code quality.
* **Terraform Deployment** : Deploys AWS Lambda for the application.

---

## Monitoring with Datadog

The application integrates with Datadog for log collection and monitoring. Logs are collected from `/app/logs/hello_whale.log` and are tagged with the service name `hello_whale`.

Ensure Datadog agent is running and monitoring is configured in the Kubernetes deployment YAML: `annotations:   ad.datadoghq.com/{{ .Release.Name }}.logs: '[{"source":"python", "service":"hello_whale", "path":"/app/logs/hello_whale.log"}]'`
