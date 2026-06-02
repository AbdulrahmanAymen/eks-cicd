# EKS CI/CD Pipeline with Jenkins, Terraform & Kubernetes

## Overview
A complete Infrastructure-as-Code (IaC) solution that automates the provisioning of a Jenkins CI/CD server on AWS EC2 and an EKS (Elastic Kubernetes Service) cluster, with automated deployment of containerized applications using Kubernetes manifests.

##  Architecture

Launch EC2 Instance (via Terraform)
↓
Install Jenkins + Tools (Terraform user_data script)
↓
Run Jenkins Pipeline
├── Checkout code from GitHub
├── Terraform init/validate/plan
├── Create/Destroy EKS Cluster
└── Deploy Nginx to Kubernetes


##  Project Structure

### **1. tf-aws-ec2/** - Jenkins Server Infrastructure
- Launches an EC2 instance on AWS
- Installs Jenkins, Docker, Terraform, kubectl, and other DevOps tools
- Creates security group for Jenkins access
- Uses `jenkins_server/install-jenkins.sh` for setup

**Technologies:**
- Terraform
- AWS EC2
- Bash scripting

### **2. jenkins_server/** - Jenkins Installation Script
- Installs Java 17 (required for Jenkins)
- Installs Jenkins
- Installs Docker (for containerization)
- Installs Terraform (for IaC)
- Installs kubectl (for Kubernetes management)
- Installs AWS CLI (for AWS interactions)
- Installs Trivy (for container security scanning)
- Installs Helm (for Kubernetes package management)
- Installs SonarQube container (for code quality analysis)

### **3. tf-aws-eks/** - EKS Cluster Infrastructure
- Creates VPC with public and private subnets
- Creates EKS cluster with worker nodes
- Configures IAM roles and policies
- Manages remote Terraform state in S3

**Key Files:**
- `vpc.tf` - VPC, subnets, gateways
- `eks.tf` - EKS cluster and node groups
- `provider.tf` - AWS provider configuration
- `variables.tf` - Input variables
- `backend.tf` - Remote state management

### **4. manifest/** - Kubernetes Manifests
- `deployment.yaml` - Nginx deployment on EKS
- `service.yaml` - Kubernetes service for Nginx

### **5. Jenkinsfile** - CI/CD Pipeline
**Stages:**
1. **Checkout SCM** - Pulls code from GitHub
2. **Initializing Terraform** - Initializes Terraform
3. **Validating Terraform** - Validates syntax and configuration
4. **Terraform Plan** - Shows what resources will be created
5. **Creating/Destroying EKS Cluster** - Applies or destroys infrastructure
6. **Deploying Nginx Application** - Deploys Nginx to EKS (only if action = apply)

##  Tech Stack
- **IaC:** Terraform
- **CI/CD:** Jenkins
- **Container Runtime:** Docker
- **Orchestration:** Kubernetes (AWS EKS)
- **Cloud Provider:** AWS (EC2, EKS, VPC)
- **Monitoring:** SonarQube
- **Security Scanning:** Trivy
- **Package Manager:** Helm
- **CLI Tools:** kubectl, AWS CLI

##  Prerequisites
- AWS Account with appropriate IAM permissions
- Terraform installed locally (for initial setup)
- Git repository access
- AWS credentials configured

##  How to Deploy

### **Step 1: Launch Jenkins Server**
```bash
cd tf-aws-ec2/
terraform init
terraform plan
terraform apply
```

**Output:** EC2 instance with Jenkins installed

### **Step 2: Access Jenkins**
Jenkins URL: http://<EC2_PUBLIC_IP>:8080
Get initial password:

SSH into EC2 instance
Run: sudo cat /var/lib/jenkins/secrets/initialAdminPassword


### **Step 3: Create Jenkins Pipeline**
1. Go to Jenkins Dashboard
2. Click "New Item"
3. Choose "Pipeline"
4. Configure pipeline to use:
   - Repository URL: Your GitHub repo
   - Script path: `Jenkinsfile`

### **Step 4: Run the Pipeline**
1. Click "Build with Parameters"
2. Choose action: `apply` (to create EKS)
3. Monitor pipeline execution

**Pipeline will:**
- Initialize Terraform
- Validate configuration
- Show plan (requires manual approval)
- Create EKS cluster
- Deploy Nginx to Kubernetes

### **Step 5: Verify Deployment**
```bash
# Update kubeconfig
aws eks update-kubeconfig --name my-eks-cluster --region us-east-1

# Check pods
kubectl get pods -n eks-nginx-app

# Check services
kubectl get svc -n eks-nginx-app

# Access Nginx
curl <EXTERNAL_IP>
```

##  Current Status

###  Completed
- [x] Jenkins installation script
- [x] Terraform code for EC2 provisioning
- [x] Terraform code for EKS cluster
- [x] Kubernetes manifests for Nginx
- [x] Jenkins pipeline configuration

###  Not Yet Tested
- [ ] Jenkins server launch and configuration
- [ ] EKS cluster creation via pipeline
- [ ] Nginx deployment to EKS
- [ ] End-to-end pipeline execution

##  Key Features
1. **Fully Automated** - One-click infrastructure provisioning
2. **IaC Best Practices** - All infrastructure defined in code
3. **CI/CD Integration** - Jenkins manages entire workflow
4. **Kubernetes Ready** - Deploy containerized apps on EKS
5. **Security Tools** - Includes Trivy, SonarQube, IAM policies
6. **Modular Design** - Separate Terraform modules for EC2 and EKS

##  Troubleshooting

**Issue: Jenkins fails to start**
- Solution: Check EC2 instance security group allows port 8080

**Issue: Terraform plan fails**
- Solution: Verify AWS credentials and IAM permissions

**Issue: EKS cluster creation timeout**
- Solution: Check AWS service limits and increase if needed

**Issue: kubectl commands fail**
- Solution: Verify kubeconfig is updated with correct cluster name

##  What I Learned
- Terraform modules for infrastructure provisioning
- Jenkins pipeline configuration with Groovy
- AWS EKS cluster management
- Kubernetes deployment and service management
- Infrastructure automation best practices
- Security scanning in CI/CD pipelines
- DevOps toolchain integration

## Next Steps / Future Improvements
- [ ] Test and run the complete pipeline
- [ ] Add more applications beyond Nginx
- [ ] Implement monitoring (Prometheus, Grafana)
- [ ] Add log aggregation (ELK stack)
- [ ] Implement auto-scaling policies
- [ ] Add multi-environment support (dev, staging, prod)
- [ ] Implement GitOps with ArgoCD
- [ ] Add Helm charts for application deployment
- [ ] Integrate container registry (ECR, Docker Hub)

##  Environment Variables Required

**Jenkins Credentials (set in Jenkins UI):**
- `AWS_ACCESS_KEY_ID` - AWS access key
- `AWS_SECRET_ACCESS_KEY` - AWS secret key

**Terraform Variables (in `variables/dev.tfvars`):**
- `aws_region` - AWS region
- `cluster_name` - EKS cluster name
- `cluster_version` - Kubernetes version

##  License
Open source - Feel free to use and modify

##  Author
Abdulrahman Ayman - DevOps Engineer

##  Contact
- Email: abdulrahmanaymen150@gmail.com
- GitHub: [@AbdulrahmanAymen](https://github.com/AbdulrahmanAymen)
- LinkedIn: [abdulrahman-aymen](https://linkedin.com/in/abdulrahman-aymen)
