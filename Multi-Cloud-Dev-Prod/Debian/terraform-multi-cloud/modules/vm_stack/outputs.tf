output "aws_ips" { value = aws_instance.vm.*.public_ip }
output "gcp_ips" { value = google_compute_instance.vm.*.network_interface.0.access_config.0.nat_ip }
output "az_ips"  { value = azurerm_linux_virtual_machine.vm.*.public_ip_address }
output "kvm_ips" { value = libvirt_domain.vm.*.network_interface.0.addresses }
