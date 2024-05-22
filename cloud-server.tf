resource "selectel_vpc_keypair_v2" "keypair_1" {
  name       = "keypair"
  public_key = file("~/.ssh/id_rsa.pub")
  user_id    = selectel_iam_serviceuser_v1.serviceuser_1.id
  regions    = ["ru-9"]
}
#TODO id_rsa

resource "openstack_compute_flavor_v2" "flavor_1" {
  name      = "custom-flavor"
  vcpus     = 2
  ram       = 2048
  disk      = 0
  is_public = false

  lifecycle {
    create_before_destroy = true
  }
}

resource "openstack_networking_port_v2" "port_1" {
  name       = "cloud-server-port"
  network_id = openstack_networking_network_v2.network_1.id

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet_1.id
  }
}

data "openstack_images_image_v2" "image_1" {
  depends_on  = [selectel_vpc_project_v2.project_1]
  name        = "Ubuntu 22.04 LTS 64-bit"
  most_recent = true
  visibility  = "public"
}

resource "openstack_blockstorage_volume_v3" "volume_1" {
  name        = "cloud-server-boot-volume"
  size        = "5"
  image_id    = data.openstack_images_image_v2.image_1.id
  volume_type = "fast.ru-9a"

  lifecycle {
    ignore_changes = [image_id]
  }
}

#### Create server

resource "openstack_compute_instance_v2" "server_1" {
  name              = "cloud-server"
  flavor_id         = openstack_compute_flavor_v2.flavor_1.id
  key_pair          = selectel_vpc_keypair_v2.keypair_1.name
  availability_zone = "ru-9a"

  network {
    port = openstack_networking_port_v2.port_1.id
  }

  lifecycle {
    ignore_changes = [image_id]
  }

  block_device {
    uuid             = openstack_blockstorage_volume_v3.volume_1.id
    source_type      = "volume"
    destination_type = "volume"
    boot_index       = 0
  }

}

resource "openstack_networking_floatingip_v2" "floatingip_1" {
  pool = "external-network"
}

resource "openstack_networking_floatingip_associate_v2" "association_1" {
  port_id     = openstack_networking_port_v2.port_1.id
  floating_ip = openstack_networking_floatingip_v2.floatingip_1.address
}

output "public_ip_address" {
  value = openstack_networking_floatingip_v2.floatingip_1.address
}