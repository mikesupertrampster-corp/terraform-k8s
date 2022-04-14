provider "aws" {
  region = var.region

  assume_role {
    role_arn = "arn:aws:iam::${var.account_id}:role/${var.bootstrap_role}"
  }

  default_tags {
    tags = var.tags
  }
}

module "kubernetes" {
  source             = "../../../modules//kubernetes"
  environment        = var.environment
  flux_git_owner     = var.flux_git_owner
  flux_git_repo      = var.flux_git_repo
  flux_git_url       = var.flux_git_url
  keypair            = var.keypair
  private_subnet_ids = [for k, v in data.aws_subnet.private : v.id]
  public_subnet_ids  = [for k, v in data.aws_subnet.public : v.id]
  vpc_id             = data.aws_vpc.current.id
}
