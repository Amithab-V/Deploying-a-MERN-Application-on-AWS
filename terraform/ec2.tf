# Web EC2 (public subnet)
resource "aws_instance" "web" {
ami = var.ami_ubuntu
instance_type = var.instance_type_web
subnet_id = aws_subnet.public.id
key_name = var.key_name
vpc_security_group_ids = [aws_security_group.web_sg.id]
iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
associate_public_ip_address = true
tags = { Name = "mern-web" }
}


# DB EC2 (private subnet)
resource "aws_instance" "db" {
ami = var.ami_ubuntu
instance_type = var.instance_type_db
subnet_id = aws_subnet.private.id
key_name = var.key_name
vpc_security_group_ids = [aws_security_group.db_sg.id]
iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
associate_public_ip_address = false
tags = { Name = "mern-db" }
}