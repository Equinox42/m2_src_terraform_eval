data "aws_ami" "rocky" {
  most_recent = true
  owners      = ["792107900819"] # Rocky Linux Official

  filter {
    name   = "name"
    values = ["Rocky-9-EC2-Base-9.6*"]
  }
}

resource "aws_instance" "vm" {
  count         = var.vm_count
  ami           = data.aws_ami.rocky.id
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
