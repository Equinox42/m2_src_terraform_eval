locals {
  name_prefix = "rocky-${var.environment}"
  ssh_key     = file(var.ssh_key_path)

  # Cloud-init spécifique Rocky Linux : chemin GRUB2 différent
  cloud_init = <<-EOT
    #cloud-config
    bootcmd:
      - sed -i 's/GRUB_CMDLINE_LINUX="\(.*\)"/GRUB_CMDLINE_LINUX="\1 edd=off"/g' /etc/default/grub
      - grub2-mkconfig -o /boot/grub2/grub.cfg
    users:
      - name: ${var.vm_user}
        sudo: ALL=(ALL) NOPASSWD:ALL
        shell: /bin/bash
        ssh_authorized_keys:
          - ${local.ssh_key}
  EOT
}
