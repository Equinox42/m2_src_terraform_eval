resource "libvirt_volume" "base" {
  name   = "${local.name_prefix}-base"
  # URL vers l'image cloud Rocky 9 (le lien latest pointe vers 9.x stable)
  source = "https://download.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2"
  pool   = "default"
}

resource "libvirt_volume" "os" {
  count          = var.vm_count
  name           = "${local.name_prefix}-kvm-os-${count.index}.qcow2"
  base_volume_id = libvirt_volume.base.id
  size           = var.disk_os * 1024 * 1024 * 1024
}

resource "libvirt_volume" "extra" {
  count = var.vm_count * var.extra_disk_count
  name  = "${local.name_prefix}-kvm-extra-${count.index}.qcow2"
  size  = var.disk_extra_size * 1024 * 1024 * 1024
}

resource "libvirt_cloudinit_disk" "init" {
  count     = var.vm_count
  name      = "${local.name_prefix}-init-${count.index}.iso"
  user_data = local.cloud_init
}

resource "libvirt_domain" "vm" {
  count  = var.vm_count
  name   = "${local.name_prefix}-kvm-${count.index}"
  memory = var.ram_mb
  vcpu   = var.vcpu
  cloudinit = libvirt_cloudinit_disk.init[count.index].id

  disk { volume_id = libvirt_volume.os[count.index].id; bus = "virtio" }

  dynamic "disk" {
    for_each = range(var.extra_disk_count)
    content {
      volume_id = libvirt_volume.extra[count.index * var.extra_disk_count + disk.key].id
      bus       = "virtio"
    }
  }

  network_interface { network_name = "default"; wait_for_lease = true }
}
