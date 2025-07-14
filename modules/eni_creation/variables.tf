variable "instance_count" {
    type = number
    description = "No of instances to provision"
    default = 1
}

variable "subnet_id" {
  description = "Subnets_ID to associate the Provisining infra to"
  type = string
}

variable "security_group_ids" {
  description = "Security Groups Ids to attach to the ENI"
  type = list(string)
}


variable "tags" {
  type = map(string)
}

variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
}