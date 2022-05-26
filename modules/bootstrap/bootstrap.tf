terraform {
  required_providers {
    flux = {
      source = "fluxcd/flux"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
    }
  }
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster.name
}

data "tls_certificate" "eks_oidc_cert" {
  url = var.cluster.identity.0.oidc.0.issuer
}

resource "aws_iam_openid_connect_provider" "eks_oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [for cert in data.tls_certificate.eks_oidc_cert.certificates : cert.sha1_fingerprint if cert.is_ca]
  url             = var.cluster.identity.0.oidc.0.issuer
}

provider "kubernetes" {
  host                   = var.cluster.endpoint
  cluster_ca_certificate = base64decode(var.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}
