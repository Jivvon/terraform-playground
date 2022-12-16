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
