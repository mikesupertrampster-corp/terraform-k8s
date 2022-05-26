#------------------------------------------------------------------------------
# Flux v2
#------------------------------------------------------------------------------

provider "kubectl" {
  host                   = var.cluster.endpoint
  cluster_ca_certificate = base64decode(var.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

data "flux_install" "main" {
  target_path      = "clusters/${var.environment}"
  network_policy   = false
  components_extra = []
}

data "flux_sync" "main" {
  target_path = data.flux_install.main.target_path
  url         = var.flux_git_url
  branch      = var.flux_git_branch
}

resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "kubernetes_namespace" "flux_system" {
  metadata {
    name = "flux-system"
  }

  lifecycle {
    ignore_changes = [metadata.0.labels]
  }
}

data "kubectl_file_documents" "install" {
  content = data.flux_install.main.content
}

data "kubectl_file_documents" "sync" {
  content = data.flux_sync.main.content
}

# Convert documents list from the datasource to include parsed yaml data
locals {
  install = [for v in data.kubectl_file_documents.install.documents : { data : yamldecode(v), content : v }]
  sync    = [for v in data.kubectl_file_documents.sync.documents : { data : yamldecode(v), content : v }]
}

// The group of manifests to deploy flux2's basic components
resource "kubectl_manifest" "install" {
  for_each   = { for v in local.install : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v["content"] }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body  = each.value
}

// The group of manifests to initialize the flux state repo
resource "kubectl_manifest" "sync" {
  for_each   = { for v in local.sync : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v["content"] }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body  = each.value
}

// Manage the secret used by flux
resource "kubernetes_secret" "main" {
  depends_on = [kubectl_manifest.install]

  metadata {
    name      = data.flux_sync.main.secret
    namespace = data.flux_sync.main.namespace
  }

  data = {
    "identity.pub" = tls_private_key.main.public_key_pem
    identity       = tls_private_key.main.private_key_pem
    known_hosts    = var.github_fingerprint
  }
}

provider "github" {
  owner = var.flux_git_owner
}

resource "github_repository_deploy_key" "flux" {
  title      = "flux/${var.environment}"
  repository = var.flux_git_repo
  key        = tls_private_key.main.public_key_openssh
  read_only  = true
}
