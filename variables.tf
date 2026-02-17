variable "aws_region" {
  description = "Región de AWS donde se desplegarán los recursos"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Ambiente de despliegue (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
  default     = "api-franquicias"
}

variable "vpc_cidr" {
  description = "CIDR block para la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Zonas de disponibilidad para los recursos"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "container_port" {
  description = "Puerto del contenedor (Spring Boot usa 8080 por defecto)"
  type        = number
  default     = 8080
}

variable "container_cpu" {
  description = "CPU units para el contenedor (1024 = 1 vCPU)"
  type        = number
  default     = 512
}

variable "container_memory" {
  description = "Memoria para el contenedor en MB"
  type        = number
  default     = 1024
}

variable "desired_count" {
  description = "Número deseado de tareas ECS"
  type        = number
  default     = 2
}

variable "min_capacity" {
  description = "Capacidad mínima para Auto Scaling"
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Capacidad máxima para Auto Scaling"
  type        = number
  default     = 10
}

variable "mongodb_host" {
  description = "Host de MongoDB"
  type        = string
  sensitive   = true
}

variable "mongodb_username" {
  description = "Usuario de MongoDB"
  type        = string
  sensitive   = true
}

variable "mongodb_password" {
  description = "Contraseña de MongoDB"
  type        = string
  sensitive   = true
}

variable "mongodb_database" {
  description = "Base de datos de MongoDB"
  type        = string
  default     = "api-franquicias"
}

variable "image_tag" {
  description = "Tag de la imagen Docker a desplegar"
  type        = string
  default     = "latest"
}

variable "health_check_path" {
  description = "Ruta para el health check (Spring Boot Actuator usa /actuator/health)"
  type        = string
  default     = "/actuator/health"
}

variable "enable_nat_gateway" {
  description = "Habilitar NAT Gateway (necesario para salida a internet desde subnets privadas)"
  type        = bool
  default     = true
}

variable "enable_container_health_check" {
  description = "Habilitar health check del contenedor (requiere wget o curl en la imagen)"
  type        = bool
  default     = true
}

variable "api_gateway_stage_name" {
  description = "Nombre del stage de API Gateway"
  type        = string
  default     = "api"
}
