provider "aws" {
    region = "ap-southeast-2"
}

module "base-network" {
  source                                      = "cn-terraform/networking/aws"
  version                                     = "2.0.12"
  name_preffix                                = "TF-Network"
  vpc_cidr_block                              = "192.168.0.0/16"
  availability_zones                          = ["ap-southeast-2a", "ap-southeast-2b"]
  public_subnets_cidrs_per_availability_zone  = ["192.168.0.0/19", "192.168.32.0/19"]
  private_subnets_cidrs_per_availability_zone = ["192.168.128.0/19", "192.168.160.0/19"]
}

module "ecs-fargate" {
  source  = "cn-terraform/ecs-fargate/aws"
  version = "2.0.26"
  assign_public_ip    = true
  name_preffix        = "test"
  vpc_id              = module.base-network.vpc_id
  #container_image     = "nginx"
  #container_name      = "test"
  public_subnets_ids  = module.base-network.public_subnets_ids
  private_subnets_ids = module.base-network.private_subnets_ids
  lb_enable_https = false
}