resource "aws_ebs_volume" "ebs_vol_per_ec2" {
  for_each = toset(var.instance_ids)
  availability_zone = var.availability_zone
  size              = var.volume_template.size
  type              = var.volume_template.type
  tags              = var.volume_template.tags
}

resource "aws_volume_attachment" "attach" {
  for_each = aws_ebs_volume.ebs_vol_per_ec2
  instance_id = each.key
  volume_id   = each.value.id
  device_name = var.volume_template.device_name
}
