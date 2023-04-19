variable "project_name" {
    description = "Value for Tags"
    type = string
}

variable "subnet_used" {
  description = "Which subnet will be used by EC2"
  type = string
}

variable "sg_used" {
  description = "Which security group will be used by EC2"
  type = list
}

output "EC2id"{
  description = "EC2 ID that create"
  value = [for s in aws_instance.EC2 : s.id[*]]
  
}