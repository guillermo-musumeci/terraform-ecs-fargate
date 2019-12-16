# nginx container - nginx-variables.tf

variable "nginx_app_name" {
  description = "Name of Application Container"
  default     = "nginx"
}

variable "nginx_app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "nginx:latest"
}

variable "nginx_app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 80
}

variable "nginx_app_count" {
  description = "Number of docker containers to run"
  default     = 2
}

variable "nginx_fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "nginx_fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}

