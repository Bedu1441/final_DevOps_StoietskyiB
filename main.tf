provider "aws" {
  region = "us-east-1"
}

# ----------------------------
# Backend infrastructure module
# (S3 bucket + DynamoDB table)
# ----------------------------
module "s3_backend" {
  source       = "./modules/s3-backend"
  project_name = "final-devops-stoietskyib"
  region       = "us-east-1"
}

# ----------------------------
# VPC module
# ----------------------------
module "vpc" {
  source       = "./modules/vpc"
  project_name = "final-devops-stoietskyib"
}

# ----------------------------
# EKS module (1 node to avoid vCPU limit issues)
# ----------------------------
module "eks" {
  source             = "./modules/eks"
  project_name       = "final-devops-stoietskyib"
  private_subnet_ids = module.vpc.private_subnet_ids

  node_count      = 2
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
}
