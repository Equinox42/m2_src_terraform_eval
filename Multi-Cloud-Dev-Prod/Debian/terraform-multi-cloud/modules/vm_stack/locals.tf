locals {
  name_prefix = "debian-${var.environment}"
  ssh_key     = file(var.ssh_key_path)

  cloud_init = <<-EOT
    #cloud-config
    bootcmd:
      - sed -i 's/GRUB_CMDLINE_LINUX="\(.*\)"/GRUB_CMDLINE_LINUX="\1 edd=off"/g' /etc/default/grub
      - grub-mkconfig -o /boot/grub/grub.cfg
    users:
      - name: ${var.vm_user}
        sudo: ALL=(ALL) NOPASSWD:ALL
        shell: /bin/bash
        ssh_authorized_keys:
          - ${local.ssh_key}
  EOT
}
