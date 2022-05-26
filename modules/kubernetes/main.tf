resource "aws_iam_role" "eks" {
  assume_role_policy = data.aws_iam_policy_document.trust.json
  name               = "EksClusterRole"
}

resource "aws_iam_role_policy_attachment" "eks" {
  for_each   = data.aws_iam_policy.eks
  policy_arn = each.value.arn
  role       = aws_iam_role.eks.name
}

resource "aws_eks_cluster" "eks" {
  name     = "EKS"
  role_arn = aws_iam_role.eks.arn
  version  = var.k8s_version

  vpc_config {
    subnet_ids              = concat(var.public_subnet_ids, var.private_subnet_ids)
    endpoint_private_access = false
  }
}
