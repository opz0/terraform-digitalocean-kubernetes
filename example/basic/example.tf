provider "digitalocean" {

}

locals {
  name        = "app"
  environment = "test"
  region      = "nyc3"
}

##------------------------------------------------
## VPC module call
##------------------------------------------------
module "vpc" {
  source      = "git::https://github.com/cypik/terraform-digitalocean-vpc.git?ref=v1.0.0"
  name        = "shyam"
  environment = local.environment
  region      = local.region
  ip_range    = "10.22.0.0/16"
}
##------------------------------------------------
## Kubernetes module call
##------------------------------------------------
module "cluster" {
  source          = "./../../"
  name            = local.name
  environment     = local.environment
  region          = local.region
  cluster_version = "1.27.6-do.0"
  vpc_uuid        = module.vpc.id

  critical_node_pool = {
    critical_node = {
      node_count = 1
      min_nodes  = 1
      max_nodes  = 1
      size       = "s-2vcpu-4gb"
    }
  }

  app_node_pools = {
    app_node = {
      node_count = 1
      min_nodes  = 1
      max_nodes  = 1
      size       = "s-2vcpu-4gb"
    }
  }
}
