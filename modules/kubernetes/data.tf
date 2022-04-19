data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_route53_zone" "current" {
  name = "${var.environment}.${var.apex_domain}"
}

data "aws_security_group" "alb" {
  name = "alb"
}

data "aws_security_group" "eks" {
  tags = {
    "aws:eks:cluster-name" = aws_eks_cluster.eks.name
  }
}

data "aws_lb" "alb" {
  name = var.environment
}

data "aws_lb_listener" "https" {
  load_balancer_arn = data.aws_lb.alb.arn
  port              = 443
}

data "aws_iam_policy_document" "trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["eks.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy" "eks" {
  for_each = toset(["AmazonEKSClusterPolicy"])
  name     = each.key
}

data "aws_autoscaling_groups" "node_group" {
  filter {
    name   = "tag:eks:cluster-name"
    values = [aws_eks_cluster.eks.name]
  }
}
