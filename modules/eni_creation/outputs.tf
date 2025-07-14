output "network_interface_ids" {
  value = aws_network_interface.nic[*].id
}