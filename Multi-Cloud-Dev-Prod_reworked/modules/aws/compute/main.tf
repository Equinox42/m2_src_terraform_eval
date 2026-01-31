resource "aws_instance" "this" {
  for_each      = var.instances
  ami           = each.value.ami_id
  instance_type = var.environment == "dev" ? "t3.micro" : each.value.instance_type
  user_data     = local.cloud_init_content


  root_block_device {
    volume_size = each.value.root_disk_size
  }

  dynamic "ebs_block_device" {
    for_each = range(each.value.extra_disk_count)
    content {
      device_name = "/dev/sd${char(102 + ebs_block_device.key)}"
      volume_size = each.value.extra_disk_size
    }
  }

  tags = merge(local.common_tags, { Name = "${each.value.distro}-${var.environment}-aws-${each.key}" })

  lifecycle {

    precondition {
      condition = (
        try(data.aws_ami.selected[each.key].tags["state"], "") == "stable" &&
        try(data.aws_ami.selected[each.key].tags["distro"], "") == each.value.distro
      )
      error_message = "The selected AMI for ${each.key} is invalid, it must have both tags, state = stable AND distro = rocky OR distro = debian"
    }
  }

}