resource "aws_instance" "vm" {
  count         = var.vm_count
  ami           = "ami-0b808940562c5b369" # Debian 12 eu-west-3
  instance_type = "t3.medium"
  user_data     = local.cloud_init

  root_block_device { volume_size = var.disk_os }

  dynamic "ebs_block_device" {
    for_each = range(var.extra_disk_count)
    content {
      device_name = "/dev/sd${char(102 + ebs_block_device.key)}"
      volume_size = var.disk_extra_size
    }
  }
  tags = { Name = "${local.name_prefix}-aws-${count.index}" }
}
