output "web_public_ip" {
description = "Public IP of web server"
value = aws_instance.web.public_ip
}


output "web_public_dns" {
value = aws_instance.web.public_dns
}


output "db_private_ip" {
value = aws_instance.db.private_ip
}
}