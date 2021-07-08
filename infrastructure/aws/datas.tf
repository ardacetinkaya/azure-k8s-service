data "aws_availability_zones" "available" {
}

data "aws_eks_cluster" "cluster" {
  name = module.k8s_cluster_01.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.k8s_cluster_01.cluster_id
}