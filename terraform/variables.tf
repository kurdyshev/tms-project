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
