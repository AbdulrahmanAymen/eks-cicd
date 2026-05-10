module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs                     = data.aws_availability_zones.azs.names
  public_subnets          = var.public_subnets
  map_public_ip_on_launch = true
  enable_dns_hostnames    = true

  tags = {
    Name        = var.vpc_name
    Terraform   = "true"
    Environment = "dev"
  }

  public_subnet_tags = {
    Name = "jenkins-subnet"
  }
}

module "sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = var.jenkins_security_group
  description = "Security Group for Jenkins Server"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    { from_port = 8080, to_port = 8080, protocol = "tcp", cidr_blocks = "0.0.0.0/0", description = "Jenkins" },
    { from_port = 443,  to_port = 443,  protocol = "tcp", cidr_blocks = "0.0.0.0/0", description = "HTTPS" },
    { from_port = 80,   to_port = 80,   protocol = "tcp", cidr_blocks = "0.0.0.0/0", description = "HTTP" },
    { from_port = 22,   to_port = 22,   protocol = "tcp", cidr_blocks = "0.0.0.0/0", description = "SSH" },
    { from_port = 9000, to_port = 9000, protocol = "tcp", cidr_blocks = "0.0.0.0/0", description = "SonarQube" }
  ]

  egress_with_cidr_blocks = [
    { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = "0.0.0.0/0" }
  ]

  tags = { Name = "jenkins-sg" }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.0"

  name                        = var.jenkins_ec2_instance
  instance_type               = var.instance_type
  ami                         = data.aws_ami.amazon-linux.id
  key_name                    = "jenkins_server_keypair"
  monitoring                  = true
  vpc_security_group_ids      = [module.sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data                   = file("${path.module}/../scripts/install_build_tools.sh")

  tags = {
    Name        = "Jenkins-Server"
    Terraform   = "true"
    Environment = "dev"
  }
}
