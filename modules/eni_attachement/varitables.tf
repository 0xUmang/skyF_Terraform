variable "instance_ids" {
  description = "The instances to attach the ENIs"
  type = list(string)
}
variable "network_interface_ids" {
  description = "The ENIs to attach the EC2 instances" 
  type = list(string)
}
variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
}