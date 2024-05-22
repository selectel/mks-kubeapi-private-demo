variable "domain" {

}

variable "domain_password" {
  
}

variable "project_password" {
  
}

provider "selectel" {
  domain_name = var.domain
  username    = "webinar"
  password    = var.domain_password
}

resource "selectel_vpc_project_v2" "project_1" {
  name = "webinar"
}

resource "selectel_iam_serviceuser_v1" "serviceuser_1" {
  name     = "webinar-project-user"
  password = var.project_password
  role {
    role_name  = "member"
    scope      = "project"
    project_id = selectel_vpc_project_v2.project_1.id
  }
}

provider "openstack" {
  auth_url    = "https://cloud.api.selcloud.ru/identity/v3"
  domain_name = var.domain
  tenant_id   = selectel_vpc_project_v2.project_1.id
  user_name   = selectel_iam_serviceuser_v1.serviceuser_1.name
  password    = selectel_iam_serviceuser_v1.serviceuser_1.password
  region      = "ru-9"
}
