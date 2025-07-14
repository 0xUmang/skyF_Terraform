variable "environment" {
  description = "The environment for which this provisioining is happening"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
}

variable "availability_zone" {
  description = "Preferred AZ; fallback if invalid"
  type        = string
  default     = ""
}

variable "instance_arch" {
  description = "CPU architecture"
  type        = string
  default     = "x86_64"
  validation {
    condition     = contains(["x86_64", "arm64"], var.instance_arch)
    error_message = "instance_arch must be one of x86_64 or arm64"
  }
}


variable "instance_type_map" {
  type = map(list(string))
  default = {
    "x86_64" = ["t3.micro", "t3.small", "t2.micro"]
    "arm64"  = ["t4g.micro", "t4g.small"]
  }
}


variable "ami_id" {
  description = "Custom AMI ID; fallback to Amazon AMI"
  type        = string
  default     = ""
}


variable "instance_count" {
    type = number
    description = "No of instances to provision"
    default = 1
}


variable "ebs_volume_template" {
  description = "Template for each EBS volume per EC2"
  type = object({
    size        = number
    type        = string
    device_name = string
  })
}

variable "subnet_id" {
  description = "Subnets_ID to associate the Provisining infra to"
  type = string
}


variable "tags" {
  type = map(string)
}


variable "security_groups_rules" {
  type = list(object({
    name        = string
    description = string
    vpc_id      = string
    ingress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    egress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    tags = map(string)
  }))
}