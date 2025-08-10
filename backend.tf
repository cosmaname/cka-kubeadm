terraform {
  backend "s3" {
    bucket         = "raz-tfstate"
    region         = "eu-west-2"
    key            = "cka/opentofu.tfstate"
    dynamodb_table = "raz-tfstate"
  }
}
