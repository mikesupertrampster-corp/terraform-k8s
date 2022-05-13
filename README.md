# Terraform Kubernetes

Terraform deployment of kubernetes (currently onto AWS).

[![Snyk Infrastructure as Code](https://github.com/mikesupertrampster-corp/terraform-k8s/actions/workflows/snyk.yml/badge.svg)](https://github.com/mikesupertrampster-corp/terraform-k8s/actions/workflows/snyk.yml) [![gitleaks](https://github.com/mikesupertrampster-corp/terraform-k8s/actions/workflows/gitleaks.yml/badge.svg)](https://github.com/mikesupertrampster-corp/terraform-k8s/actions/workflows/gitleaks.yml) [![Codacy Badge](https://app.codacy.com/project/badge/Grade/819228fdf6a14e6e823a99bd0c2a0946)](https://www.codacy.com/gh/mikesupertrampster-corp/terraform-k8s/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=mikesupertrampster-corp/terraform-k8s&amp;utm_campaign=Badge_Grade) [![Infracost estimate](https://img.shields.io/badge/Infracost-estimate-5e3f62)](https://dashboard.infracost.io/share/aa9rgpcav4ordvigfr08e9zpjrp4d3qf)

## Resources

  * EKS Cluster
  * Managed Node Group
  * Flux v2

## Cost

Estimate cost generated using [Infracost](https://github.com/Infracost/infracost)

```
 Name                                                                     Monthly Qty  Unit                  Monthly Cost 
                                                                                                                          
 module.kubernetes.aws_eks_cluster.eks                                                                                    
 └─ EKS cluster                                                                   730  hours                       $73.00 
                                                                                                                          
 module.kubernetes.aws_eks_node_group.node_group["PublicNodeGroup"]                                                       
 ├─ Instance usage (Linux/UNIX, spot, t3.medium)                                  730  hours                       $10.00 
 └─ Storage (general purpose SSD, gp2)                                             20  GB                           $2.20 
                                                                                                                          
 module.kubernetes.aws_route53_record.ingress                                                                             
 ├─ Standard queries (first 1B)                                      Monthly cost depends on usage: $0.40 per 1M queries  
 ├─ Latency based routing queries (first 1B)                         Monthly cost depends on usage: $0.60 per 1M queries  
 └─ Geo DNS queries (first 1B)                                       Monthly cost depends on usage: $0.70 per 1M queries  
                                                                                                                          
 OVERALL TOTAL                                                                                                     $85.20 
──────────────────────────────────
16 cloud resources were detected:
∙ 3 were estimated, 2 of which include usage-based costs, see https://infracost.io/usage-file
∙ 13 were free:
  ∙ 4 x aws_iam_role_policy_attachment
  ∙ 3 x aws_iam_role
  ∙ 2 x aws_security_group_rule
  ∙ 1 x aws_iam_openid_connect_provider
  ∙ 1 x aws_iam_role_policy
  ∙ 1 x aws_lb_listener_rule
  ∙ 1 x aws_lb_target_group
```