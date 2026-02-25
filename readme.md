# Final DevOps Project

## Deployment of DevOps Infrastructure on AWS

---

## 1. Project Description

This project demonstrates the deployment of a complete DevOps infrastructure on AWS using Infrastructure as Code (Terraform).

The implemented solution includes:

- Virtual Private Cloud (VPC)
- Amazon EKS (Kubernetes cluster)
- Amazon ECR (container registry)
- Amazon RDS (PostgreSQL database)
- Jenkins (CI)
- Argo CD (GitOps CD)
- Prometheus and Grafana (monitoring stack)

The project validates end-to-end DevOps automation including provisioning, containerization, CI/CD, GitOps deployment, and monitoring.

---

## 2. Infrastructure Components

### 2.1 Infrastructure as Code

All core cloud infrastructure components are provisioned using Terraform.

Terraform backend:

- S3 bucket for remote state storage
- DynamoDB table for state locking

Provisioned AWS resources:

- VPC with public and private subnets
- Internet Gateway and route tables
- Amazon EKS cluster (Kubernetes 1.29)
- Managed node group (t3.medium instances)
- Amazon ECR repository
- Amazon RDS PostgreSQL instance (db.t3.micro)

Deployment command:

```
terraform init
terraform apply
```

---

## 3. Kubernetes Layer

The EKS cluster hosts the following namespaces:

- jenkins
- argocd
- app
- monitoring

Verification commands:

```
kubectl get all -n jenkins
kubectl get all -n argocd
kubectl get all -n monitoring
```

---

## 4. CI/CD Pipeline

### 4.1 Continuous Integration (Jenkins)

Jenkins is deployed in Kubernetes and configured to:

- Build Docker images
- Push images to Amazon ECR

Access:

```
kubectl port-forward svc/jenkins 8080:8080 -n jenkins
```

### 4.2 Container Registry (ECR)

Docker images are stored in Amazon ECR and pulled by Kubernetes deployments.

Repository format:

```
<account-id>.dkr.ecr.us-east-1.amazonaws.com/final-devops-app
```

### 4.3 Continuous Deployment (Argo CD)

Argo CD monitors a Git repository and automatically synchronizes Kubernetes manifests with the cluster (GitOps approach).

Access:

```
kubectl port-forward svc/argocd-server 8081:443 -n argocd
```

Application status:

- Synced
- Healthy

---

## 5. Database Layer

Amazon RDS PostgreSQL is provisioned via Terraform.

Configuration:

- Engine: PostgreSQL 15
- Instance class: db.t3.micro
- Private subnets
- Dedicated security group

Verification:

```
aws rds describe-db-instances --region us-east-1
```

---

## 6. Monitoring and Observability

Monitoring stack installed via Helm (kube-prometheus-stack).

Components:

- Prometheus
- Grafana
- Alertmanager
- Node Exporter
- kube-state-metrics

Verification:

```
kubectl get pods -n monitoring
```

Grafana access:

```
kubectl port-forward svc/monitoring-grafana 3000:80 -n monitoring
```

---

## 7. Project Structure

Current project structure:

```
Project/
├── main.tf
├── backend.tf
├── outputs.tf
├── modules/
│   ├── s3-backend/
│   ├── vpc/
│   ├── eks/
│   ├── rds/
│   └── ...
```

Helm-based components (Jenkins, Argo CD, Monitoring) are deployed within the Kubernetes layer rather than being fully isolated into separate Terraform modules.

---

## 8. Justification (пояснення) of Structural Differences

The provided course example suggests a more granular modular structure, including:

- Separate Terraform modules for Jenkins and Argo CD
- Dedicated Helm chart directories for applications
- Additional abstraction layers

In this implementation, structural simplifications were applied for the following reasons:

1. Functional Equivalence
   All required components are provisioned, configured, and verified according to the technical requirements. The infrastructure and CI/CD workflow are fully operational.
2. Clear Separation of Responsibilities
   Core cloud infrastructure (VPC, EKS, RDS, ECR, backend) is modularized in Terraform.
   Kubernetes application components are managed through Helm and GitOps principles.
3. Reduction of Unnecessary Abstraction
   For the scope of the final academic project, introducing additional Terraform wrapper modules for Helm releases would increase structural complexity without providing additional functional benefit.
4. Focus on DevOps Workflow Validation
   The objective of the project is to demonstrate end-to-end DevOps automation, not to replicate enterprise-level repository scaling patterns.
   Therefore, the current structure is architecturally simplified but functionally complete and aligned with the stated technical requirements.

---

## 9. Verification Checklist

Infrastructure:

- Terraform remote state configured
- VPC deployed
- EKS cluster operational
- RDS instance available
- ECR repository accessible

CI/CD:

- Jenkins operational
- Docker image build and push verified
- Argo CD synchronized
- Application deployed in Kubernetes

Monitoring:

- Prometheus running
- Grafana accessible
- Metrics available

All required components have been deployed and validated.

---

## 10. Conclusion

The project successfully demonstrates:

- Infrastructure as Code (Terraform)
- Containerization (Docker)
- CI/CD automation (Jenkins)
- GitOps deployment model (Argo CD)
- Managed database integration (RDS)
- Container registry usage (ECR)
- Monitoring and observability (Prometheus + Grafana)

The solution provides a complete and functional DevOps pipeline on AWS.
