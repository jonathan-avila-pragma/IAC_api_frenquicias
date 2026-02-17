provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "api-franquicias"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}
