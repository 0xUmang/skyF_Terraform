resource "aws_security_group" "security_g" {
  for_each = { for sg in var.security_groups : sg.name => sg }

  name        = each.value.name
  description = each.value.description
  vpc_id      = each.value.vpc_id
  tags        = each.value.tags
}

resource "aws_vpc_security_group_ingress_rule" "ingress" {
  for_each = {
    for sg in var.security_groups :
    for rule in sg.ingress :
    "${sg.name}-ingress-${rule.from_port}-${rule.to_port}" => {
      sg_name    = sg.name
      rule       = rule
    }
  }

  from_port         = each.value.rule.from_port
  to_port           = each.value.rule.to_port
  ip_protocol       = each.value.rule.protocol
  cidr_blocks       = each.value.rule.cidr_blocks
  security_group_id = aws_security_group.security_g[each.value.sg_name].id
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  for_each = {
    for sg in var.security_groups :
    for rule in sg.egress :
    "${sg.name}-egress-${rule.from_port}-${rule.to_port}" => {
      sg_name    = sg.name
      rule       = rule
    }
  }

  from_port         = each.value.rule.from_port
  to_port           = each.value.rule.to_port
  ip_protocol       = each.value.rule.protocol
  cidr_blocks       = each.value.rule.cidr_blocks
  security_group_id = aws_security_group.security_g[each.value.sg_name].id
}
