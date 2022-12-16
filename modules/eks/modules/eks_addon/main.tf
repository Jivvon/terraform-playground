locals {
  cluster_name      = var.cluster_name
  configure         = var.configure
  resolve_conflicts = var.resolve_conflicts

  tags = merge(var.tags, {
    terraformBasePath = "modules/${replace(basename(abspath(path.module)), "_", "-")}"
  })
}

resource "aws_eks_addon" "this" {
  cluster_name  = local.cluster_name
  addon_name    = local.configure.name
  addon_version = local.configure.version

  resolve_conflicts = local.resolve_conflicts

  tags = merge(
    local.tags,
    { Name = "${local.configure.name}" }
  )
}
