terraform {
  backend "s3" {
    bucket         = "raz-tfstate"
    region         = "eu-west-2"
    key            = "cka/terraform.tfstate"
    profile        = "eu"
    dynamodb_table = "raz-tfstate"
  }
}
