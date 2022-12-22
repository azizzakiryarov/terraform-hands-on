output "terraform-ubuntu-public-ip" {
  value = aws_instance.terraform-ubuntu.public_dns
}