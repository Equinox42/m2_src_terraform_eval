data "aws_ami" "selected" {
  for_each = var.instances
  id       = each.value.ami_id
}