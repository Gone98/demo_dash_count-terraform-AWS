variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.100.0.0/24"
}

variable "dashboard_subnet_cidr" {
  description = "CIDR block for the dashboard (public) subnet"
  type        = string
  default     = "10.100.0.0/25"
}

variable "counting_subnet_cidr" {
  description = "CIDR block for the counting (private) subnet"
  type        = string
  default     = "10.100.0.128/25"
}

variable "dashboard_sg_name" {
  description = "Name for the dashboard security group"
  type        = string
  default     = "dashboard-sg"
}

variable "counting_sg_name" {
  description = "Name for the counting security group"
  type        = string
  default     = "counting-sg"
}

variable "http_port" {
  description = "HTTP port for ingress rules"
  type        = number
  default     = 80
}

variable "ssh_port" {
  description = "SSH port for ingress rules"
  type        = number
  default     = 22
}

variable "any_cidr" {
  description = "CIDR blocks representing all traffic, used for public ingress and egress rules"
  type        = string
  default     = "0.0.0.0/0"
}

variable "instance_type" {
  description = "EC2 instance type for both dashboard and counting instances"
  type        = string
  default     = "t2.micro"
}

variable "dashboard_private_ip" {
  description = "Private IP address for the dashboard instance"
  type        = string
  default     = "10.100.0.100"
}

variable "counting_private_ip" {
  description = "Private IP address for the counting instance"
  type        = string
  default     = "10.100.0.200"
}