output "vpc_id" {
  description = "ID de la VPC"
  value       = aws_vpc.main.id
}

output "ecs_cluster_name" {
  description = "Nombre del cluster ECS"
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  description = "Nombre del servicio ECS"
  value       = aws_ecs_service.api.name
}

output "ecr_repository_url" {
  description = "URL del repositorio ECR"
  value       = aws_ecr_repository.api.repository_url
}

output "alb_dns_name" {
  description = "DNS name del Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_arn" {
  description = "ARN del Application Load Balancer"
  value       = aws_lb.main.arn
}

output "api_gateway_url" {
  description = "URL del API Gateway"
  value       = "${aws_apigatewayv2_api.main.api_endpoint}/${var.api_gateway_stage_name}"
}

output "api_gateway_id" {
  description = "ID del API Gateway"
  value       = aws_apigatewayv2_api.main.id
}

output "secrets_manager_secret_arn" {
  description = "ARN del secreto en Secrets Manager"
  value       = aws_secretsmanager_secret.mongodb_credentials.arn
  sensitive   = true
}

output "cloudwatch_log_group" {
  description = "Nombre del grupo de logs de CloudWatch"
  value       = aws_cloudwatch_log_group.ecs.name
}

output "task_definition_arn" {
  description = "ARN de la definición de tarea ECS"
  value       = aws_ecs_task_definition.api.arn
}
