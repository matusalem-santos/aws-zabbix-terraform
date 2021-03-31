output "s3_bucket_id" {
  description = "The ID of the S3"
  value       = aws_s3_bucket.bucket-pems.id
}