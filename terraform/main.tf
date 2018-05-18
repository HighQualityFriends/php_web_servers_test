provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "web_server" {
  ami           = "${var.tests_ami}"
  instance_type = "${var.web_server_instance_type}"
  key_name      = "${var.tests_key_name}"
  subnet_id  = "${element(data.aws_subnet_ids.all.ids, 0)}"
  vpc_security_group_ids = ["${aws_security_group.sg_php_web_servers_test.id}"]
  tags {
    Name = "php_web_servers_test_web_server"
  }
  connection {
    user = "ubuntu"
    agent = true
  }

   provisioner "file" {
    source      = "./run_linux_tweaks.sh"
    destination = "/home/ubuntu/run_linux_tweaks.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "sudo bash /home/ubuntu/run_linux_tweaks.sh",
      "sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common git mc make",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) edge\"",
      "sudo apt-get update",
      "sudo apt-get install -y docker-ce='18.05.0~ce~3-0~ubuntu'",
      "sudo docker swarm init",
      "sudo docker run -d -p 5000:5000 --name registry --restart always registry:2",
      "git clone --depth=1 https://github.com/HighQualityFriends/php_web_servers_test.git",
      "cd php_web_servers_test",
      "sudo make install_vendors",
      "sudo make deploy_images"
    ]
  }
}

resource "aws_instance" "benchmark_server" {
  ami           = "${var.tests_ami}"
  instance_type = "${var.benchmark_server_instance_type}"
  key_name      = "${var.tests_key_name}"
  subnet_id  = "${element(data.aws_subnet_ids.all.ids, 0)}"
  vpc_security_group_ids = ["${aws_security_group.sg_php_web_servers_test.id}"]
  tags {
    Name = "php_web_servers_test_benchmark_server"
  }

  connection {
    user = "ubuntu"
    agent = true
  }

   provisioner "file" {
    source      = "./run_linux_tweaks.sh"
    destination = "/home/ubuntu/run_linux_tweaks.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "sudo bash /home/ubuntu/run_linux_tweaks.sh",
      "sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common git mc make apache2-utils",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) edge\"",
      "sudo apt-get update",
      "sudo apt-get install -y docker-ce='18.05.0~ce~3-0~ubuntu'",
      "git clone --depth=1 https://github.com/HighQualityFriends/php_web_servers_test.git",
      "cd php_web_servers_test",
      "sudo make install_vendors"
    ]
  }
}