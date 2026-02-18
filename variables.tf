variable "mongodb_username" {
  type      = string
  sensitive = true
}

variable "mongodb_password" {
  type      = string
  sensitive = true
}

variable "mongodb_host" {
  type = string
}

variable "mongodb_database" {
  type = string
}

variable "spring_profile" {
  type = string
}

variable "server_port" {
  type = string
  default = "8080"
}
