# Create vpc for EKS

resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = true 
  enable_dns_support = true

  tags = {
    Name = var.tags.vpc
  }
}

# Create EKS public subnets

resource "aws_subnet" "public_subnets" {
  for_each                = var.public_subnets
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = lookup(each.value, "az", null)
  map_public_ip_on_launch = true

  tags = {
    Name = each.key
  }
}

# Create EKS private subnets

resource "aws_subnet" "private_subnets" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = lookup(each.value, "az", null)

  tags = {
    Name = each.key
  }
}

# Create Internet Gateway for EKS public subnets

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.tags.internet_gateway
  }
}

# Create elastic ip for EKS Cluster

resource "aws_eip" "elastic_ip" {
  domain   = "vpc"
  depends_on = [aws_internet_gateway.internet_gateway]

  tags = {
    Name = var.tags.elastic_ip
  }
}

# Create NAT gateway for EKS private subnets

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id      = aws_subnet.public_subnets[var.public_subnets.eks-public-1.key].id

  tags = {
    Name = var.tags.nat_gateway
  }
  depends_on = [aws_internet_gateway.internet_gateway]
}

# Create Public Route Table for EKS public subnets

resource "aws_route_table" "publicRT" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = var.tags.publicRT
  }
}

# Create Private Route table for EKS private subnets

resource "aws_route_table" "privateRT" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  
  tags = {
    Name = var.tags.privateRT
  }
}

# Attach Public Route table to EKS public subnets

resource "aws_route_table_association" "publicRT_association" {
  for_each       = var.public_subnets
  subnet_id      = aws_subnet.public_subnets[each.key].id
  route_table_id = aws_route_table.publicRT.id
}

# Attach Private Route table to EKS private subnets

resource "aws_route_table_association" "privateRT_association" {
  for_each       = var.private_subnets
  subnet_id      = aws_subnet.private_subnets[each.key].id
  route_table_id = aws_route_table.privateRT.id
}