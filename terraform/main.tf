module "vpc" {
  source = "./modules/vpc"
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "s3" {
  source     = "./modules/s3"
  bucket_name = var.bucket_name
}

module "eks" {
  cluster_name = var.cluster_name
  source      = "./modules/eks"
  vpc_id      = module.vpc.vpc_id
  subnet_ids = var.private_subnets
}
