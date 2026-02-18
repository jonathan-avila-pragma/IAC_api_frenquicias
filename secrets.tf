resource "aws_secretsmanager_secret" "mongo" {
  name = "franchise-mongo-credentials"
}

resource "aws_secretsmanager_secret_version" "mongo_secret_value" {
  secret_id = aws_secretsmanager_secret.mongo.id

  secret_string = jsonencode({
    username = var.mongodb_username
    password = var.mongodb_password
  })
}
