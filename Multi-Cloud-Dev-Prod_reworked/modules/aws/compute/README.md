<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.6.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_ami.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | AMI ID of the instance - must be tagged with stable | `string` | n/a | yes |
| <a name="input_distro"></a> [distro](#input\_distro) | OS Distribution expected | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment to deploy, either dev or prod | `string` | n/a | yes |
| <a name="input_instances"></a> [instances](#input\_instances) | Instances Configuration | <pre>map(object({<br/>    instance_type    = string<br/>    root_disk_size   = number<br/>    extra_disk_count = number<br/>    extra_disk_size  = number<br/>    ami_id           = string<br/>    distro           = string<br/>  }))</pre> | n/a | yes |
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | content of the ssh public key | `string` | n/a | yes |
| <a name="input_team"></a> [team](#input\_team) | Team name, this is used for budget tracking | `string` | n/a | yes |
| <a name="input_vm_user"></a> [vm\_user](#input\_vm\_user) | User of the VM | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->