variable "instance_ids" {
  description = "The instances to attach the ENIs"
  type = list(string)
}

variable "availability_zone" {
  description = "The AZ in which the Instances were launched"
  type = string
}

variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
}

variable "volume_template" {
  description = "Template for each volume"
  type = object({
    size        = number
    type        = string
    device_name = string
    tags        = map(string)
  })
}