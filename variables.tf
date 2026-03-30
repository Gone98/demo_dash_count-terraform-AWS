variable "vpc_name" {
  description = "The name of the VPC to be created."
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "azs" {
  description = "A list of availability zones to be used for the subnets."
  type        = list(string)
}

variable "private_subnets" {
  description = "A list of CIDR blocks for the private subnets."
  type        = list(string)
}

variable "public_subnets" {
  description = "A list of CIDR blocks for the public subnets."
  type        = list(string)
}

variable "dashboard_sg_name" {
  description = "The name of the security group for the dashboard."
  type        = string
}

variable "counting_sg_name" {
  description = "The name of the security group for counting."
  type        = string
}

variable "public_cidr_blocks" {
  description = "A list of CIDR blocks allowed to access the dashboard on port 80."
  type        = string
}

variable "dash_instance" {
  description = "The name of the EC2 instance for the dashboard."
  type        = string
}

variable "count_instance" {
  description = "The name of the EC2 instance for counting."
  type        = string
}

variable "instance_type" {
  description = "The instance type for the EC2 instances."
  type        = string
}

variable "dash_priv_ip" {
  description = "The private IP address for the dashboard EC2 instance."
  type        = string
}

variable "count_priv_ip" {
  description = "The private IP address for the counting EC2 instance."
  type        = string
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instances."
  type        = string
}