resource "openstack_networking_network_v2" "network_1" {
  name           = "private-network"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet_1" {
  name            = "private-subnet"
  network_id      = openstack_networking_network_v2.network_1.id
  cidr            = "10.222.0.0/16"
  dns_nameservers = ["188.93.16.19", "188.93.17.19"]
  enable_dhcp     = false
}

data "openstack_networking_network_v2" "external_network_1" {
  depends_on = [openstack_networking_network_v2.network_1]
  external   = true
}

resource "openstack_networking_router_v2" "router_1" {
  name                = "router-terraform"
  external_network_id = data.openstack_networking_network_v2.external_network_1.id
}

resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id = openstack_networking_router_v2.router_1.id
  subnet_id = openstack_networking_subnet_v2.subnet_1.id
}