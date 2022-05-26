variable "cluster" {
  type = object({
    name     = string
    endpoint = string
    certificate_authority = list(object({
      data = string
    }))
    identity = list(object({
      oidc = list(object({
        issuer = string
      }))
    }))
  })
}

variable "environment" {
  type = string
}

variable "flux_git_branch" {
  type    = string
  default = "master"
}

variable "flux_git_owner" {
  type = string
}

variable "flux_git_repo" {
  type = string
}

variable "flux_git_url" {
  type = string
}

variable "github_fingerprint" {
  type    = string
  default = "github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg="
}
