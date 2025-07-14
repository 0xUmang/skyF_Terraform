resource "aws_network_interface_attachment" "attach" {
  for_each = {
    for idx in range(length(var.instance_ids)) : idx => {
      instance_id = var.instance_ids[idx]
      eni_id      = var.network_interface_ids[idx]
    }
  }

  instance_id          = each.value.instance_id
  network_interface_id = each.value.eni_id
  device_index         = 1
}


