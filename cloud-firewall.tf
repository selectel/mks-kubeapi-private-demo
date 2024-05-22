resource "openstack_fw_policy_v2" "firewall_policy_1" {
  name    = "ingress-firewall-policy"
  audited = true
  rules = [
    openstack_fw_rule_v2.rule_1.id,
    openstack_fw_rule_v2.rule_2.id,
    openstack_fw_rule_v2.rule_3.id,
    openstack_fw_rule_v2.rule_4.id,
    openstack_fw_rule_v2.rule_5.id,
    openstack_fw_rule_v2.rule_6.id,
  ]
}

resource "openstack_fw_rule_v2" "rule_1" {
  name              = "allow-udp-188.93.16.19-53"
  action            = "allow"
  protocol          = "udp"
  source_ip_address = "188.93.16.19"
  source_port       = "53"
}

resource "openstack_fw_rule_v2" "rule_2" {
  name              = "allow-udp-188.93.17.19-53"
  action            = "allow"
  protocol          = "udp"
  source_ip_address = "188.93.17.19"
  source_port       = "53"
}

resource "openstack_fw_rule_v2" "rule_3" {
  name              = "allow-udp-92.53.68.16-443"
  action            = "allow"
  protocol          = "tcp"
  source_ip_address = "92.53.68.16"
  source_port       = "443"
}

resource "openstack_fw_rule_v2" "rule_4" {
  name              = "allow-udp-85.119.149.24-443"
  action            = "allow"
  protocol          = "tcp"
  source_ip_address = "85.119.149.24"
  source_port       = "443"
}

resource "openstack_fw_rule_v2" "rule_5" {
  name              = "allow-occm-443"
  action            = "allow"
  protocol          = "tcp"
  source_ip_address = "95.213.160.182"
  source_port       = "443"
}

resource "openstack_fw_rule_v2" "rule_6" {
  name                   = "allow-to-cloud-server"
  action                 = "allow"
  protocol               = "any"
  destination_ip_address = openstack_networking_floatingip_v2.floatingip_1.fixed_ip
}

resource "openstack_fw_policy_v2" "firewall_policy_2" {
  name    = "egress-firewall-policy"
  audited = true
  rules = [
    openstack_fw_rule_v2.rule_01.id,
    openstack_fw_rule_v2.rule_02.id,
    openstack_fw_rule_v2.rule_03.id,
    openstack_fw_rule_v2.rule_04.id,
    openstack_fw_rule_v2.rule_05.id,
  ]
}

resource "openstack_fw_rule_v2" "rule_01" {
  name                   = "allow-udp-188.93.16.19-53"
  action                 = "allow"
  protocol               = "udp"
  destination_ip_address = "188.93.16.19"
  destination_port       = "53"
}

resource "openstack_fw_rule_v2" "rule_02" {
  name                   = "allow-udp-188.93.17.19-53"
  action                 = "allow"
  protocol               = "udp"
  destination_ip_address = "188.93.17.19"
  destination_port       = "53"
}

resource "openstack_fw_rule_v2" "rule_03" {
  name                   = "allow-udp-92.53.68.16-443"
  action                 = "allow"
  protocol               = "tcp"
  destination_ip_address = "92.53.68.16"
  destination_port       = "443"
}

resource "openstack_fw_rule_v2" "rule_04" {
  name                   = "allow-udp-85.119.149.24-443"
  action                 = "allow"
  protocol               = "tcp"
  destination_ip_address = "85.119.149.24"
  destination_port       = "443"
}

resource "openstack_fw_rule_v2" "rule_05" {
  name                   = "occm-443"
  action                 = "allow"
  protocol               = "tcp"
  destination_ip_address = "95.213.160.182"
  destination_port       = "443"
}

resource "openstack_fw_group_v2" "group_1" {
  name                       = "my-firewall"
  admin_state_up             = true
  ingress_firewall_policy_id = openstack_fw_policy_v2.firewall_policy_1.id
  egress_firewall_policy_id  = openstack_fw_policy_v2.firewall_policy_2.id
  ports = [
    openstack_networking_router_interface_v2.router_interface_1.port_id,
  ]
}
