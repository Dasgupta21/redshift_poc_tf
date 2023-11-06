# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

# Create Subnets (at least two subnets in different AZs)
resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2b"
}

resource "aws_redshift_subnet_group" "my_redshift_subnet_group" {
  name = "my-redshift-subnet-group"
  description = "My Redshift subnet group"
  subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
}


resource "aws_security_group" "redshift_security_group" {
  name        = "redshift-sg"
  description = "Redshift security group"

  vpc_id = aws_vpc.my_vpc.id  # Reference the VPC you created

  # Define inbound and outbound rules as needed
  # Example:
   ingress {
     from_port   = 5439  # Redshift port
     to_port     = 5439
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]  # You should restrict this to specific IPs or subnets
   }
   egress {
    from_port   = 5439  # Redshift port
     to_port     = 5439
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
}


