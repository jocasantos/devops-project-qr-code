output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "bucket_id" {
  description = "The bucket ID"
  value = module.s3.bucket_id
}