#Secret S3 Bucket
resource "aws_s3_bucket" "code2cloud-secret-s3-bucket" {
  bucket = "code2cloud-secret-s3-bucket-${var.code2cloudid}"
  force_destroy = true
  tags = {
      Name = "code2cloud-secret-s3-bucket-${var.code2cloudid}"
      Description = "code2cloud ${var.code2cloudid} S3 Bucket used for storing a secret"
      Stack = "${var.stack-name}"
      Scenario = "${var.scenario-name}"
  }
}

resource "aws_s3_bucket_acl" "code2cloud-secret-s3-bucket-acl" {
  bucket = aws_s3_bucket.code2cloud-secret-s3-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_object" "code2cloud-shepards-credentials" {
  bucket = "${aws_s3_bucket.code2cloud-secret-s3-bucket.id}"
  key = "admin-user.txt"
  source = "./admin-user.txt"
  tags = {
    Name = "code2cloud-shepards-credentials-${var.code2cloudid}"
    Stack = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}