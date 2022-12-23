variable "vpc_id" {
    type = string
    description = "vpc_id"
}

variable "cidr_block" {
    type = string
    description = "Subnet cidr block"
}

variable "web_server" {
    type = string
    description = "web server"
}

variable "ami" {
    type = string
    description = "ami"  
}

variable "instance_type" {
    type = string
    description = "instance_type"
}