provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}

locals {
  region = "eu-west-2"
  name   = "cka"

  tags = {
    GithubRepo = "https://github.com/cosmaname/cka-kubeadm"
  }
}
