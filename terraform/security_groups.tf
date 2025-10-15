resource "aws_security_group" "web_sg" {
name = "web-sg"
vpc_id = aws_vpc.main.id
description = "Allow HTTP, HTTPS and SSH from my IP"


ingress {
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = [var.my_ip]
description = "SSH from admin"
}
ingress {
from_port = 80
to_port = 80
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
ingress {
from_port = 443
to_port = 443
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}


egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
}


# DB SG (only allow traffic from web sg)
resource "aws_security_group" "db_sg" {
name = "db-sg"
vpc_id = aws_vpc.main.id
description = "Allow MongoDB from web tier only"


ingress {
from_port = 27017
to_port = 27017
protocol = "tcp"
security_groups = [aws_security_group.web_sg.id]
description = "MongoDB from web server"
}


egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
}