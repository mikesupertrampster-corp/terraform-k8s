resource "aws_lb_target_group" "ingress" {
  name                 = "ingress"
  port                 = 30080
  protocol             = "HTTP"
  target_type          = "instance"
  deregistration_delay = 5
  vpc_id               = var.vpc_id

  health_check {
    path = "/healthz"
  }
}

resource "aws_route53_record" "ingress" {
  zone_id = data.aws_route53_zone.current.zone_id
  name    = "*.${data.aws_route53_zone.current.name}"
  type    = "A"

  alias {
    name                   = data.aws_lb.alb.dns_name
    zone_id                = data.aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_lb_listener_rule" "ingress" {
  listener_arn = data.aws_lb_listener.https.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ingress.arn
  }

  condition {
    host_header {
      values = [aws_route53_record.ingress.name]
    }
  }
}

resource "aws_security_group_rule" "ingress" {
  for_each                 = toset(["30080", "30443"])
  security_group_id        = data.aws_security_group.eks.id
  from_port                = each.key
  to_port                  = each.key
  protocol                 = "tcp"
  source_security_group_id = data.aws_security_group.alb.id
  type                     = "ingress"
}

// Note: Requires commenting out to begin with.
#resource "aws_autoscaling_attachment" "node_group" {
#  for_each               = toset(data.aws_autoscaling_groups.node_group.names)
#  autoscaling_group_name = each.value
#  lb_target_group_arn    = aws_lb_target_group.ingress.arn
#
#  depends_on = [aws_eks_node_group.node_group]
#}
