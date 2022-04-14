data "aws_iam_policy_document" "node_group_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "node_group" {
  assume_role_policy = data.aws_iam_policy_document.node_group_trust.json
  name               = "EksNodeGroupRole"
}

data "aws_iam_policy" "node_group" {
  for_each = toset(["AmazonEKSWorkerNodePolicy", "AmazonEKS_CNI_Policy", "AmazonEC2ContainerRegistryReadOnly"])
  name     = each.key
}

resource "aws_iam_role_policy_attachment" "node_group" {
  for_each   = data.aws_iam_policy.node_group
  policy_arn = each.value.arn
  role       = aws_iam_role.node_group.name
}

data "aws_ami" "eks" {
  owners      = ["amazon"]
  most_recent = true
  name_regex  = "amazon-eks-node-${var.k8s_version}-.*"
}

resource "aws_eks_node_group" "node_group" {
  for_each = {
    PublicNodeGroup = var.public_subnet_ids
  }

  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = each.key
  node_role_arn   = aws_iam_role.node_group.arn
  subnet_ids      = each.value

  scaling_config {
    desired_size = 1
    min_size     = 0
    max_size     = 1
  }

  remote_access {
    ec2_ssh_key               = var.keypair
    source_security_group_ids = []
  }

  depends_on = [aws_iam_role_policy_attachment.node_group]
}
