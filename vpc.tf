locals {
  vpc_cidr = var.vpc_network_cidr_block
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.4.0"

  name                 = local.name
  cidr                 = local.vpc_cidr
  azs                  = local.azs
  private_subnets      = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  public_subnets       = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = true
  single_nat_gateway   = true

  tags = local.tags
}

# EIP for control node because it must know its public IP during initialisation
resource "aws_eip" "control" {
  domain     = "vpc"
  tags       = local.tags
  depends_on = [module.vpc.igw_id]
}
