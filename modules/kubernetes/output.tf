output "cluster" {
  value = aws_eks_cluster.eks
}

output "target_group" {
  value = {
    arn = aws_lb_target_group.ingress.arn
  }
}