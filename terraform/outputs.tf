output "web_server.ip" {
  value = "${aws_instance.web_server.public_ip}"
}

output "web_server.private_ip" {
  value = "${aws_instance.web_server.private_ip}"
}

output "benchmark_server.ip" {
  value = "${aws_instance.benchmark_server.public_ip}"
}