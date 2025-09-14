provider "aws" {
  region = "us-east-1"
}

# ------------------------------
# DynamoDB Table
# ------------------------------
resource "aws_dynamodb_table" "todo_table" {
  name         = "todo-items"
  billing_mode = "PAY_PER_REQUEST"

  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  # TODO: Add another attribute if you want (check docs)
}

# ------------------------------
# Security Group for EC2
# ------------------------------
resource "aws_security_group" "todo_sg" {
  name        = "todo-sg"
  description = "Allow SSH and HTTP"

  # TODO: Add ingress for SSH (22)
  # TODO: Add ingress for HTTP (5000)
  # TODO: Add egress for all outbound traffic
}

# ------------------------------
# EC2 Instance
# ------------------------------
resource "aws_instance" "todo_app" {
  # TODO: Add AMI (Amazon Linux 2)
  # TODO: Add instance_type (t2.micro)
  # TODO: Attach security group
  # TODO: Add user_data to install Flask app

  tags = {
    Name = "ToDoAppServer"
  }
}
