# Versiones requeridas de Terraform y proveedores
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Opcional: Configurar backend S3 para almacenar el estado
  # Descomenta y configura si quieres almacenar el estado en S3
  # backend "s3" {
  #   bucket = "tu-bucket-terraform-state"
  #   key    = "api-franquicias/terraform.tfstate"
  #   region = "us-east-1"
  # }
}
