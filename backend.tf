terraform {
  backend "s3" {
    bucket         = "final-devops-stoietskyib-terraform-state"
    key            = "global/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "final-devops-stoietskyib-terraform-locks"
    encrypt        = true
  }
}
