module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs                           = var.azs
  private_subnets               = var.private_subnets
  public_subnets                = var.public_subnets
  enable_nat_gateway            = true
  manage_default_network_acl    = false
  manage_default_security_group = false
  manage_default_route_table    = false
  tags = {
    Terraform = "true"
  }
}

module "dashboard-security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name        = var.dashboard_sg_name
  description = "Security group for dashboard "
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = var.public_cidr_blocks
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.public_cidr_blocks
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = var.public_cidr_blocks
    }
  ]
  tags = {
    Terraform = "true"
  }
}

module "counting-security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name        = var.counting_sg_name
  description = "Security group for counting "
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = var.vpc_cidr
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = var.public_cidr_blocks
    }
  ]
  tags = {
    Terraform = "true"
  }
}

module "dashboard_ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.4.0"

  name                  = var.dash_instance
  ami                   = var.ami_id
  instance_type         = var.instance_type
  subnet_id             = module.vpc.public_subnets[0]
  security_group_name   = module.dashboard-security-group.security_group_name
  key_name              = aws_key_pair.private_key_pair.key_name
  private_ip            = var.dash_priv_ip
  user_data             = file("shell_scripts/dashboard.sh")
  create_eip            = true
  create_security_group = false
  vpc_security_group_ids = [module.dashboard-security-group.security_group_id]
  tags = {
    Terraform = "true"
  }
}

module "counting_ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.4.0"

  name                  = var.count_instance
  ami                   = var.ami_id
  instance_type         = var.instance_type
  subnet_id             = module.vpc.private_subnets[0]
  security_group_name   = module.counting-security-group.security_group_name
  key_name              = aws_key_pair.private_key_pair.key_name
  private_ip            = var.count_priv_ip
  user_data             = file("shell_scripts/counting.sh")
  create_security_group = false
  vpc_security_group_ids = [module.counting-security-group.security_group_id]
  tags = {
    Terraform = "true"
  }
}

resource "tls_private_key" "private_key" {
  algorithm = "ED25519"
}

locals {
  private_key_file = "dashboard-and-counting-ssh-key.pem"
}

resource "aws_key_pair" "private_key_pair" {
  key_name   = local.private_key_file
  public_key = tls_private_key.private_key.public_key_openssh
}