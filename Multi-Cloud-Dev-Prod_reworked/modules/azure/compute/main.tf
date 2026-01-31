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
  name                = "vm-${var.environment}-${each.key}"
  resource_group_name = var.resource_group_name
  location            = var.location
  network_interface_ids = [azurerm_network_interface.this[each.key].id]
  size = var.environment == "dev" ? "Standard_B1": each.value.instance_size
  source_image_id = local.latest_stable_images[each.value.distro]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = each.value.root_disk_size
  }

  admin_ssh_key {
    username   = var.vm_user
    public_key = var.ssh_key
  }

}

## Unfortunately, lack of knowledge on azure and time to try to refactor theses two ressources. 

# resource "azurerm_managed_disk" "extra" {
#   count                = var.vm_count * var.extra_disk_count
#   name                 = "${local.name_prefix}-az-disk-${count.index}"
#   location             = azurerm_resource_group.rg.location
#   resource_group_name  = azurerm_resource_group.rg.name
#   storage_account_type = "Standard_LRS"
#   create_option        = "Empty"
#   disk_size_gb         = var.disk_extra_size
# }

# resource "azurerm_virtual_machine_data_disk_attachment" "attach" {
#   count              = var.vm_count * var.extra_disk_count
#   managed_disk_id    = azurerm_managed_disk.extra[count.index].id
#   virtual_machine_id = azurerm_linux_virtual_machine.vm[floor(count.index / var.extra_disk_count)].id
#   lun                = (count.index % var.extra_disk_count) + 10
#   caching            = "ReadWrite"
# }