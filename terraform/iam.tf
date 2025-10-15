# IAM role for EC2 to allow SSM (optional), S3 read if needed
resource "aws_iam_role" "ec2_role" {
name = "ec2-ssm-role"
assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json
}


data "aws_iam_policy_document" "ec2_assume_role_policy" {
statement {
actions = ["sts:AssumeRole"]
principals { type = "Service"; identifiers = ["ec2.amazonaws.com"] }
}
}


resource "aws_iam_role_policy_attachment" "ssm_attach" {
role = aws_iam_role.ec2_role.name
policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


# Optionally allow S3 read access if your app needs to pull assets
resource "aws_iam_role_policy_attachment" "s3_read" {
role = aws_iam_role.ec2_role.name
policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}


resource "aws_iam_instance_profile" "ec2_profile" {
name = "ec2-instance-profile"
role = aws_iam_role.ec2_role.name
}