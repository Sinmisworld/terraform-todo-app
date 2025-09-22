provider "aws" {
  region = var.region
  profile = "YOUR-PROFILE-NAME"
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
  name         = "# To-Do: string (table name)"
  billing_mode = "# To-Do: string (e.g. PAY_PER_REQUEST)"

  hash_key = "# To-Do: string (partition key name)"

  attribute {
    name = "# To-Do: string (attribute name)"
    type = "# To-Do: string (attribute type, e.g. S for string)"
  }
}

# ------------------------------
# Security Group for EC2
# ------------------------------
resource "aws_security_group" "todo_sg" {
  name        = "# To-Do: string (SG name)"
  description = "# To-Do: string (SG description)"

  ingress {
    from_port   = # To-Do: number (port to allow)
    to_port     = # To-Do: number (port to allow)
    protocol    = "# To-Do: string (protocol, e.g. tcp)"
    cidr_blocks = ["# To-Do: string (CIDR range, e.g. 0.0.0.0/0)"]
  }

  ingress {
    from_port   = # To-Do: number (port to allow)
    to_port     = # To-Do: number (port to allow)
    protocol    = "# To-Do: string (protocol, e.g. tcp)"
    cidr_blocks = ["# To-Do: string (CIDR range, e.g. 0.0.0.0/0)"]
  }

  egress {
    from_port   = # To-Do: number (start port, often 0)
    to_port     = # To-Do: number (end port, often 0)
    protocol    = "# To-Do: string (protocol, e.g. -1 for all)"
    cidr_blocks = ["# To-Do: string (CIDR range, e.g. 0.0.0.0/0)"]
  }
}

# ------------------------------
# EC2 Instance
# ------------------------------
resource "aws_instance" "todo_app" {
  ami           = "# To-Do: string (AMI ID)"
  instance_type = var.instance_type
  key_name      = "# To-Do: string (EC2 key pair name)"

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
              python3 app.py &
              EOF

  tags = {
    Name = "# To-Do: string (tag name for EC2 instance)"
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
  value       = "ssh -i ~/.ssh/# To-Do: string (your key name).pem ec2-user@${aws_instance.todo_app.public_ip}"
}

