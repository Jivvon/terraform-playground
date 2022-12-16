<!-- BEGIN_TF_DOCS -->
## Example

```hcl

```

## Modules

No modules.

## Resources

| Type | The Resource Spec Address | Position |
|------|---------------------------|----------|
| resource | aws_eks_addon.this | modules/eks/modules/eks_addon/main.tf#11 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | n/a | `string` | n/a | yes |
| <a name="input_configure"></a> [configure](#input\_configure) | n/a | <pre>object({<br>    name    = string<br>    version = string<br>  })</pre> | n/a | yes |
| <a name="input_resolve_conflicts"></a> [resolve\_conflicts](#input\_resolve\_conflicts) | n/a | `string` | `"OVERWRITE"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->