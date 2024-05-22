terraform {
  required_providers {
    selectel = {
      source  = "selectel/selectel"
      version = "5.0.2"
    }
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.54.1"
    }
  }
}