terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.2"
    }
  }
}

provider "aws" {
   region = "eu-north-1"
   access_key = "AKIA23DWV2JOQZ7B47EZ"
   secret_key = "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"
}

resource "aws_vpc" "terraform-ubuntu-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true #gives you an internal domain name
  enable_dns_hostnames = true #gives you an internal host name
  instance_tenancy = "default"    
  
  tags = {
    Name = "terraform-ubuntu-vpc"
  }
}

resource "aws_subnet" "terraform-ubuntu-subnet-1" {
  vpc_id     = "${aws_vpc.terraform-ubuntu-vpc.id}"
  map_public_ip_on_launch = true //it makes this a public subnet
  availability_zone = "eu-north-1c"
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "terraform-ubuntu-subnet-1"
  }
}

resource "aws_internet_gateway" "terraform-ubuntu-igw" {
    vpc_id = "${aws_vpc.terraform-ubuntu-vpc.id}"
    tags = {
        Name = "terraform-ubuntu-igw"
    }
}

resource "aws_route_table" "terraform-ubuntu-public-crt" {
    vpc_id = "${aws_vpc.terraform-ubuntu-vpc.id}"
    
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0" 
        //CRT uses this IGW to reach internet
        gateway_id = "${aws_internet_gateway.terraform-ubuntu-igw.id}" 
    }
    
    tags = {
        Name = "terraform-ubuntu-public-crt"
    }
}

resource "aws_route_table_association" "terraform-ubuntu-crta-public-subnet-1"{
    subnet_id = "${aws_subnet.terraform-ubuntu-subnet-1.id}"
    route_table_id = "${aws_route_table.terraform-ubuntu-public-crt.id}"
}

resource "aws_security_group" "terraform-ubuntu-sg" {
    
    name = "terraform-ubuntu-sg"
    vpc_id = aws_vpc.terraform-ubuntu-vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 8443
        to_port = 8443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    #egress {
    #    from_port = 0
    #    to_port = 0
    #    protocol = "-1"
    #    cidr_blocks = ["0.0.0.0/0"]
    #}

    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 8443
        to_port = 8443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "terraform-ubuntu" {
  ami = "ami-01763927c1f3a3794"
  instance_type = "t3.medium"
  key_name = "DO180"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.terraform-ubuntu-sg.id}"]
  subnet_id = "${aws_subnet.terraform-ubuntu-subnet-1.id}"
  #user_data = "${file("copy_shell_file_to_homedir.sh")}"

  provisioner "file" {
    source      = "~/Terraform/Project-1/install_openshift_original_ubuntu.sh"
    destination = "/home/ubuntu/install_openshift_original_ubuntu.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/aws-course/DO180.pem")
      host        = self.public_dns
    }
  }

  tags = {
    Name = "terraform-ubuntu"
  }
  monitoring = true
}


