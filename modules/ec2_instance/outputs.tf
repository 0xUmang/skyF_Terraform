output "instance_ids" {
  value = aws_instance.ec2_instance[*].id
}

output "selected_az" {
  value = local.selected_az
}