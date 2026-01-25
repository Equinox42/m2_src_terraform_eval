resource "google_compute_instance" "vm" {
  count        = var.vm_count
  name         = "${local.name_prefix}-gcp-${count.index}"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = var.disk_os
    }
  }

  network_interface { network = "default"; access_config {} }

  metadata = { user-data = local.cloud_init }
}

resource "google_compute_disk" "extra" {
  count = var.vm_count * var.extra_disk_count
  name  = "${local.name_prefix}-gcp-disk-${count.index}"
  size  = var.disk_extra_size
}

resource "google_compute_attached_disk" "attach" {
  count    = var.vm_count * var.extra_disk_count
  instance = google_compute_instance.vm[floor(count.index / var.extra_disk_count)].id
  disk     = google_compute_disk.extra[count.index].id
}
