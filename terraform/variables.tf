# AWS settings

variable "aws_region" {
  description = "AWS region"
  type        = string
  sensitive   = false
  default     = "us-east-1"
}

# RDS settings

variable "rds_db_name" {
  description = "RDS database name"
  default     = "django"
}
variable "rds_username" {
  description = "RDS database username"
  default     = "postgres"
}
variable "rds_password" {
  description = "RDS database password"
  type        = string
  sensitive   = true
}

# Django superuser settings

variable "django_username" {
  description = "Django superuser username"
  type        = string
  sensitive   = true
  default     = "admin"
}
variable "django_password" {
  description = "Django superuser password"
  type        = string
  sensitive   = true
  default     = "admin"
}
variable "django_email" {
  description = "Django superuser email"
  type        = string
  sensitive   = true
  default     = "admin@admin.local"
}

# ssh key

variable "ssh_key" {
  type    = string
  default = <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6vMz0o71urI2076dHdHwhZ/dZ6fp8RJISgr1CZiPs7n329WYG1Y3e2bzIHJT
FVfetuQM+EHgmms3gD19csHwiPmLje/9hcBaflSQgSny61jF1pWOrM7JDiSStzzLtyGe9QDD/wOge2usS4lWxnfOxMq2NOUcJ5D
8JyCQKkQmAokiW0K2YIlNvh4rcaOu8ZZtr+d/kn6vvs7D1gRhqYGsC6ejstkxQQpxp1XESPBCsCRm6MUOZfwdMqLzUMBd5qb0nw
8Pi+EcUaCMjMejoQgr/Nc1MBmAoOHNUKfITmUef/Av3zemExH4ITmc57cUPlyvpdyhKY3IKHumHcRX1ugPA/CVszkGKB/0gX7C/
W8ntSgXUvv7cflkewUUbuYPlJQ7HDZH3gOAQue+/ewe2htsQ9gZUBPygCQe8OhYlUIRUZizL5sFweCD7qbbhKEQABJKL6qE3Gs6
KgFaMfDiHEyJ11/at8m/LYLXCcoVATnFQHoxZdqft/AH6IAQ3yRBUPpk= vas@MacBook
EOF
}
