# Create security group for EKS Cluster

resource "aws_security_group" "eks_sg" {
  name        = var.eks_sg.name
  description = var.eks_sg.description
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = var.eks_sg.eks_from_port
    to_port     = var.eks_sg.eks_to_port
    protocol    = "tcp"
    cidr_blocks = var.eks_cidr_block
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = var.tags.sg
  }
}


