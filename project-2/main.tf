provider "aws" {
    region = "eu-north-1"
    shared_credentials_files = ["~/.aws/credentials"]
    profile = "default"
}

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
}

module "azizs_webserver" {
    source = "./modules/webserver"
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.0.0/16"
    web_server = "Aziz"
    ami = "ami-0fd303abd14827300"
    instance_type = "t3.micro"
}