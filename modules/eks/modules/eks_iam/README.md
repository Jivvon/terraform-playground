<!-- BEGIN_TF_DOCS -->
## Example

```hcl

```

## Modules

No modules.

## Resources

| Type | The Resource Spec Address | Position |
|------|---------------------------|----------|
| resource | aws_iam_openid_connect_provider.this | modules/eks/modules/eks_iam/main.tf#30 |
| resource | aws_iam_role.sa_assume_roles | modules/eks/modules/eks_iam/main.tf#72 |
| resource | aws_iam_role_policy_attachment.sa_assume_role_attachments | modules/eks/modules/eks_iam/main.tf#86 |
| data source | aws_iam_policy_document.sa_assume_role_policy_documents | modules/eks/modules/eks_iam/main.tf#48 |
| data source | tls_certificate.this | modules/eks/modules/eks_iam/main.tf#26 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | n/a | `string` | n/a | yes |
| <a name="input_oidc_provider_issuer"></a> [oidc\_provider\_issuer](#input\_oidc\_provider\_issuer) | n/a | `string` | n/a | yes |
| <a name="input_service_accounts"></a> [service\_accounts](#input\_service\_accounts) | n/a | <pre>list(object({<br>    app_name              = string<br>    service_account_names = list(string)<br>    namespace             = string<br>    managed_policy_arns   = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | n/a |
<!-- END_TF_DOCS -->