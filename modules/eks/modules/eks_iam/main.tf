locals {
  cluster_name = var.cluster_name

  oidc_provider_arn        = aws_iam_openid_connect_provider.this.arn
  oidc_provider_issuer     = var.oidc_provider_issuer
  oidc_provider_issuer_url = "https://${var.oidc_provider_issuer}"

  service_account_role_policies = distinct(flatten([
    for sa in var.service_accounts : [
      for policy_arn in sa.managed_policy_arns : {
        role       = "${local.cluster_name}-sa-${sa.app_name}-role"
        policy_arn = "${policy_arn}"
      }
    ]
  ]))

  tags = merge(var.tags, {
    terraformBasePath = "${var.tags.terraformBasePath}/${replace(basename(abspath(path.module)), "_", "-")}"
  })
}

################################################################################
# Identity Provider
################################################################################

data "tls_certificate" "this" {
  url = local.oidc_provider_issuer_url
}

resource "aws_iam_openid_connect_provider" "this" {
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [
    data.tls_certificate.this.certificates.0.sha1_fingerprint
  ]
  url = local.oidc_provider_issuer_url

  tags = merge(
    local.tags,
    { Name = "${var.cluster_name}-oidc-provider" }
  )
}

################################################################################
# IAM Policy
################################################################################

# TODO: 각 Policy에 대해 세분화된 값을 받을 수 있도록 수정
data "aws_iam_policy_document" "sa_assume_role_policy_documents" {
  for_each = { for sa in var.service_accounts : sa.app_name => sa }

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [local.oidc_provider_arn]
    }

    condition {
      test     = "StringLike"
      variable = "${local.oidc_provider_issuer}:sub"
      values = formatlist("system:serviceaccount:${each.value.namespace}:%s",
      length(each.value.service_account_names) > 0 ? each.value.service_account_names : [each.value.app_name])
    }
  }
}

################################################################################
# IAM Role
################################################################################

resource "aws_iam_role" "sa_assume_roles" {
  for_each = { for sa in var.service_accounts : sa.app_name => sa }

  name               = "${var.cluster_name}-sa-${each.value.app_name}-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.sa_assume_role_policy_documents[each.value.app_name].json


  tags = merge(
    local.tags,
    { Name = "${var.cluster_name}-sa-${each.value.app_name}-role" }
  )
}

resource "aws_iam_role_policy_attachment" "sa_assume_role_attachments" {
  count = length(local.service_account_role_policies)

  policy_arn = element(local.service_account_role_policies, count.index).policy_arn
  role       = element(local.service_account_role_policies, count.index).role

  depends_on = [
    aws_iam_role.sa_assume_roles
  ]
}
