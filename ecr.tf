resource "aws_ecr_repository" "app" {
  name         = "franchise-api"
  force_delete = true
}
