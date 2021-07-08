locals {
  cluster_name = "k8s-cluster-01"
}

module "k8s_cluster_01" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.1.0"

  cluster_name    = local.cluster_name
  cluster_version = "1.19"
  subnets         = module.vpc.private_subnets

  vpc_id = module.vpc.vpc_id
  
  node_groups = {
    first = {
      desired_capacity = 1
      max_capacity     = 2
      min_capacity     = 1

      instance_type = "t3.small"
    }
  }

  write_kubeconfig   = true

  tags = {
    Name        = "k8s Cluster"
    Environment = "Demo"
  }
}