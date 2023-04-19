variable "project_name" {
    description = "Value for Tags"
    type = string
}

variable "elb_sg" {
    description = "Security Group for LB"
    type = list
}

variable "elb_subnet" {
    description = "Value for subnet"
    type = string
}

variable "elb_subnet2" {
    description = "Value for subnet"
    type = string
}
variable "no_of_instance" {}

variable "EC2list" {}

variable "elb_vpc" {}