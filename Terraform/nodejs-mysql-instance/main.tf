# Get information of existing ingfrastructure via data source
data "aws_vpc" "blue_green_vpc" {
  id = var.vpc_id
}

data "aws_security_group" "blue_green_sg" {
  tags = {
    Name = "blue-green-sg" 
  }
}

data "aws_route_table" "blue_green_rt" {
  vpc_id = data.aws_vpc.blue_green_vpc.id
  subnet_id = "subnet-065a0adefb3fcf8b1"
  
}

# New resource to create a subnet within the VPC
resource "aws_subnet" "blue_green_subnet_1c" {
  vpc_id     = data.aws_vpc.blue_green_vpc.id
  cidr_block  = "10.0.3.0/24"
  availability_zone = "us-east-1c"
  
  map_public_ip_on_launch = true

  # Optional tags for better organization
  tags = {
    Name = "blue-green-subnet-1c"
  }
}

resource "aws_route_table_association" "associate_blue_green_subnet_1c" {
  subnet_id      = aws_subnet.blue_green_subnet_1c.id
  route_table_id = data.aws_route_table.blue_green_rt.id
}

# Create an EC2 Instance for NodeJS MySQL
resource "aws_instance" "nodejs_mysql" {
  ami           = "ami-08a0d1e16fc3f61ea"  # Update with the desired AMI for Jenkins
  instance_type = "t2.micro"  # Update with the desired instance type
  key_name      = var.key_pair
  subnet_id = aws_subnet.blue_green_subnet_1c.id
  associate_public_ip_address = true
  vpc_security_group_ids = [data.aws_security_group.blue_green_sg.id]

  tags = {
    Name = var.instance_name
  }
}