locals {
  preferred_instance_types     = lookup(var.instance_type_map, var.instance_arch, ["t3.micro"])
  available_instance_types     = toset(data.aws_ec2_instance_type_offerings.available_instances.instance_types)
  selected_instance_type = try([for t in local.preferred_instance_types : t if contains(local.available_instance_types, t)][0],local.available_instance_types[0])
  selected_az = contains(data.aws_availability_zones.available.names, var.availability_zone) ? var.availability_zone : data.aws_availability_zones.available.names[0]
  selected_ami = var.ami_id != "" ? var.ami_id : data.aws_ami.default.id
}

data "aws_ec2_instance_type_offerings" "available_instances" {
  filter {
    name   = "location"
    values = [var.availability_zone]
  }

  location_type = "availability-zone"
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "default" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2*"]
  }

  filter {
    name   = "architecture"
    values = [var.instance_arch]
  }
}

resource "aws_iam_role" "ec2_ssm" {
  name = "${var.environment}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "${var.environment}-ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm.name
}


resource "aws_instance" "ec2_instance" {
  count         = var.instance_count
  ami           = local.selected_ami
  instance_type = local.selected_instance_type
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
  monitoring     = true
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  tags           = merge(var.instance_tags, {
    Name = "${var.environment}-ec2-instance-number-${count.index}"
  })
}