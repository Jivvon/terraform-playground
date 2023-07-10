module "ec2_instance" {
  source = "../modules/instance"

  vpc_id            = var.vpc_id
  subnet_id         = var.subnet_id
  security_group_id = aws_security_group.sg_lento.id
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  instance_name     = var.instance_name
  key_name          = var.key_name
}

resource "aws_security_group" "sg_lento" {
  name = "${var.instance_name}-sg"

  vpc_id = var.vpc_id
}

# TODO: var.security_group_rules의 ingress, egress 모두 순회하도록 수정
resource "aws_security_group_rule" "sg_lento_rule" {
  security_group_id = aws_security_group.sg_lento.id

  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = var.security_group_rules.ingress

  lifecycle {
    create_before_destroy = true
  }
}
