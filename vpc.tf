locals {
  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.4.0"

  name                 = local.name
  cidr                 = local.vpc_cidr
  azs                  = local.azs
  public_subnets       = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = false

  tags = local.tags
}

# EIP for control node because it must know its public IP during initialisation
resource "aws_eip" "control" {
  domain     = "vpc"
  tags       = local.tags
  depends_on = [module.vpc.igw_id]
}
