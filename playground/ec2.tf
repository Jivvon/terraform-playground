module "ec2_instance" {
  source = "../modules/instance"

  vpc_id            = var.vpc_id
  subnet_id         = var.subnet_id
  security_group_id = var.security_group_id
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  instance_name     = var.instance_name
  key_name          = var.key_name
}
