terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.37.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region  = "ap-northeast-1"
  profile = "aws_htoo"
}