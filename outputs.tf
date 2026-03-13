output "backend_bucket" {
  value = module.s3_backend.bucket_name
}

output "backend_dynamodb_table" {
  value = module.s3_backend.dynamodb_table
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}
