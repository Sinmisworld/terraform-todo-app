provider "aws" {
  region  = var.region
  profile = "dev-admin"
}

# ------------------------------
# IAM Role for EC2
# ------------------------------
resource "aws_iam_role" "todo_app_role" {
  name = "todo-app-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "todo_app_policy" {
  name = "todo-app-policy"
  role = aws_iam_role.todo_app_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Scan",
          "dynamodb:DeleteItem"
        ]
        Resource = aws_dynamodb_table.todo_table.arn
      }
    ]
  })
}

resource "aws_iam_instance_profile" "todo_app_profile" {
  name = "todo-app-profile"
  role = aws_iam_role.todo_app_role.name
}

# ------------------------------
# DynamoDB Table
# ------------------------------
resource "aws_dynamodb_table" "todo_table" {
  name         = "todo-table"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

# ------------------------------
# Security Group for EC2
# ------------------------------
resource "aws_security_group" "todo_sg" {
  name        = "todo-sg"
  description = "Allow SSH and Flask app traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ------------------------------
# EC2 Instance
# ------------------------------
resource "aws_instance" "todo_app" {
  ami           = "ami-0254b2d5c4c472488" # Example Amazon Linux 2 AMI ID (update per region)
  instance_type = var.instance_type
  key_name      = "todo-app-key"

  iam_instance_profile = aws_iam_instance_profile.todo_app_profile.name
  security_groups      = [aws_security_group.todo_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y python3 git
              pip3 install flask boto3
              cd /home/ec2-user
              git clone https://github.com/sinmisworld/terraform-todo-app.git
              cd terraform-todo-app/app
              # Use nohup to run the app in the background and log its output
              nohup python3 app.py > /home/ec2-user/app.log 2>&1 &
              EOF

  tags = {
    Name = "todo-app-instance"
  }
}

# ------------------------------
# Outputs
# ------------------------------
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.todo_app.public_ip
}

output "application_url" {
  description = "URL to access the Todo application"
  value       = "http://${aws_instance.todo_app.public_ip}:5000"
}

output "ssh_connection_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ~/.ssh/todo-app-key.pem ec2-user@${aws_instance.todo_app.public_ip}"
}
