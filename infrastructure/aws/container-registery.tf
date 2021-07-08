resource "aws_ecr_repository" "container_registery_01" {
  name                 = "k8simagesregistery"
  image_tag_mutability = "MUTABLE"

  tags = {
    Name        = "Image container for k8s"
    Environment = "Demo"
  }
}