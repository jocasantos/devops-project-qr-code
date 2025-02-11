variable "aws_region" {
  description = "AWS region for the deployment"
  type        = string
  default     = "eu-north-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "172.16.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  default     = ["172.16.1.0/24", "172.16.2.0/24"]
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default     = ["172.16.3.0/24", "172.16.4.0/24"]
}

/* variable "ami" {
  description = "AMI ID for the EC2 instance"
  default = "ami-09a9858973b288bdd"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  default = "t3.micro"
  type        = string
} */