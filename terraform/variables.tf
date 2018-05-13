variable "tests_key_name" {
  type = "string"
  default = "tests"
}

variable "web_server_instance_type" {
  type = "string"
  default = "t2.micro"
}

variable "benchmark_server_instance_type" {
  type = "string"
  default = "t2.micro"
}

variable "tests_ami" {
  type = "string"
  default = "ami-f90a4880"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.default.id}"
}