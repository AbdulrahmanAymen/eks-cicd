aws_region             = "us-east-1"
vpc_name               = "jenkins-vpc"
vpc_cidr               = "10.0.0.0/16"
public_subnets         = ["10.0.1.0/24"]
jenkins_security_group = "jenkins-sg"
jenkins_ec2_instance   = "jenkins-server"
instance_type          = "t2.medium"
