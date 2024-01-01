# Performs 'ImportKeyPair' API operation (not 'CreateKeyPair')
resource "aws_key_pair" "ssh" {
  key_name_prefix = "${local.name}-"
  public_key      = file(var.public_key_file)
  tags            = local.tags
}

# Generate bootstrap token
# See https://kubernetes.io/docs/reference/access-authn-authz/bootstrap-tokens/
resource "random_string" "token_id" {
  length  = 6
  special = false
  upper   = false
}

resource "random_string" "token_secret" {
  length  = 16
  special = false
  upper   = false
}

locals {
  token = "${random_string.token_id.result}.${random_string.token_secret.result}"
}
