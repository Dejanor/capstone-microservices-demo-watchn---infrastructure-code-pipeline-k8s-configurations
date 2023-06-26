variable "kms_master_key_id" {
  default = ""
}

variable "read_capacity" {
  type    = number
  default = 1
}

variable "write_capacity" {
  type    = number
  default = 1
}

variable "aws_dynamodb_table_enabled" {
  type    = bool
  default = true
}


variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type = map(any)
  default = {
    "eks-public-1" = {
      name       = "eks-public-1"
      az         = "eu-west-2a"
      cidr_block = "10.0.1.0/24"
      key        = "eks-public-1"
    },

    "eks-public-2" = {
      name       = "eks-public-2"
      az         = "eu-west-2b"
      cidr_block = "10.0.2.0/24"
      key        = "eks-public-2"
    }
  }
}
variable "private_subnets" {
  type = map(any)
  default = {
    "eks-private-1" = {
      name       = "eks-private-1"
      az         = "eu-west-2a"
      cidr_block = "10.0.3.0/24"
      key        = "eks-private-1"
    },

    "eks-private-2" = {
      name       = "eks-private-2"
      az         = "eu-west-2b"
      cidr_block = "10.0.4.0/24"
      key        = "eks-private-2"
    }
  }
}

variable "eks_sg" {
  type = map(any)
  default = {
    name           = "eks_sg"
    description    = "security group for eks cluster"
    eks_from_port  = 0
    eks_to_port    = 65535
  }
}

variable "cluster_name" {
  type = map(any)
  default = {
    cluster_name_1 = "watchn-cluster-prod"
    cluster_name_2 = "watchn-cluster-dev"
    }
}

variable "eks_cidr_block" {
  default = ["0.0.0.0/0"]
}

variable "domain" {
  type = map(any)
  default = {
    domain    = "eaaladejana.live"
    record = "*.eaaladejana.live"
    type      = "CNAME"
  }
}

variable "namedotcom_username" {
  default = "janortop5"
}

variable "namedotcom_token" {
  default = "56e15b07a343ebeadd3eea483ef1e13db6074aa0"
}

variable "tags" {
  type = map(any)
  default = {
    vpc              = "eks-vpc"
    internet_gateway = "eks-igw"
    nat_gateway      = "eks-nat-gw"
    publicRT         = "eks-publicRT"
    privateRT        = "eks-privateRT"
    elastic_ip       = "eks-eip"
    sg               = "eks_sg"
  }
}
