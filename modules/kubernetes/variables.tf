variable "apex_domain" {
  type = string
}

variable "environment" {
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
