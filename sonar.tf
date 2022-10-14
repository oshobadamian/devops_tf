resource "aws_vpc" "sonarVPC" {
  cidr_block = "172.16.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "sonar_VPC"
  }
}

 resource "aws_security_group" "security_sonar_group_2021" {
      name        = "security_sonar_group_2021"
      description = "security group for Sonar"
       vpc_id =aws_vpc.sonarVPC.id

      ingress {
        from_port   = 9000
        to_port     = 9000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }

     ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }

     # outbound from Sonar server
      egress {
        from_port   = 0
        to_port     = 65535
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }

      tags= {
        Name = "security_sonar"
      }
    }


    resource "aws_instance" "mySonarInstance" {
      ami           = "ami-0ee23bfc74a881de5"
      key_name = "linuxkey"
      instance_type = "t2.micro"
      tags= {
        Name = "sonar_server"
      }
    }

# Create Elastic IP address for Sonar instance
resource "aws_eip" "mySonarInstance" {
  vpc      = true
  instance = aws_instance.mySonarInstance.id
tags= {
    Name = "sonar_elastic_ip"
  }
}
