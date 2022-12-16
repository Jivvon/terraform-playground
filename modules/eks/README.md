<!-- BEGIN_TF_DOCS -->
## Example

```hcl
locals {
  cluster_name = "devops-eks"

  cluster_role = {
    name = aws_iam_role.eks_cluster.name
    arn  = aws_iam_role.eks_cluster.arn
  }

  node_group_role = {
    name = aws_iam_role.eks_node_group.name
    arn  = aws_iam_role.eks_node_group.arn
  }

  security_group_rule = {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["172.100.0.0/16"]
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "devops-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  single_nat_gateway     = true
  enable_nat_gateway     = true
  one_nat_gateway_per_az = false
  enable_vpn_gateway     = false

  tags = {
    Environment                                   = "devops"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }
}

module "eks" {
  source = "../"

  cluster_version = "1.23"

  name               = local.cluster_name
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnets
  private_subnet_ids = module.vpc.private_subnets

  cluster_role    = local.cluster_role
  node_group_role = local.node_group_role
  service_accounts = [
    {
      app_name = "ecr-readonly" # [cluster_name]-sa-ecr-readonly-role
      service_account_names = [
        "ecr-readonly-0",
        "ecr-readonly-1"
      ]
      managed_policy_arns = [
        data.aws_iam_policy.amazon_ec2_container_registry_readonly.arn
      ]
    }
  ]

  node_groups = [
    {
      name          = "micro"
      instance_type = "t3.small"
      disk_size     = 50
      desired_size  = 1
      min_size      = 1
      max_size      = 3
    },
    {
      name          = "main"
      instance_type = "c5.large"
      disk_size     = 50
      desired_size  = 1
      min_size      = 1
      max_size      = 3
    },
    {
      name          = "general"
      instance_type = "t3.micro"
      # cluster_version = "1.23"
      disk_size    = 50
      desired_size = 1
      min_size     = 1
      max_size     = 3
    }
  ]

  addons = [
    {
      name    = "kube-proxy"
      version = "v1.23.8-eksbuild.2"
    },
    {
      name    = "vpc-cni"
      version = "v1.11.4-eksbuild.1"
    },
    {
      name    = "coredns"
      version = "v1.8.7-eksbuild.3"
    }
  ]
}

resource "aws_security_group_rule" "secondary_cidr" {
  type              = "ingress"
  from_port         = local.security_group_rule.from_port
  to_port           = local.security_group_rule.to_port
  protocol          = local.security_group_rule.protocol
  cidr_blocks       = local.security_group_rule.cidr_blocks
  security_group_id = module.eks.cluster_security_group_id
}
```

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_addons"></a> [addons](#module\_addons) | modules/eks_addon | n/a |
| <a name="module_iam"></a> [iam](#module\_iam) | modules/eks_iam | n/a |
| <a name="module_node_groups"></a> [node\_groups](#module\_node\_groups) | modules/eks_ec2_node | n/a |

## Resources

| Type | The Resource Spec Address | Position |
|------|---------------------------|----------|
| resource | aws_eks_cluster.this | modules/eks/main.tf#71 |
| resource | aws_security_group.this | modules/eks/main.tf#28 |
| resource | aws_security_group_rule.this | modules/eks/main.tf#53 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_addons"></a> [addons](#input\_addons) | n/a | <pre>list(object({<br>    name    = string<br>    version = string<br>  }))</pre> | `[]` | no |
| <a name="input_cluster_role"></a> [cluster\_role](#input\_cluster\_role) | n/a | <pre>object({<br>    name = string<br>    arn  = string<br>  })</pre> | n/a | yes |
| <a name="input_cluster_security_group_rules"></a> [cluster\_security\_group\_rules](#input\_cluster\_security\_group\_rules) | n/a | <pre>list(object({<br>    type        = optional(string, "ingress")<br>    from_port   = string<br>    to_port     = string<br>    protocol    = string<br>    cidr_blocks = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | n/a | `string` | n/a | yes |
| <a name="input_logging"></a> [logging](#input\_logging) | n/a | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_node_group_role"></a> [node\_group\_role](#input\_node\_group\_role) | n/a | <pre>object({<br>    name = string<br>    arn  = string<br>  })</pre> | n/a | yes |
| <a name="input_node_groups"></a> [node\_groups](#input\_node\_groups) | n/a | <pre>list(object({<br>    appset               = string<br>    product              = string<br>    instance_type        = string<br>    enable_default_taint = optional(bool, true)<br>    cluster_version      = optional(string)<br>    disk_size            = number<br>    desired_size         = number<br>    min_size             = number<br>    max_size             = number<br>  }))</pre> | `[]` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_service_accounts"></a> [service\_accounts](#input\_service\_accounts) | n/a | <pre>list(object({<br>    app_name              = string<br>    service_account_names = optional(list(string), [])<br>    namespace             = optional(string, "*")<br>    managed_policy_arns   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | <pre>object({<br>    Description = optional(string)<br>    Project     = optional(string)<br>    createUser  = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | n/a | <pre>object({<br>    id   = string<br>    cidr = string<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_additional_security_group_id"></a> [additional\_security\_group\_id](#output\_additional\_security\_group\_id) | n/a |
| <a name="output_cluster_security_group_id"></a> [cluster\_security\_group\_id](#output\_cluster\_security\_group\_id) | n/a |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | n/a |
| <a name="output_oidc_provider_issuer_url"></a> [oidc\_provider\_issuer\_url](#output\_oidc\_provider\_issuer\_url) | n/a |
<!-- END_TF_DOCS -->