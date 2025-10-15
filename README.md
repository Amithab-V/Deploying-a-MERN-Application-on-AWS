# Deploying-a-MERN-Application-on-AWS
Assignment - Deploying a MERN Application on AWS

Part 1: Infrastructure Setup with Terraform
1. AWS Setup and Terraform Initialization:
   - Configure AWS CLI and authenticate with your AWS account.
o	aws configure
o	AWS_ACCESS_KEY_ID/AWS_SECRET_ACCESS_KEY.
   - Initialize a new Terraform project targeting AWS.
o	cd terraform
o	terraform init
o	terraform plan -out plan.tfplan
o	terraform apply "plan.tfplan"

2. VPC and Network Configuration:
   - Create an AWS VPC with two subnets: one public and one private
   - Set up an Internet Gateway and a NAT Gateway.
   - Configure route tables for both subnets.

o	aws ec2 create-vpc --cidr-block 10.0.0.0/16
o	aws ec2 modify-vpc-attribute --vpc-id <vpc-id> --enable-dns-support "{\"Value\":true}"
o	aws ec2 modify-vpc-attribute --vpc-id <vpc-id> --enable-dns-hostnames "{\"Value\":true}"
o	# Public Subnet
o	aws ec2 create-subnet --vpc-id <vpc-id> --cidr-block 10.0.1.0/24 --availability-zone <az>
o	# Private Subnet
o	aws ec2 create-subnet --vpc-id <vpc-id> --cidr-block 10.0.2.0/24 --availability-zone <az>
o	aws ec2 create-internet-gateway
o	aws ec2 attach-internet-gateway --internet-gateway-id <igw-id> --vpc-id <vpc-id>
o	aws ec2 allocate-address --domain vpc
o	aws ec2 create-nat-gateway --subnet-id <public-subnet-id> --allocation-id <eip-alloc-id>
o	# Public Route Table
o	aws ec2 create-route-table --vpc-id <vpc-id>
o	# Private Route Table
o	aws ec2 create-route-table --vpc-id <vpc-id> 
o	# Public
o	aws ec2 associate-route-table --route-table-id <public-rtb-id> --subnet-id <public-subnet-id>

o	# Private
o	aws ec2 associate-route-table --route-table-id <private-rtb-id> --subnet-id <private-subnet-id>

o	# Public Route Table: Route to Internet Gateway
o	aws ec2 create-route --route-table-id <public-rtb-id> --destination-cidr-block 0.0.0.0/0 --gateway-id <igw-id>

o	# Private Route Table: Route to NAT Gateway
o	aws ec2 create-route --route-table-id <private-rtb-id> --destination-cidr-block 0.0.0.0/0 --nat-gateway-id <nat-gw-id>


3. EC2 Instance Provisioning:
   - Launch two EC2 instances: one in the public subnet (for the web server) and another in the private subnet (for the database).
   - Ensure both instances are accessible via SSH (public instance only accessible from your IP).

o	aws ec2 create-security-group \
o	--group-name WebSG \
o	--description "Allow SSH and HTTP from my IP" \
o	--vpc-id <vpc-id>
o	aws ec2 authorize-security-group-ingress \
o	--group-id <web-sg-id> \
o	--protocol tcp \
o	--port 22 \
o	--cidr <your-ip>/32

o	aws ec2 authorize-security-group-ingress \
o	--group-id <web-sg-id> \
o	--protocol tcp \
o	--port 80 \
o	--cidr 0.0.0.0/0
o	aws ec2 run-instances \
o	  --image-id <ami-id> \
o	  --count 1 \
o	  --instance-type t2.micro \
o	  --key-name <your-key-name> \
o	  --security-group-ids <web-sg-id> \
o	  --subnet-id <public-subnet-id> \
o	  --associate-public-ip-address \
o	  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=WebServer}]'
o	aws ec2 run-instances \
o	  --image-id <ami-id> \
o	  --count 1 \
o	  --instance-type t2.micro \
o	  --key-name <your-key-name> \
o	  --security-group-ids <db-sg-id> \
o	  --subnet-id <private-subnet-id> \
o	  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Database}]'
o	
4. Security Groups and IAM Roles:
   - Create necessary security groups for web and database servers.
   - Set up IAM roles for EC2 instances with required permissions.
o	aws iam create-instance-profile \
o	--instance-profile-name EC2BasicProfile

o	aws iam add-role-to-instance-profile \
o	--instance-profile-name EC2BasicProfile \
o	--role-name EC2BasicRole
5. Resource Output:
   - Output the public IP of the web server EC2 instance.


Part 2: Configuration and Deployment with Ansible
1. Ansible Configuration:
   - Configure Ansible to communicate with the AWS EC2 instances.
		sudo apt update
sudo apt install ansible -y
pip install boto3 botocore


	web
	webserver ansible_host=<public-ip> ansible_user=ec2-user ansible_ssh_private_key_file=~/path/to/my-key.pem

	[db]
	dbserver ansible_host=<private-ip> ansible_user=ec2-user ansible_ssh_private_key_file=~/path/to/my-key.pem
2. Web Server Setup:
   - Write an Ansible playbook to install Node.js and NPM on the web server.
   - Clone the MERN application repository and install dependencies.
o	ansible-playbook -i hosts.ini deploy_mern.yml
3. Database Server Setup:
   - Install and configure MongoDB on the database server using Ansible.
   - Secure the MongoDB instance and create necessary users and databases.
o	ansible-playbook -i hosts.ini setup_mongodb.yml
4. Application Deployment:
   - Configure environment variables and start the Node.js application.
   - Ensure the React frontend communicates with the Express backend.
5. Security Hardening:
   - Harden the security by configuring firewalls and security groups.
   - Implement additional security measures as needed 

