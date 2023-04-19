resource "aws_vpc" "para_PoC_vpc01" {
  cidr_block = "192.168.0.0/16"
  
  tags = {
    Name = var.project_name
  }
}

data "aws_availability_zones" "azs" {
//  provider = aws.region-master
  state    = "available"
}


resource "aws_subnet" "subnet01" {
  vpc_id     = aws_vpc.para_PoC_vpc01.id
  count = length(var.public_subnet_cidr_blocks)
  availability_zone = element(data.aws_availability_zones.azs.names, count.index)
  cidr_block = var.public_subnet_cidr_blocks[count.index]

  tags = {
    Name = var.project_name
  }
}

resource "aws_security_group" "sg" {
  name = var.sg_name
  vpc_id = aws_vpc.para_PoC_vpc01.id

  /*
  ingress {
    cidr_blocks = [aws_subnet.subnet01.cidr_block]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
  */

  dynamic "ingress" {
    for_each = var.service_ports
    content {
      cidr_blocks = ["0.0.0.0/0"]
      from_port = ingress.value
      to_port   = ingress.value
      protocol  = "tcp"
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = var.project_name
  }
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.para_PoC_vpc01.id

  tags = {
    Name = var.project_name
  }
}
resource "aws_route_table" "my_public_route_table" {
    vpc_id = aws_vpc.para_PoC_vpc01.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }
}

resource "aws_route_table_association" "my_public_route_table_association" {
  subnet_id = aws_subnet.subnet01[0].id
  route_table_id = aws_route_table.my_public_route_table.id
}
