module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = var.cluster_name
  cluster_version = "1.31"

  # Optional
  cluster_endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  count = 2
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

resource "aws_kms_key" "example" {
  description = "KMS key for EKS cluster"
  is_enabled  = true
}

resource "aws_kms_alias" "this" {
  name          = "alias/eks/${var.cluster_name}"
  target_key_id = aws_kms_key.example.key_id
}

resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/eks/${var.cluster_name}/cluster"
}