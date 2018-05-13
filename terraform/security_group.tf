resource "aws_security_group" "sg_php_web_servers_test" {
  name = "php_web_servers_test"
  description = "Default security group that allows inbound and outbound traffic from all instances in the VPC"
  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    self        = true
  }

  ingress {
    from_port   = "10000"
    to_port     = "10000"
    protocol    = "tcp"
  }
  
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }
  egress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}