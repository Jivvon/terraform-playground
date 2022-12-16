<!-- BEGIN_TF_DOCS -->
## Example

```hcl

```

## Modules

No modules.

## Resources

| Type | The Resource Spec Address | Position |
|------|---------------------------|----------|
| resource | aws_eks_node_group.this | modules/eks/modules/eks_ec2_node/main.tf#58 |
| resource | aws_launch_template.this | modules/eks/modules/eks_ec2_node/main.tf#37 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_appset"></a> [appset](#input\_appset) | n/a | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | n/a | `string` | n/a | yes |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | n/a | `string` | n/a | yes |
| <a name="input_desired_size"></a> [desired\_size](#input\_desired\_size) | n/a | `number` | `1` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | n/a | `number` | `50` | no |
| <a name="input_enable_default_taint"></a> [enable\_default\_taint](#input\_enable\_default\_taint) | n/a | `bool` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | n/a | `string` | n/a | yes |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | n/a | `number` | `3` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | n/a | `number` | `1` | no |
| <a name="input_node_group_role"></a> [node\_group\_role](#input\_node\_group\_role) | n/a | <pre>object({<br>    name = string<br>    arn  = string<br>  })</pre> | n/a | yes |
| <a name="input_product"></a> [product](#input\_product) | n/a | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->