resource "aws_ecr_repository" "code2cloud-ecr" {
  name                 = "code2cloud-ecr"
  image_tag_mutability = "MUTABLE"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = false
  }
}

output "code2cloud-ecr" {
  value = aws_ecr_repository.code2cloud-ecr.repository_url
}