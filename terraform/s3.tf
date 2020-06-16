resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = merge(
    var.general_tags,
    { Name = format("%s", var.bucket_name) }
  )
}
