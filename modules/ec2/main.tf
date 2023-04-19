data "aws_ami" "amazon" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  
  owners = ["amazon"]
  
}
resource "aws_key_pair" "my_instance_key_pair" {
    key_name = "vimn-infra"
    public_key = file("./modules/ec2/vimn-aws.pub")
}

resource "aws_instance" "EC2" {
  ami           = data.aws_ami.amazon.id
  instance_type = "t2.micro"
  associate_public_ip_address = true 
 
  subnet_id = var.subnet_used
  vpc_security_group_ids = var.sg_used
  count = 2
  key_name = aws_key_pair.my_instance_key_pair.key_name

  tags = {
    Name = "${var.project_name}-${count.index+1}"
  }
}




