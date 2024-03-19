locals {
  environments = {
    prod = {
      cidr = "10.0.0.0/16"
      public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
      private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
    },
    dev = {
      cidr = "192.168.0.0/16"
      public_subnets  = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"]
      private_subnets = ["192.168.4.0/24", "192.168.5.0/24", "192.168.6.0/24"]
    }
  }
}

data "aws_region" "current" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc"
  cidr = local.environments[var.environment].cidr

  azs = [for az in ["a", "b", "c"]: "${data.aws_region.current.name}${az}"]

  private_subnets = local.environments[var.environment].private_subnets
  public_subnets  = local.environments[var.environment].public_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = var.environment
  }
}
