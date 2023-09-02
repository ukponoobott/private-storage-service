## Vnet Peering between subscriptions
This terraform code configures vnet peering between subcriptions.
A virtual machine and a private dns zone are deployed in the default subcription while a storage account and a private endpoint are deployed in remote subscription.
Public access is disabled in the storage so communication can only be possible through the private endpont.
Note that for container creation to be possible in the storage account, the variable: _public_network_access_enabled_ must be set to true. It can then be set to false after container creation.
## Test connectivity
To test conncetivity, login to the dev virtual machine with the randomly generated password securely stored in the terraform.tfstate file and do the following: 
* nslookup StorageAccountName.privatelink.blob.core.windows.net  //This should show the private ip address of the storage account.
*  az storage blob list --container-name sandbox-container --connection-string StorageAccountConnectionString  //This is to list the blob created in the container. This command is possible after installing azure cli.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.50.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.50.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine.branch](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.server](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/network_interface) | resource |
| [azurerm_network_security_group.branch](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/network_security_group) | resource |
| [azurerm_network_security_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/network_security_group) | resource |
| [azurerm_private_dns_a_record.archive](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_zone.blob](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.main](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_endpoint.blob](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/private_endpoint) | resource |
| [azurerm_public_ip.server](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/public_ip) | resource |
| [azurerm_resource_group.branch](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/resource_group) | resource |
| [azurerm_storage_account.main](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/storage_account) | resource |
| [azurerm_storage_container.archive](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/storage_container) | resource |
| [azurerm_subnet.branch](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/subnet) | resource |
| [azurerm_subnet.main](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.branch](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_network_security_group_association.main](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_network.branch](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network.main](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network_peering.branch](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/virtual_network_peering) | resource |
| [azurerm_virtual_network_peering.main](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/virtual_network_peering) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/3.5.1/docs/resources/password) | resource |
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/3.5.1/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_branch_location"></a> [branch\_location](#input\_branch\_location) | (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | `"westus2"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Required) The environment in which the resources are been created. | `string` | `"dev"` | no |
| <a name="input_main_location"></a> [main\_location](#input\_main\_location) | (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | `"eastus2"` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | (Required) The workload of the resource created. | `string` | `"demo"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->