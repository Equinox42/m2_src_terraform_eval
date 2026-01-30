resource "azurerm_resource_group" "rg" {
  name     = "${local.name_prefix}-rg"
  location = var.azure_location
}

# (Réseau Azure omis ici pour brièveté, identique à la version précédente)
# ... inclure vnet, subnet, nic ...

resource "azurerm_linux_virtual_machine" "vm" {
  count               = var.vm_count
  name                = "${local.name_prefix}-az-${count.index}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2s"
  admin_username      = var.vm_user
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]

  admin_ssh_key {
    username   = var.vm_user
    public_key = local.ssh_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = var.disk_os
  }

  source_image_reference {
    publisher = "resf"
    offer     = "rockylinux"
    sku       = "9-base"
    version   = "latest"
  }

  custom_data = base64encode(local.cloud_init)
}
# ... attachement disques identique ...
