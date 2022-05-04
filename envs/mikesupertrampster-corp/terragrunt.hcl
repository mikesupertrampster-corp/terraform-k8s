generate "backend" {
  path      = "config.tf"
  if_exists = "overwrite_terragrunt"
  contents  = templatefile("../../.files/template/config.tf", {
    organization = basename(get_parent_terragrunt_dir())
    workspace_name = "terraform-k8s-${replace(path_relative_to_include(), "/(\\.|/)/", "-")}"
  })
}

inputs = {
  apex_domain    = "mikesupertrampster.com."
  keypair        = "cardno:9"
  bootstrap_role = "TerraformAdminRole"
  flux_git_owner = "mikesupertrampster-corp"
  flux_git_repo  = "kubernetes-gitops"
  flux_git_url   = "ssh://git@github.com/mikesupertrampster-corp/kubernetes-gitops.git"
  keypair        = "cardno:9"
  region         = "eu-west-1"
  tags           = { Managed_By = "Terraform" }
}