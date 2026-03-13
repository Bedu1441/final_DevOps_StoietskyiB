provider "aws" {
  region = "us-east-1"
}

module "s3_backend" {
  source       = "./modules/s3-backend"
  project_name = "final-devops-stoietskyib"
  region       = "us-east-1"
}

module "vpc" {
  source       = "./modules/vpc"
  project_name = "final-devops-stoietskyib"
}

module "eks" {
  source             = "./modules/eks"
  project_name       = "final-devops-stoietskyib"
  private_subnet_ids = module.vpc.private_subnet_ids

  node_count      = 2
  node_min        = 1
  node_max        = 3
  instance_type   = "t3.medium"
  cluster_version = "1.29"
}

module "rds" {
  source             = "./modules/rds"
  project_name       = "final-devops-stoietskyib"
  db_name            = "finaldb"
  db_username        = "postgres"
  db_password        = "Postgres123!"
  private_subnet_ids = module.vpc.private_subnet_ids
  vpc_id             = module.vpc.vpc_id
  vpc_cidr_block     = module.vpc.vpc_cidr_block
}

resource "helm_release" "metrics_server" {
  name             = "metrics-server"
  repository       = "https://kubernetes-sigs.github.io/metrics-server/"
  chart            = "metrics-server"
  namespace        = "kube-system"
  create_namespace = false

  set = [
    {
      name  = "args[0]"
      value = "--kubelet-insecure-tls"
    },
    {
      name  = "args[1]"
      value = "--kubelet-preferred-address-types=InternalIP"
    }
  ]
}

resource "helm_release" "monitoring" {
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true
  timeout          = 900
}
