resource "aws_network_interface" "nic" {
  count = var.instance_count

  subnet_id       = var.subnet_id
  security_groups = var.security_group_ids

  tags = merge(var.tags, {
    Name = "nic-${count.index}"
  })
}