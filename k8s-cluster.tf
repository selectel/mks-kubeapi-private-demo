data "selectel_mks_kube_versions_v1" "versions" {
  project_id = selectel_vpc_project_v2.project_1.id
  region     = "ru-9"
}

resource "selectel_mks_cluster_v1" "cluster_1" {
  name                              = "terraform-k8s-cluster"
  project_id                        = selectel_vpc_project_v2.project_1.id
  region                            = "ru-9"
  kube_version                      = data.selectel_mks_kube_versions_v1.versions.latest_version
  network_id                        = openstack_networking_network_v2.network_1.id
  subnet_id                         = openstack_networking_subnet_v2.subnet_1.id
  maintenance_window_start          = "00:00:00"
  enable_patch_version_auto_upgrade = false
  private_kube_api                  = true
}

resource "selectel_mks_nodegroup_v1" "nodegroup_1" {
  depends_on        = [selectel_mks_cluster_v1.cluster_1]
  cluster_id        = selectel_mks_cluster_v1.cluster_1.id
  project_id        = selectel_mks_cluster_v1.cluster_1.project_id
  region            = selectel_mks_cluster_v1.cluster_1.region
  availability_zone = "ru-9a"
  nodes_count       = "1"
  cpus              = 2
  ram_mb            = 4096
  volume_gb         = 32
  volume_type       = "fast.ru-9a"
}

resource "selectel_mks_nodegroup_v1" "nodegroup_2" {
  depends_on        = [selectel_mks_cluster_v1.cluster_1]
  cluster_id        = selectel_mks_cluster_v1.cluster_1.id
  project_id        = selectel_mks_cluster_v1.cluster_1.project_id
  region            = selectel_mks_cluster_v1.cluster_1.region
  availability_zone = "ru-9a"
  nodes_count       = "2"
  cpus              = 4
  ram_mb            = 4096
  volume_gb         = 32
  volume_type       = "fast.ru-9a"
}


data "selectel_mks_kubeconfig_v1" "kubeconfig" {
  cluster_id = selectel_mks_cluster_v1.cluster_1.id
  project_id = selectel_mks_cluster_v1.cluster_1.project_id
  region     = selectel_mks_cluster_v1.cluster_1.region
}

output "kubeconfig" {
  value = data.selectel_mks_kubeconfig_v1.kubeconfig.raw_config
  sensitive = true
}
