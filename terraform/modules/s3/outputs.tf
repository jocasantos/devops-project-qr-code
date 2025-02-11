output "bucket_id" {
  value = aws_s3_bucket.my_bucket.id
}

output "bucket_name" {
  value = aws_s3_bucket.my_bucket.bucket
}