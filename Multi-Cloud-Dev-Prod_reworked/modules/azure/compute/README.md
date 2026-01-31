<!-- BEGIN_TF_DOCS -->

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.6.6 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_shared_image_versions.images](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/shared_image_versions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment to deploy, either dev or prod | `string` | n/a | yes |
| <a name="input_gallery_name"></a> [gallery\_name](#input\_gallery\_name) | Name of the Azure Compute Gallery (Shared Image Gallery) | `string` | n/a | yes |
| <a name="input_gallery_resource_group_name"></a> [gallery\_resource\_group\_name](#input\_gallery\_resource\_group\_name) | Resource Group where the Gallery is located | `string` | n/a | yes |
| <a name="input_image_tag_filter"></a> [image\_tag\_filter](#input\_image\_tag\_filter) | Tag filter to select the stable image version (e.g. { status = 'stable' }) | `map(string)` | <pre>{<br/>  "status": "stable"<br/>}</pre> | no |
| <a name="input_instances"></a> [instances](#input\_instances) | Configuration of the VMs | <pre>map(object({<br/>    instance_type    = string<br/>    root_disk_size   = number<br/>    extra_disk_count = number<br/>    extra_disk_size  = number<br/>    distro           = string<br/>  }))</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure Region | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Azure resource groupe name | `string` | n/a | yes |
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | content of the public key | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID of subnet where NICs should be placed | `string` | n/a | yes |
| <a name="input_team"></a> [team](#input\_team) | Team name, this is used for budget tracking | `string` | n/a | yes |
| <a name="input_vm_user"></a> [vm\_user](#input\_vm\_user) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->