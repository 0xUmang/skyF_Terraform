variable "instance_count" {
    type = number
    description = "No of instances to provision"
    default = 1
}

variable "availability_zone" {
  description = "Preferred AZ for EC2"
  type        = string
  default     = ""  
}

variable "instance_arch" {
  description = "Architecture for the EC2 instance."
  type        = string
  default     = "x86_64" 

  validation {
    condition     = contains(["x86_64", "arm64"], var.instance_arch)
    error_message = "Invalid architecture. Must be one of: x86_64 or arm64."
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


variable "subnet_id" {
  description = "Subnets_ID to associate the Provisining infra to"
  type = string
}


variable "security_group_ids" {
  description = "Security Groups Ids to attach to the EC2"
  type = list(string)
}

variable "instance_tags" {
  description = "Tags to give on the instance"
  type = map(string)
}

variable "environment" {
  description = "The environment for which this provisioining is happening"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
}
