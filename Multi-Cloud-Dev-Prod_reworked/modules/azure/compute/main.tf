resource "azurerm_network_interface" "this" {
  for_each            = var.instances
  name                = "nic-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "this" {
  for_each            = var.instances
  name                = "vm-${each.key}"
  resource_group_name = var.resource_group_name
  location            = var.location
  network_interface_ids = [azurerm_network_interface.this[each.key].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = each.value.root_disk_size
  }
}