variable "project_name" {
    description = "Value for Tags"
    type = string
}

variable "vpc_name" {
  description = "Name of VPC, Should be service or project name"
  type = string
}

variable "subnet_name" {
  description = "Name of Subnet, Should be service or project name"
  type = string
}

variable "sg_name" {
  description = "Name of Security Group, Should be service or project name"
  type = string
}

variable "public_subnet_cidr_blocks" {
  description = "list of subnet in the VPC"
  default = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "service_ports" {
  description = "Port for ingress rule"
  type = list
}

output "subnetid" {
  value = "${aws_subnet.subnet01[0].id}"
}

output "subnetid2" {
  value = "${aws_subnet.subnet01[1].id}"
}

output "sgid" {
  value = "${aws_security_group.sg.id}"

}

output "vpcid"{
  value = "${aws_vpc.vpc01.id}"
}