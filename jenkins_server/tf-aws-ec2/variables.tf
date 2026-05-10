variable "aws_region" {}
variable "vpc_name" {}
variable "vpc_cidr" {}
variable "public_subnets"        { type = list(string) }
variable "jenkins_security_group" {}
variable "jenkins_ec2_instance"  {}
variable "instance_type" {}
