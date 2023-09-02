resource "azurerm_resource_group" "main" {
  name     = "rg-${var.workload}-${var.environment}-${var.main_location}"
  location = var.main_location
}

resource "azurerm_resource_group" "branch" {
  name     = "rg-${var.workload}-${var.environment}-${var.branch_location}"
  location = var.branch_location
}

resource "random_string" "random" {
  length      = 4
  special     = false
  numeric     = true
  min_numeric = 4
}

resource "azurerm_storage_account" "main" {
  name                            = "sa${var.workload}${var.environment}${var.main_location}${random_string.random.result}"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false

  #   provider = azurerm.
}

resource "azurerm_storage_container" "archive" {
  name                  = "archive"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"

  #   provider = azurerm.
}


# resource "azurerm_storage_blob" "sandbox_blob" {
#   name                   = ""
#   storage_account_name   = azurerm_storage_account.main.name
#   storage_container_name = azurerm_storage_container.archive.name
#   type                   = var.storage_blob_type

#   #   provider = azurerm.

# }

resource "azurerm_private_endpoint" "blob" {
  name                = "${azurerm_storage_account.main.name}-pe"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.main.id

  private_service_connection {
    name                           = "${azurerm_storage_account.main.name}-pe-connection"
    private_connection_resource_id = azurerm_storage_account.main.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  #   provider = azurerm.
}

resource "azurerm_private_dns_a_record" "archive" {
  name                = azurerm_storage_account.main.name
  zone_name           = azurerm_private_dns_zone.blob.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 30
  records             = [azurerm_private_endpoint.blob.private_service_connection.0.private_ip_address]
  depends_on          = [azurerm_virtual_network_peering.main, azurerm_virtual_network_peering.main]
}

resource "azurerm_network_interface" "server" {
  name                = "nic-${var.workload}-${var.environment}-${var.branch_location}"
  location            = azurerm_resource_group.branch.location
  resource_group_name = azurerm_resource_group.branch.name

  ip_configuration {
    name                          = "{var.workload}-${var.environment}-${var.branch_location}-ipconfig"
    subnet_id                     = azurerm_subnet.branch.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.server.id
  }

}
# generate random password for virtual machine
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_linux_virtual_machine" "branch" {
  name                            = "vm-${var.workload}-${var.environment}-${var.branch_location}"
  resource_group_name             = azurerm_resource_group.branch.name
  location                        = azurerm_resource_group.branch.location
  size                            = "Standard_B1ms"
  admin_username                  = "adminuser"
  admin_password                  = random_password.password.result
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.server.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}