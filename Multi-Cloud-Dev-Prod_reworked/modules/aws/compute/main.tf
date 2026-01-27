resource "aws_instance" "vm" {
  for_each      = var.instances
  ami           = var.ami_id
  instance_type = var.environment == "dev" ? "t3.micro" : each.value.instance_type
  

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

  tags = {
    Name = "${local.name_prefix}-aws-${each.key}"
  }

      lifecycle {
    
    precondition {
        condition     = can(data.aws_ami.db_ami.tags["Stable"])
        error_message = "The selected AMI must be stable"
    }

    }
}
