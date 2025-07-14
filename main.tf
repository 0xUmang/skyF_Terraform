module "security_groups" {
  source          = "./modules/security_groups"
  security_groups_rules = var.security_groups_rules
}

module "ec2_instance" {
  source                   = "./modules/ec2_instance"
  environment              = var.environment
  aws_region               = var.aws_region
  availability_zone        = var.availability_zone
  instance_arch            = var.instance_arch
  instance_type_map        = var.instance_type_map
  instance_count           = var.instance_count
  ami_id                   = var.ami_id
  subnet_id                = var.subnet_id
  security_group_ids       = values(module.security_groups.security_group_ids)
  instance_tags            = var.tags
}

module "eni_creation" {
  source             = "./modules/eni_creation"
  instance_count     = var.instance_count
  aws_region         = var.aws_region
  subnet_id          = var.subnet_id
  security_group_ids = values(module.security_groups.security_group_ids)
  tags               = var.tags
}

module "eni_attachement" {
  source                   = "./modules/eni_attachement"
  instance_ids             = module.ec2_instance.instance_ids
  network_interface_ids    = module.eni_creation.network_interface_ids
  aws_region               = var.aws_region
}

module "ebs_volumes" {
  source             = "./modules/ebs_volumes"
  instance_ids       = module.ec2_instance.instance_ids
  availability_zone  = module.ec2_instance.selected_az
  aws_region         = var.aws_region
  volume_template = merge(
    var.ebs_volume_template,
    { tags = var.tags }
  )
}
