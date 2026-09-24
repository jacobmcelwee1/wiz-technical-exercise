variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "wiz-exercise"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "192.168.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs"
  type        = list(string)
  default     = ["192.168.1.0/24", "192.168.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs"
  type        = list(string)
  default     = ["192.168.3.0/24", "192.168.4.0/24"]
}

variable "mongodb_instance_type" {
  description = "MongoDB EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "eks_node_instance_type" {
  description = "EKS worker node instance type"
  type        = string
  default     = "t3.medium"
}

variable "mongodb_password" {
  description = "MongoDB password"
  type        = string
  sensitive   = true
  default     = "wizpassword"
}

variable "key_pair_name" {
  description = "EC2 key pair name for SSH"
  type        = string
}
