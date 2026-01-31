## AWS Compute Module

This module handles the deployment and granular configuration of EC2 instances. It is designed to support environments (mixing Debian and Rocky Linux distributions) within a single deployment loop using for_each.


## Distribution Management

The module acts as a wrapper and does not enforce a single global AMI. The ami_id and distro context are encapsulated within the instance object. The templates/cloud_init.yaml.tftpl file leverages Terraform's template directive logic to adapt the bootstrap process at runtime:

## Features

Multi-OS Support: Dynamic management of distributions with automatic cloud-init adaptation (OS-specific GRUB commands) based on the input context.

Fail-Fast Validation: Implements lifecycle { precondition } blocks to prevent deployment if the selected AMI does not meet compliance standards (must have matching state=stable and distro tags).

Granular Configuration: Each instance carries its own definition (instance type, storage layout, AMI, OS) via a complex object map.

FinOps & Governance: Enforces standardized automatic tagging (Environment, Team, Owner, ManagedBy) for cost allocation.

Storage Management: Dynamic allocation of additional EBS volumes via dynamic blocks.

```
%{ if distro == "rocky" }
- grub2-mkconfig -o /boot/grub2/grub.cfg
%{ else }
- grub-mkconfig -o /boot/grub/grub.cfg
%{ endif }
```
## Security Mechanism (Preconditions)

Prior to resource creation, Terraform verifies the AMI tags via a data source. If the AMI is not tagged correctly according to the requested distribution, the deployment is strictly blocked to avoid silent configuration drift or runtime errors.

## Usage Example

```
module "aws_compute" {
  source = "../../modules/aws/compute"

  environment = "dev"
  team        = "SRE"
  vm_user     = "admin-user"
  ssh_key     = "ssh-rsa AAAAB3Nz..."

  # Instances Configuration
  instances = {
    "web-01" = {
      instance_type    = "t3.micro"
      root_disk_size   = 20
      extra_disk_count = 0
      extra_disk_size  = 0
      ami_id           = "ami-0abcd1234" # Debian AMI ID
      distro           = "debian"
    },
    "db-01" = {
      instance_type    = "m5.large"
      root_disk_size   = 50
      extra_disk_count = 2
      extra_disk_size  = 100
      ami_id           = "ami-0wxyz9876" # Rocky AMI ID
      distro           = "rocky"
    }
  }
}

```

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

<!-- END_TF_DOCS -->