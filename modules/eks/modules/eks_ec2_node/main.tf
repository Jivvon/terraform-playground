locals {
  appset          = var.appset
  product         = var.product
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  instance_type   = var.instance_type
  node_group_name = "${local.appset}-${replace(local.instance_type, ".", "-")}-v${replace(local.cluster_version, ".", "-")}"
  node_group_role = var.node_group_role
  subnet_ids      = var.subnet_ids
  disk_size       = var.disk_size
  desired_size    = var.desired_size
  min_size        = var.min_size
  max_size        = var.max_size

  enable_taint = var.enable_default_taint
  default_taints = [
    {
      key    = "product.channel.io"
      value  = local.product
      effect = "NO_SCHEDULE"
    },
    {
      key    = "node.channel.io/appset"
      value  = local.appset
      effect = "NO_SCHEDULE"
    }
  ]

  launch_template_tag_types = ["instance", "volume", "network-interface", "spot-instances-request"]

  tags = merge(var.tags, {
    Project           = local.product
    terraformBasePath = "${var.tags.terraformBasePath}/${replace(basename(abspath(path.module)), "_", "-")}"
  })
}

resource "aws_launch_template" "this" {
  name          = "${local.node_group_name}-template"
  instance_type = local.instance_type

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = local.disk_size
      volume_type = "gp3"
    }
  }

  dynamic "tag_specifications" {
    for_each = toset(local.launch_template_tag_types)
    content {
      resource_type = tag_specifications.key
      tags          = local.tags
    }
  }
}

resource "aws_eks_node_group" "this" {
  cluster_name    = local.cluster_name
  node_group_name = local.node_group_name
  node_role_arn   = local.node_group_role.arn
  subnet_ids      = local.subnet_ids

  launch_template {
    name    = aws_launch_template.this.name
    version = aws_launch_template.this.latest_version
  }

  labels = {
    "cluster-version"               = local.cluster_version
    "node.channel.io/appset"        = local.appset
    "node.channel.io/instance-type" = local.instance_type
    "product.channel.io"            = local.product
  }

  dynamic "taint" {
    for_each = var.enable_default_taint ? local.default_taints : []

    content {
      key    = taint.value.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }

  scaling_config {
    desired_size = local.desired_size
    min_size     = local.min_size
    max_size     = local.max_size
  }

  tags = merge(
    local.tags,
    { Name = "${local.node_group_name}" }
  )

  depends_on = [
    local.node_group_role
  ]

  lifecycle {
    ignore_changes = [
      scaling_config.0.desired_size
    ]
  }
}
