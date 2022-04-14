variable "environment" {
  type = string
}

variable "github_fingerprint" {
  type    = string
  default = "github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg="
}

variable "flux_git_owner" {
  type = string
}

variable "flux_git_repo" {
  type = string
}

variable "k8s_version" {
  type    = string
  default = 1.22
}

variable "keypair" {
  type = string
}

variable "node_group_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}
