data "aws_vpc" "this" {
  id = var.vpc_id
}

data "aws_subnet" "this" {
  id = var.subnet_id
}

data "aws_security_group" "this" {
  id = var.security_group_id
}

resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [data.aws_security_group.this.id]
  subnet_id              = data.aws_subnet.this.id
  key_name               = var.key_name

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_type = "gp3"
    volume_size = 20
  }

  tags = {
    Name = var.instance_name
  }
}
