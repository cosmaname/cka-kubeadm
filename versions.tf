terraform {
  required_version = "~> 1.8.0"

  required_providers {
    aws = {
      source  = "opentofu/aws"
      version = "~> 5.31.0"
    }
    random = {
      source  = "opentofu/random"
      version = "~> 3.6.0"
    }
    null = {
      source  = "opentofu/null"
      version = "~> 3.2.0"
    }
  }
}
