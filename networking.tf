resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.workload}-${var.environment}-${var.main_location}-main"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  address_space       = ["10.0.0.0/16"]

  #   provider = azurerm.
}

resource "azurerm_virtual_network_peering" "main" {
  name                      = "main-to-branch"
  resource_group_name       = azurerm_resource_group.main.name
  virtual_network_name      = azurerm_virtual_network.main.name
  remote_virtual_network_id = azurerm_virtual_network.branch.id
}

resource "azurerm_virtual_network_peering" "branch" {
  name                      = "branch-to-main"
  resource_group_name       = azurerm_resource_group.branch.name
  virtual_network_name      = azurerm_virtual_network.branch.name
  remote_virtual_network_id = azurerm_virtual_network.main.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  name                  = "main-link"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = azurerm_virtual_network.main.id
  registration_enabled  = false
}

resource "azurerm_subnet" "main" {
  name                                      = "snet-${var.workload}-${var.environment}-${var.main_location}-storage"
  resource_group_name                       = azurerm_resource_group.main.name
  virtual_network_name                      = azurerm_virtual_network.main.name
  address_prefixes                          = ["10.0.1.0/24"]
  private_endpoint_network_policies_enabled = true

  #   provider = azurerm.
}


resource "azurerm_virtual_network" "branch" {
  name                = "vnet-${var.workload}-${var.environment}-${var.branch_location}-main"
  resource_group_name = azurerm_resource_group.branch.name
  location            = azurerm_resource_group.branch.location
  address_space       = ["168.0.0.0/16"]

}

resource "azurerm_subnet" "branch" {
  name                 = "snet-${var.workload}-${var.environment}-${var.branch_location}"
  resource_group_name  = azurerm_resource_group.branch.name
  virtual_network_name = azurerm_virtual_network.branch.name
  address_prefixes     = ["168.0.1.0/24"]
}

resource "azurerm_public_ip" "server" {
  name                = "pip-${var.workload}-${var.environment}-${var.branch_location}"
  resource_group_name = azurerm_resource_group.branch.name
  location            = azurerm_resource_group.branch.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_security_group" "main" {
  name                = "nsg-${var.workload}-${var.environment}-${var.main_location}-main"
  location            = azurerm_resource_group.branch.location
  resource_group_name = azurerm_resource_group.branch.name

  #   security_rule {
  #     name                       = "Allow-SSH"
  #     priority                   = 101
  #     direction                  = "Inbound"
  #     access                     = "Allow"
  #     protocol                   = "Tcp"
  #     source_port_range          = "*"
  #     destination_port_range     = "22"
  #     source_address_prefix      = "*"
  #     destination_address_prefix = "VirtualNetwork"
  #   }

}

resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.main.id
  network_security_group_id = azurerm_network_security_group.main.id

  #   provider = azurerm.

}

resource "azurerm_network_security_group" "branch" {
  name                = "nsg-${var.workload}-${var.environment}-${var.branch_location}-branch"
  location            = azurerm_resource_group.branch.location
  resource_group_name = azurerm_resource_group.branch.name

  security_rule {
    name                       = "Allow"
    priority                   = 201
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }
  #   provider = azurerm.

}

resource "azurerm_subnet_network_security_group_association" "branch" {
  subnet_id                 = azurerm_subnet.branch.id
  network_security_group_id = azurerm_network_security_group.branch.id

  #   provider = azurerm.

}