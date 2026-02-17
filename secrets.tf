# Secrets Manager para almacenar credenciales de MongoDB
resource "aws_secretsmanager_secret" "mongodb_credentials" {
  name        = "${var.project_name}/mongodb-credentials"
  description = "Credenciales de MongoDB para ${var.project_name}"

  tags = {
    Name = "${var.project_name}-mongodb-secret"
  }
}

resource "aws_secretsmanager_secret_version" "mongodb_credentials" {
  secret_id = aws_secretsmanager_secret.mongodb_credentials.id
  secret_string = jsonencode({
    MONGODB_HOST     = var.mongodb_host
    MONGODB_USERNAME = var.mongodb_username
    MONGODB_PASSWORD = var.mongodb_password
    MONGODB_DATABASE = var.mongodb_database
  })
}
