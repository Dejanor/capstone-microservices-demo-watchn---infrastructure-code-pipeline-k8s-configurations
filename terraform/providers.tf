terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = ">= 4.0"
    namedotcom = {
      source  = "lexfrei/namedotcom"
      version = "1.2.5"
    }    
  }

  backend "s3" {
    region         = "eu-west-2"
    bucket         = "janortop5-tf-state"
    key            = "capstone/terraform.tfstate"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

provider "namedotcom" {
  username = var.namedotcom_username
  token    = var.namedotcom_token
}

data "aws_eks_cluster" "eks-cluster-1" {
  name = var.cluster_name.cluster_name_1
  depends_on = [
    aws_eks_cluster.eks-cluster-1
  ]
}

data "aws_eks_cluster" "eks-cluster-2" {
  name = var.cluster_name.cluster_name_2
  depends_on = [
    aws_eks_cluster.eks-cluster-2
  ]
}

# data "aws_eks_cluster_auth" "cluster-1" {
#   name = var.cluster_name.cluster_name_1
# }

# data "aws_eks_cluster_auth" "cluster-2" {
#   name = var.cluster_name.cluster_name_1
# }

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks-cluster-1.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks-cluster-1.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.eks-cluster-1.name]
      command     = "aws"
    }
  }
  alias           = "cluster1"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks-cluster-1.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks-cluster-1.certificate_authority.0.data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.eks-cluster-1.name]
    command     = "aws"
  }
  alias         = "cluster1"
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks-cluster-2.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks-cluster-2.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.eks-cluster-2.name]
      command     = "aws"
    }
  }
  alias           = "cluster2"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks-cluster-2.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks-cluster-2.certificate_authority.0.data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.eks-cluster-2.name]
    command     = "aws"
  }
  alias         = "cluster2"
}
