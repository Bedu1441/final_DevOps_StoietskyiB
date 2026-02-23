provider "aws" {
  region = "us-east-1" # або твій стандартний
}

module "s3_backend" {
  source       = "./modules/s3-backend"
  project_name = "final-devops-stoietskyib"
  region       = "us-east-1"
}
