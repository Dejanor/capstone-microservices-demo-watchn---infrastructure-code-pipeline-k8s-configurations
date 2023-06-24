# Create EKS Cluster

resource "aws_eks_cluster" "eks-cluster-1" {
  name     = var.cluster_name.cluster_name_1
  role_arn = aws_iam_role.eks-cluster-role.arn

  vpc_config {
    security_group_ids = [aws_security_group.eks_sg.id]
    subnet_ids = [aws_subnet.private_subnets[var.private_subnets.eks-private-1.key].id, aws_subnet.private_subnets[var.private_subnets.eks-private-2.key].id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSVPCResourceController,
  ]
}

# Create EKS Cluster node group

resource "aws_eks_node_group" "eks-node-group-1" {
  cluster_name    = aws_eks_cluster.eks-cluster-1.name
  node_group_name = "watchn-prod-node-group"
  node_role_arn   = aws_iam_role.eks-nodes-role.arn
  instance_types = ["t2.medium"]
  subnet_ids      = [aws_subnet.private_subnets[var.private_subnets.eks-private-1.key].id, aws_subnet.private_subnets[var.private_subnets.eks-private-2.key].id]

  scaling_config {
    desired_size = 3
    max_size     = 5
    min_size     = 3
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}

# output "endpoint" {
#   value = aws_eks_cluster.eks-cluster-1.endpoint
# }

# output "kubeconfig-certificate-authority-data" {
#   value = aws_eks_cluster.eks-cluster-1.certificate_authority[0].data
# }

# Create EKS Cluster

resource "aws_eks_cluster" "eks-cluster-2" {
  name     = var.cluster_name.cluster_name_2
  role_arn = aws_iam_role.eks-cluster-role.arn

  vpc_config {
    security_group_ids = [aws_security_group.eks_sg.id]
    subnet_ids = [aws_subnet.private_subnets[var.private_subnets.eks-private-1.key].id, aws_subnet.private_subnets[var.private_subnets.eks-private-2.key].id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSVPCResourceController,
  ]
}

# Create EKS Cluster node group

resource "aws_eks_node_group" "eks-node-group-2" {
  cluster_name    = aws_eks_cluster.eks-cluster-2.name
  node_group_name = "watchn-dev-node-group"
  node_role_arn   = aws_iam_role.eks-nodes-role.arn
  instance_types = ["t2.medium"]
  subnet_ids      = [aws_subnet.private_subnets[var.private_subnets.eks-private-1.key].id, aws_subnet.private_subnets[var.private_subnets.eks-private-2.key].id]

  scaling_config {
    desired_size = 3
    max_size     = 5
    min_size     = 3
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}

output "endpoint" {
  value = aws_eks_cluster.eks-cluster-2.endpoint
}

output "kubeconfig-certificate-authority-data-dev" {
  value = aws_eks_cluster.eks-cluster-2.certificate_authority[0].data
}
