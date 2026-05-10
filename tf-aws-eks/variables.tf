variable "aws_region" {}
variable "aws_account_id" {}
variable "vpc_name" {}
variable "vpc_cidr" {}
variable "public_subnets"  { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "instance_type" {}
