/*

resource "aws_elb" "AppELB" {
  name = "VIMN-ELB"
  internal           = false
  security_groups    = var.elb_sg
  subnets            = [var.elb_subnet]

  

    listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

   health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
    
  //count = var.no_of_instance
  
  for_each = {
    instances= ["}${var.EC2list[0]"]
  }
  
  //instances = ["${var.EC2list[0][{count.index}]}"]

  
  tags = {
    Name = var.project_name
  }
}

*/

resource "aws_lb" "application-lb" {
  name               = "VIMN-ALB-PoC"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.elb_sg
  subnets            =  [var.elb_subnet,var.elb_subnet2]
  tags = {
    Name = var.project_name
  }
}




resource "aws_lb_target_group" "vimn-tg" {
  name        = "vimn-project-tg-PoC"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.elb_vpc

 health_check {
    enabled  = true
    interval = 10
    path     = "/login"
    port     = 80
    protocol = "HTTP"
  }

  tags = {
    Name = var.project_name
  }
}

resource "aws_lb_listener" "vinm-listener-http" {
  load_balancer_arn = aws_lb.application-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vimn-tg.arn
  }
}

resource "aws_alb_target_group_attachment" "tgattachment" {
  count            = var.no_of_instance
  target_group_arn = aws_lb_target_group.vimn-tg.arn
  //target_id        = [for i in count.index : var.EC2list[i]]
  target_id        = element(var.EC2list[*][0], count.index)
}
