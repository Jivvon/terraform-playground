locals {
  name            = var.name
  cluster_version = var.cluster_version
  logging         = var.logging
  vpc             = var.vpc

  security_group_name = "eks-cluster-sg-${var.name}"

  public_subnet_ids  = var.public_subnet_ids
  private_subnet_ids = var.private_subnet_ids
  subnet_ids         = concat(local.public_subnet_ids, local.private_subnet_ids)

  cluster_role     = var.cluster_role
  node_group_role  = var.node_group_role
  service_accounts = var.service_accounts

  node_groups = var.node_groups

  addons = var.addons

  oidc_provider_issuer = trimprefix(aws_eks_cluster.this.identity.0.oidc.0.issuer, "https://")

  tags = merge(var.tags, {
    terraformBasePath = "modules/${replace(basename(abspath(path.module)), "_", "-")}"
  })
}

resource "aws_security_group" "this" {
  name        = local.security_group_name
  description = "Additional security group (Control Plane security group) for EKS Cluster (${local.name})"
  vpc_id      = local.vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.vpc.cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.tags,
    { Name = local.security_group_name }
  )
}

resource "aws_security_group_rule" "this" {
  count = length(var.cluster_security_group_rules)

  type              = var.cluster_security_group_rules[count.index].type
  from_port         = var.cluster_security_group_rules[count.index].from_port
  to_port           = var.cluster_security_group_rules[count.index].to_port
  protocol          = var.cluster_security_group_rules[count.index].protocol
  cidr_blocks       = var.cluster_security_group_rules[count.index].cidr_blocks
  security_group_id = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id

  depends_on = [
    aws_eks_cluster.this
  ]
}

######################################################
# EKS
######################################################
resource "aws_eks_cluster" "this" {
  name     = local.name
  role_arn = local.cluster_role.arn
  version  = local.cluster_version

  enabled_cluster_log_types = local.logging

  vpc_config {
    security_group_ids      = [aws_security_group.this.id]
    subnet_ids              = local.subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  tags = merge(
    local.tags,
    { Name = local.name }
  )

  depends_on = [
    local.cluster_role,
    aws_security_group.this
  ]
}

module "iam" {
  source = "modules/eks_iam"

  cluster_name         = local.name
  oidc_provider_issuer = local.oidc_provider_issuer

  service_accounts = local.service_accounts

  tags = local.tags

  depends_on = [
    aws_eks_cluster.this
  ]
}

module "node_groups" {
  for_each = { for node_group in local.node_groups : "${node_group.appset}-${replace(node_group.instance_type, ".", "-")}-v${replace("${coalesce(node_group.cluster_version, local.cluster_version)}", ".", "-")}" => node_group }

  source = "modules/eks_ec2_node"

  cluster_name    = local.name
  cluster_version = coalesce(each.value.cluster_version, local.cluster_version)
  subnet_ids      = local.private_subnet_ids

  node_group_role = local.node_group_role

  appset        = each.value.appset
  product       = each.value.product
  instance_type = each.value.instance_type
  disk_size     = each.value.disk_size

  desired_size = each.value.desired_size
  min_size     = each.value.min_size
  max_size     = each.value.max_size

  enable_default_taint = each.value.enable_default_taint

  tags = local.tags

  depends_on = [
    aws_eks_cluster.this
  ]
}

module "addons" {
  for_each = { for addon in local.addons : "${addon.name}" => addon }

  source = "modules/eks_addon"

  cluster_name = local.name
  configure    = each.value

  tags = local.tags

  depends_on = [
    aws_eks_cluster.this
  ]
}
