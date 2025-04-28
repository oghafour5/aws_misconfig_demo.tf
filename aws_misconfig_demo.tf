provider "aws" {
  region = "us-east-1"
}

# SECURITY FLAW: Publicly exposed S3 bucket
resource "aws_s3_bucket" "insecure_bucket" {
  bucket = "my-insecure-bucket-example"
  acl    = "public-read"  # FLAW: Makes bucket publicly readable
}

resource "aws_s3_bucket_policy" "insecure_policy" {
  bucket = aws_s3_bucket.insecure_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = "*",
        Action = "s3:GetObject",
        Resource = "${aws_s3_bucket.insecure_bucket.arn}/*"
      }
    ]
  })
}

# SECURITY FLAW: Open security group
resource "aws_security_group" "open_sg" {
  name        = "open-sg"
  description = "Allow all inbound traffic"
  vpc_id      = "vpc-12345678"  # Replace with your VPC

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # FLAW: Open to the entire internet
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# SECURITY FLAW: Hardcoded AWS access credentials
provider "aws" {
  access_key = "FAKEACCESSKEY123"
  secret_key = "FAKESECRETKEY456"
  region     = "us-east-1"
}
