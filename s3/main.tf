resource "aws_s3_bucket" "bucket-pems" {
  bucket_prefix = "monit-pems-"
  acl    = "private"

}

resource "aws_s3_bucket_public_access_block" "bucket-pems" {
  bucket = aws_s3_bucket.bucket-pems.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.bucket-pems.id
  key    = var.zabbix_pem_name
  content= var.zabbix_pem
}