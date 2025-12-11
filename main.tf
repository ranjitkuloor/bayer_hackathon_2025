locals {
  project_name = var.project_name
}

module "vpc" {
  source       = "./modules/vpc"
  region       = var.region
  project_name = local.project_name
}

module "subnets" {
  source             = "./modules/subnets"
  vpc_id             = module.vpc.vpc_id
  availability_zones = var.availability_zones
  project_name       = local.project_name
}

module "internet_gateway" {
  source       = "./modules/internet_gateway"
  vpc_id       = module.vpc.vpc_id
  project_name = local.project_name
}

module "route_tables" {
  source            = "./modules/route_tables"
  vpc_id            = module.vpc.vpc_id
  igw_id            = module.internet_gateway.igw_id
  public_subnet_ids = module.subnets.public_subnet_ids
  project_name      = local.project_name
}

module "eks_roles" {
  source       = "./modules/eks_roles"
  project_name = local.project_name
}

module "eks_cluster" {
  source       = "./modules/eks_cluster"
  cluster_name = var.cluster_name
  subnet_ids   = module.subnets.private_subnet_ids
  role_arn     = module.eks_roles.eks_role_arn
}

module "node_group" {
  source        = "./modules/node_group"
  cluster_name  = var.cluster_name
  project_name  = local.project_name
  subnet_ids    = module.subnets.private_subnet_ids
  node_role_arn = module.eks_roles.node_role_arn
  desired_size  = var.node_desired_size
  max_size      = var.node_max_size
  min_size      = var.node_min_size
  instance_type = var.node_instance_type
  #depends_on = [ module.eks_cluster ]
}