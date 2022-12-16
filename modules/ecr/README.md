<!-- BEGIN_TF_DOCS -->
## Example

```hcl
module "example" {
  source = ".."
  name   = "lento-test"
}
```

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_example"></a> [example](#module\_example) | .. | n/a |

## Resources

| Type | The Resource Spec Address | Position |
|------|---------------------------|----------|
| resource | aws_ecr_repository.this | modules/ecr/main.tf#5 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | ECR Repository name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repository_url"></a> [repository\_url](#output\_repository\_url) | Repository URL |
| <a name="output_test_output"></a> [test\_output](#output\_test\_output) | n/a |
<!-- END_TF_DOCS -->