output "backend_bucket" {
  value = module.s3_backend.bucket_name
}

output "backend_dynamodb_table" {
  value = module.s3_backend.dynamodb_table
}
